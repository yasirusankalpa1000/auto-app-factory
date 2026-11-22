import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayOSApp());
}

class OverlayOSApp extends StatelessWidget {
  const OverlayOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayOS Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepIndigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHUDOverlayScreen(),
    );
  }
}

class MainHUDOverlayScreen extends StatefulWidget {
  const MainHUDHUDOverlayScreen({super.key});

  @override
  State<MainHUDOverlayScreen> createState() => _MainHUDOverlayScreenState();
}

class _MainHUDOverlayScreenState extends State<MainHUDOverlayScreen> {
  int _activeTab = 0;

  // Floating Overlay Bubble Position
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isBubbleExpanded = false;
  bool _overlayActive = true;

  // System Permissions States
  bool _drawOverAppsGranted = true;
  bool _notificationAccessGranted = true;

  // Utilities Data
  final List<String> _clipStack = [
    'Discount Coupon Code: SAVE50NOW',
    'Meeting link: https://meet.example.com/daily-sync',
    'Delivery Address: No. 42, Main Street, Colombo 03',
  ];
  final TextEditingController _clipInputController = TextEditingController();

  // Smart Rephraser State
  final TextEditingController _rephraseInputController = TextEditingController();
  String _rephrasedOutput = '';
  String _selectedTone = 'Professional';

  // Floating Deal / Discount Calculator State
  double _originalPrice = 12000.0;
  double _discountPercent = 15.0;
  double _taxPercent = 10.0;

  // Custom Quick Bubbles
  final List<Map<String, String>> _customBubbles = [
    {'title': 'WhatsApp Quick Rephrase', 'icon': 'text', 'category': 'Text'},
    {'title': 'Instant Price Splitter', 'icon': 'calc', 'category': 'Finance'},
    {'title': 'Floating Note Pad', 'icon': 'edit', 'category': 'Utility'},
  ];

  @override
  void dispose() {
    _clipInputController.dispose();
    _rephraseInputController.dispose();
    super.dispose();
  }

  void _rephraseText() {
    final text = _rephraseInputController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _rephrasedOutput = 'Please enter or paste text to rephrase!';
      });
      return;
    }

    setState(() {
      if (_selectedTone == 'Professional') {
        _rephrasedOutput =
            'Dear Recipient, regarding "$text", I would like to formally confirm that this action is proceeding according to our agreed guidelines.';
      } else if (_selectedTone == 'Friendly') {
        _rephrasedOutput =
            'Hey there! Just wanted to share this: "$text". Hope you are having an awesome day!';
      } else if (_selectedTone == 'Sinhala-English Casual') {
        _rephrasedOutput =
            'Machan, look at this: "$text". Meka shape neda? Let me know what you think!';
      } else if (_selectedTone == 'Bullet Points') {
        _rephrasedOutput =
            '• Main point: $text\n• Status: Ready\n• Priority: High\n• Action item: Review immediately.';
      } else {
        _rephrasedOutput = 'Shortened: ${text.length > 30 ? text.substring(0, 30) : text}...';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Content Dashboard
            Column(
              children: [
                _buildHeader(),
                _buildPermissionStatusBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _activeTab,
                    children: [
                      _buildOverlayStudioTab(),
                      _buildClipVaultTab(),
                      _buildTextRephraserTab(),
                      _buildDealCalcTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Draggable Floating Overlay Simulation
            if (_overlayActive)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                      // Clamp bounds
                      if (_bubbleX < 0) _bubbleX = 0;
                      if (_bubbleX > screenSize.width - 70) {
                        _bubbleX = screenSize.width - 70;
                      }
                      if (_bubbleY < 50) _bubbleY = 50;
                      if (_bubbleY > screenSize.height - 120) {
                        _bubbleY = screenSize.height - 120;
                      }
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton.small(
                        backgroundColor: Colors.indigo,
                        onPressed: () {
                          setState(() {
                            _isBubbleExpanded = !_isBubbleExpanded;
                          });
                        },
                        child: Icon(
                          _isBubbleExpanded ? Icons.close : Icons.widgets,
                          color: Colors.white,
                        ),
                      ),
                      if (_isBubbleExpanded) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: 240,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigo, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.bolt, color: Colors.amber, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Floating Quick HUD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.grey, height: 16),
                              _buildBubbleQuickTile(
                                icon: Icons.content_copy,
                                title: 'Clips Saved',
                                subtitle: '${_clipStack.length} items ready',
                                onTap: () {
                                  setState(() {
                                    _activeTab = 1;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                              const SizedBox(height: 6),
                              _buildBubbleQuickTile(
                                icon: Icons.text_fields,
                                title: 'Rephrase Helper',
                                subtitle: 'Instant tone modifier',
                                onTap: () {
                                  setState(() {
                                    _activeTab = 2;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                              const SizedBox(height: 6),
                              _buildBubbleQuickTile(
                                icon: Icons.calculate,
                                title: 'Deal & Discount',
                                subtitle: 'Instant % off finder',
                                onTap: () {
                                  setState(() {
                                    _activeTab = 3;
                                    _isBubbleExpanded = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTab,
        onTap: (index) {
          setState(() {
            _activeTab = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'ClipVault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Rephraser',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Deals HUD',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.apps, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OverlayOS Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Floating Universal Multitool Engine',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _overlayActive,
            activeColor: Colors.green,
            onChanged: (val) {
              setState(() {
                _overlayActive = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStatusBanner() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAxisAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _drawOverAppsGranted ? Icons.check_circle : Icons.warning,
                color: _drawOverAppsGranted ? Colors.green : Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'Display Above Apps:',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                _drawOverAppsGranted ? 'Active' : 'Disabled',
                style: TextStyle(
                  color: _drawOverAppsGranted ? Colors.green : Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _notificationAccessGranted ? Icons.check_circle : Icons.warning,
                color: _notificationAccessGranted ? Colors.green : Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'Floating HUD Sync:',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                _notificationAccessGranted ? 'Ready' : 'Off',
                style: TextStyle(
                  color: _notificationAccessGranted ? Colors.green : Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Control Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.widgets, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(
                      'Live Floating Bubble Studio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Drag the purple floating bubble anywhere on screen. Tap it to access instant micro-utilities while using Instagram, TikTok, WhatsApp, or Shopping apps!',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _bubbleX = 20;
                          _bubbleY = 180;
                          _overlayActive = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Floating bubble position reset!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reset Bubble Position'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.indigo),
                      ),
                      onPressed: () {
                        setState(() {
                          _drawOverAppsGranted = !_drawOverAppsGranted;
                          _notificationAccessGranted = !_notificationAccessGranted;
                        });
                      },
                      icon: const Icon(Icons.settings, size: 16),
                      label: const Text('Simulate System Permissions'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Custom Floating Shortcut Builder
          const Text(
            'Active Floating Action Shortcuts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _customBubbles.length,
            itemBuilder: (context, index) {
              final item = _customBubbles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      item['icon'] == 'text'
                          ? Icons.text_fields
                          : item['icon'] == 'calc'
                              ? Icons.calculate
                              : Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Category: ${item['category']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _customBubbles.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              setState(() {
                _customBubbles.add({
                  'title': 'New Floating Tool #${_customBubbles.length + 1}',
                  'icon': 'text',
                  'category': 'Custom',
                });
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Floating Action'),
          ),
        ],
      ),
    );
  }

  Widget _buildClipVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Floating ClipVault',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Never lose copied text, links, or addresses while switching apps.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Add Clip Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _clipInputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Paste or type snippet to stack...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
                onPressed: () {
                  final text = _clipInputController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _clipStack.insert(0, text);
                      _clipInputController.clear();
                    });
                  }
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Clip Stack List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipStack.length,
            itemBuilder: (context, index) {
              final clip = _clipStack[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.content_copy,
                        color: Colors.indigo, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        clip,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        softWrap: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.grey, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied snippet: "$clip"'),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                      onPressed: () {
                        setState(() {
                          _clipStack.removeAt(index);
                        });
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

  Widget _buildTextRephraserTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contextual Rephrase Helper',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Quickly change tone for WhatsApp messages, emails, or replies.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Input Box
          TextField(
            controller: _rephraseInputController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter quick draft message...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Tone Selector
          const Text(
            'Select Target Tone:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Professional',
              'Friendly',
              'Sinhala-English Casual',
              'Bullet Points',
              'Shortened'
            ].map((tone) {
              final isSelected = _selectedTone == tone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSelected,
                selectedColor: Colors.indigo,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTone = tone;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Rephrase Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: _rephraseText,
            icon: const Icon(Icons.bolt),
            label: const Text('Rephrase Now'),
          ),

          if (_rephrasedOutput.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Rephrased Output:',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _rephrasedOutput,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                      ),
                      onPressed: () {
                        setState(() {
                          _clipStack.insert(0, _rephrasedOutput);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saved to ClipVault stack!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_to_photos, size: 16),
                      label: const Text('Send to ClipVault'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDealCalcTab() {
    final finalDiscountedPrice =
        _originalPrice * (1.0 - (_discountPercent / 100.0));
    final finalPriceWithTax =
        finalDiscountedPrice * (1.0 + (_taxPercent / 100.0));
    final totalSaved = _originalPrice - finalDiscountedPrice;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Deal & Discount HUD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate real dynamic deals and taxes while shopping online.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Price Controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Original Price: LKR ${_originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _originalPrice,
                  min: 100,
                  max: 100000,
                  divisions: 1000,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _originalPrice = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Discount Off: ${_discountPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _discountPercent,
                  min: 0,
                  max: 90,
                  divisions: 90,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _discountPercent = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Tax / Service Charge: ${_taxPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _taxPercent,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _taxPercent = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Calculated Results HUD Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'You Pay Total:',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      'LKR ${finalPriceWithTax.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Saved:',
                      style: TextStyle(color: Colors.amber, fontSize: 13),
                    ),
                    Text(
                      'LKR ${totalSaved.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleQuickTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}