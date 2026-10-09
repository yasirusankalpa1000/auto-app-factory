import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const OmniBubbleApp());
}

class OmniBubbleApp extends StatelessWidget {
  const OmniBubbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniBubble Utility Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF12181F),
        cardColor: const Color(0xFF1E2631),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF18202A),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const MainUtilityScreen(),
    );
  }
}

class MainUtilityScreen extends StatefulWidget {
  const MainUtilityScreen({super.key});

  @override
  State<MainUtilityScreen> createState() => _MainUtilityScreenState();
}

class _MainUtilityScreenState extends State<MainUtilityScreen> {
  int _currentIndex = 0;

  // Global persistent states for interaction
  bool _overlayEnabled = true;
  bool _notificationAccess = true;
  bool _autoClipboardListener = true;
  Offset _bubblePosition = const Offset(280, 320);

  // Pocket shelf saved items
  final List<Map<String, String>> _pocketItems = [
    {
      'title': 'Bank Account details for transfer',
      'content': 'Acc: 9876-5432-1098 | Swift: HDFC00012',
      'category': 'Finance',
      'time': '10 mins ago',
    },
    {
      'title': 'Shopping list link',
      'content': 'https://store.example.com/item/884920',
      'category': 'Links',
      'time': '1 hr ago',
    },
    {
      'title': 'Delivery address note',
      'content': 'No 45, Elmwood Street, Suite 3B, Gate Code: #4092',
      'category': 'Notes',
      'time': '3 hrs ago',
    },
  ];

  void _addPocketItem(String title, String content, String category) {
    setState(() {
      _pocketItems.insert(0, {
        'title': title.isEmpty ? 'Quick Note' : title,
        'content': content,
        'category': category,
        'time': 'Just now',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildFloatingHubTab(),
      _buildPrivacyRedactorTab(),
      _buildDealSanityTab(),
      _buildPocketShelfTab(),
      _buildDecisionEngineTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.widgets, color: Colors.tealAccent, size: 24),
            const SizedBox(width: 8),
            const Text(
              'OmniBubble Hub',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _overlayEnabled ? Icons.flash_on : Icons.flash_off,
              color: _overlayEnabled ? Colors.amber : Colors.grey,
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
                        ? 'Floating Assistant Activated!'
                        : 'Floating Assistant Paused',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF18202A),
        indicatorColor: Colors.teal.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets, color: Colors.white70),
            selectedIcon: Icon(Icons.widgets, color: Colors.tealAccent),
            label: 'Floating Assistant',
          ),
          NavigationDestination(
            icon: Icon(Icons.security, color: Colors.white70),
            selectedIcon: Icon(Icons.security, color: Colors.tealAccent),
            label: 'Privacy Redactor',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on, color: Colors.white70),
            selectedIcon: Icon(Icons.monetization_on, color: Colors.tealAccent),
            label: 'Deal Sanity',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste, color: Colors.white70),
            selectedIcon: Icon(Icons.content_paste, color: Colors.tealAccent),
            label: 'Pocket Shelf',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome, color: Colors.white70),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.tealAccent),
            label: 'Decide Engine',
          ),
        ],
      ),
    );
  }

  // ================= TAB 1: FLOATING ASSISTANT HUB =================
  Widget _buildFloatingHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D5C5B), Color(0xFF1E3A4C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flash_on, color: Colors.tealAccent, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating Assistant Active',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your dynamic overlay helper is ready. Drag bubble on live simulator below!',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Live Screen Floating Bubble Simulator',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),

          // Simulated Mobile Phone Container
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0B0E14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3), width: 2),
            ),
            child: Stack(
              children: [
                // Simulated Background Apps content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '10:42 AM',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Icon(Icons.wifi, color: Colors.white70, size: 14),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF18222D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.shopping_bag, color: Colors.amberAccent),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Browsing Online Shopping Store...\nUnit Price check needed?',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF18222D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.chat_bubble, color: Colors.blueAccent),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'WhatsApp Chat: "Send bank receipt details please!"',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Interactive Draggable Floating Bubble
                if (_overlayEnabled)
                  Positioned(
                    left: _bubblePosition.dx.clamp(10, 260),
                    top: _bubblePosition.dy.clamp(10, 220),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _bubblePosition += details.delta;
                        });
                      },
                      onTap: () {
                        _showFloatingQuickMenu(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.tealAccent, Colors.teal],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.tealAccent.withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.widgets, color: Colors.black, size: 28),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // System Permissions & Toggles
          const Text(
            'System Floating Controls',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Card(
            color: const Color(0xFF18202A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text('Display Above Other Apps', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Enable floating bubble helper over any app', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  value: _overlayEnabled,
                  onChanged: (val) => setState(() => _overlayEnabled = val),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text('Sticky Floating Notification', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Instant quick access toolbar from notification shade', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  value: _notificationAccess,
                  onChanged: (val) => setState(() => _notificationAccess = val),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text('Auto Clipboard Pocket Listener', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Automatically offer privacy blur when copying account numbers', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  value: _autoClipboardListener,
                  onChanged: (val) => setState(() => _autoClipboardListener = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Simulated Notification Access Bar Preview
          if (_notificationAccess) ...[
            const Text(
              'Active Notification Quick Toolbar',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF232E3C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Row(
                children: [
                  const Icon(Icons.widgets, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'OmniBubble Quick Assistant Active',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          setState(() => _currentIndex = 1);
                        },
                        child: const Text('Blur Text', style: TextStyle(fontSize: 11, color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade800,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          setState(() => _currentIndex = 2);
                        },
                        child: const Text('Deal Calc', style: TextStyle(fontSize: 11, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFloatingQuickMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18202A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Floating Quick Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildQuickActionButton(
                      icon: Icons.security,
                      label: 'Mask Screenshot',
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 1);
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.monetization_on,
                      label: 'Deal Sanity',
                      color: Colors.amber.shade800,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 2);
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.content_paste,
                      label: 'Pocket Shelf',
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 3);
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.auto_awesome,
                      label: 'Decide Now',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _currentIndex = 4);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 2: PRIVACY REDACTOR TOOL =================
  final TextEditingController _rawTextController = TextEditingController(
    text: 'Send payment to John Doe. Account: 4092-8819-2201. Bank: National Apex. Tel: +1-555-0192.',
  );

  bool _maskPhone = true;
  bool _maskAccount = true;
  bool _maskNames = false;
  List<Rect> _maskBoxes = [
    const Rect.fromLTWH(20, 40, 180, 24),
    const Rect.fromLTWH(20, 80, 220, 24),
  ];

  Widget _buildPrivacyRedactorTab() {
    String processedText = _rawTextController.text;
    if (_maskAccount) {
      processedText = processedText.replaceAll(RegExp(r'\d{4}-\d{4}-\d{4}'), '[REDACTED ACCOUNT]');
    }
    if (_maskPhone) {
      processedText = processedText.replaceAll(RegExp(r'\+\d{1,3}-\d{3}-\d{4}'), '[REDACTED PHONE]');
    }
    if (_maskNames) {
      processedText = processedText.replaceAll('John Doe', '[REDACTED NAME]');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2D3D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.security, color: Colors.tealAccent, size: 26),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Screenshot & Text Privacy Masker\nBlackout bank numbers, chats & private details before sharing!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Mode 1: Text Masker & Redactor',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _rawTextController,
            maxLines: 3,
            style: const TextStyle(fontSize: 13, color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Paste private chat message or bank receipt text here...',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 10),

          // Toggles for text redaction
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                selected: _maskAccount,
                label: const Text('Mask Account Nos', style: TextStyle(fontSize: 11)),
                selectedColor: Colors.teal,
                onSelected: (val) => setState(() => _maskAccount = val),
              ),
              FilterChip(
                selected: _maskPhone,
                label: const Text('Mask Phone Nos', style: TextStyle(fontSize: 11)),
                selectedColor: Colors.teal,
                onSelected: (val) => setState(() => _maskPhone = val),
              ),
              FilterChip(
                selected: _maskNames,
                label: const Text('Mask Names', style: TextStyle(fontSize: 11)),
                selectedColor: Colors.teal,
                onSelected: (val) => setState(() => _maskNames = val),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Processed Output Card
          Container(
            padding: const EdgeInsets.all(14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F151C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Redacted Clean Output:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Redacted text copied to clipboard!')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  processedText,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Mode 2: Visual Screenshot Overlay Redactor Canvas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mode 2: Visual Screenshot Masker',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add_box, size: 16, color: Colors.tealAccent),
                label: const Text('Add Box', style: TextStyle(fontSize: 12, color: Colors.tealAccent)),
                onPressed: () {
                  setState(() {
                    _maskBoxes.add(Rect.fromLTWH(30, 30 + (_maskBoxes.length * 25.0), 160, 24));
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Visual interactive canvas simulation
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2834),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Stack(
              children: [
                // Mock Image / Document Content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TRANSACTION RECEIPT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 14)),
                        SizedBox(height: 10),
                        Text('Transfer Amount: \$2,450.00', style: TextStyle(color: Colors.white, fontSize: 13)),
                        SizedBox(height: 8),
                        Text('Sender: Alex Mercer (9928-1102-44)', style: TextStyle(color: Colors.white, fontSize: 13)),
                        SizedBox(height: 8),
                        Text('Receiver: City Water Corp (#882109)', style: TextStyle(color: Colors.white, fontSize: 13)),
                        SizedBox(height: 8),
                        Text('Reference Note: Invoice settlement #4920', style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                ),

                // Render Masking Blackout Boxes
                for (int i = 0; i < _maskBoxes.length; i++)
                  Positioned(
                    left: _maskBoxes[i].left,
                    top: _maskBoxes[i].top,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _maskBoxes[i] = Rect.fromLTWH(
                            _maskBoxes[i].left + details.delta.dx,
                            _maskBoxes[i].top + details.delta.dy,
                            _maskBoxes[i].width,
                            _maskBoxes[i].height,
                          );
                        });
                      },
                      child: Container(
                        width: _maskBoxes[i].width,
                        height: _maskBoxes[i].height,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.redAccent, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text('[REDACTED]', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _maskBoxes.removeAt(i);
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.redAccent, size: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Stamp badge watermark preview
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'CONFIDENTIAL',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text('Export Masked Visual Image', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Masked receipt image ready to share safely!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 3: DEAL SANITY & IMPULSE CALC =================
  final TextEditingController _itemAPriceController = TextEditingController(text: '12.99');
  final TextEditingController _itemAQtyController = TextEditingController(text: '300'); // e.g. grams
  final TextEditingController _itemBPriceController = TextEditingController(text: '18.49');
  final TextEditingController _itemBQtyController = TextEditingController(text: '500'); // e.g. grams

  final TextEditingController _impulsePriceController = TextEditingController(text: '89.00');
  int _needScore = 3; // 1 to 5 scale

  Widget _buildDealSanityTab() {
    double priceA = double.tryParse(_itemAPriceController.text) ?? 0.0;
    double qtyA = double.tryParse(_itemAQtyController.text) ?? 1.0;
    double priceB = double.tryParse(_itemBPriceController.text) ?? 0.0;
    double qtyB = double.tryParse(_itemBQtyController.text) ?? 1.0;

    double unitCostA = qtyA > 0 ? (priceA / qtyA) * 100 : 0.0; // cost per 100 units
    double unitCostB = qtyB > 0 ? (priceB / qtyB) * 100 : 0.0;

    String dealWinner = 'Equal value';
    if (unitCostA < unitCostB && unitCostA > 0) {
      dealWinner = 'Option A is ${(100 - (unitCostA / unitCostB * 100)).toStringAsFixed(1)}% CHEAPER per unit!';
    } else if (unitCostB < unitCostA && unitCostB > 0) {
      dealWinner = 'Option B is ${(100 - (unitCostB / unitCostA * 100)).toStringAsFixed(1)}% CHEAPER per unit!';
    }

    double impulsePrice = double.tryParse(_impulsePriceController.text) ?? 0.0;
    String impulseAdvice = 'Balanced Purchase';
    Color impulseColor = Colors.amber;

    if (_needScore <= 2 && impulsePrice > 50) {
      impulseAdvice = 'Impulse Trap! Wait 24 Hours before buying!';
      impulseColor = Colors.redAccent;
    } else if (_needScore >= 4) {
      impulseAdvice = 'High Necessity: Reasonable Buy Decision';
      impulseColor = Colors.greenAccent;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2E2413),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.4)),
            ),
            child: Row(
              children: const [
                Icon(Icons.monetization_on, color: Colors.amberAccent, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Deal Sanity & Unit Price Comparison\nDon\'t get fooled by marketing discounts or package tricks!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Unit Price Comparison (Option A vs B)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              // Option A
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18222D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Option A', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent, fontSize: 13)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _itemAPriceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _itemAQtyController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Qty (g/ml/pcs)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cost/100: \$${unitCostA.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Option B
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18222D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Option B', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent, fontSize: 13)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _itemBPriceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _itemBQtyController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Qty (g/ml/pcs)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cost/100: \$${unitCostB.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Winner badge
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
            ),
            child: Text(
              'Verdict: $dealWinner',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.tealAccent),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Impulse Buy Sanity Checker
          const Text(
            'Impulse Buying Sanity Test',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Card(
            color: const Color(0xFF18202A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _impulsePriceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Item Price (\$) you want to buy right now',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'How urgently do you need this? (Need Score: $_needScore/5)',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Slider(
                    value: _needScore.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: Colors.amberAccent,
                    label: 'Score: $_needScore',
                    onChanged: (val) {
                      setState(() {
                        _needScore = val.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: impulseColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: impulseColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: impulseColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            impulseAdvice,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: impulseColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 4: POCKET SHELF (CLIPBOARD & LINKS) =================
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newContentController = TextEditingController();
  String _selectedCategory = 'Finance';

  Widget _buildPocketShelfTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2838),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
            ),
            child: Row(
              children: const [
                Icon(Icons.content_paste, color: Colors.blueAccent, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Smart Pocket Shelf & Clipboard\nQuickly store copied account details, tracking links, and snippets!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Add New Snippet Box
          Card(
            color: const Color(0xFF18202A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Save Quick Snippet or Link', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _newTitleController,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Title / Label',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newContentController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Content / Link / Account Info',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      DropdownButton<String>(
                        value: _selectedCategory,
                        dropdownColor: const Color(0xFF18202A),
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                        items: ['Finance', 'Links', 'Notes', 'Shopping'].map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: const Text('Save to Pocket', style: TextStyle(fontSize: 12, color: Colors.white)),
                        onPressed: () {
                          if (_newContentController.text.isNotEmpty) {
                            _addPocketItem(_newTitleController.text, _newContentController.text, _selectedCategory);
                            _newTitleController.clear();
                            _newContentController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved to Pocket Shelf!')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Saved Pocket Clips',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pocketItems.length,
            itemBuilder: (ctx, index) {
              final item = _pocketItems[index];
              return Card(
                color: const Color(0xFF18202A),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    child: Icon(
                      item['category'] == 'Finance'
                          ? Icons.account_balance
                          : item['category'] == 'Links'
                              ? Icons.link
                              : Icons.note_alt,
                      color: Colors.tealAccent,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item['content']!,
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied "${item['title']}" to clipboard!')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _pocketItems.removeAt(index);
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

  // ================= TAB 5: MICRO-DECISION MATRIX ENGINE =================
  final List<String> _decisionChoices = ['Option A: Buy online now', 'Option B: Wait for weekend sale', 'Option C: Skip purchase'];
  String _decisionResult = 'Tap "Spin Decision Engine" to pick!';
  bool _isSpinning = false;

  Widget _buildDecisionEngineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2C1E38),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.4)),
            ),
            child: Row(
              children: const [
                Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Micro-Decision Matrix Engine\nStop wasting energy on micro-dilemmas. Let smart logic solve decision fatigue!',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Your Options Dilemma List',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Card(
            color: const Color(0xFF18202A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  for (int i = 0; i < _decisionChoices.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _decisionChoices[i],
                              style: const TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                          if (_decisionChoices.length > 2)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white70, size: 16),
                              onPressed: () {
                                setState(() {
                                  _decisionChoices.removeAt(i);
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF283444)),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text('Add Dilemma Option', style: TextStyle(fontSize: 12, color: Colors.white)),
                    onPressed: () {
                      _showAddChoiceDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Decision Result Box
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF221834), Color(0xFF142434)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 36),
                const SizedBox(height: 10),
                Text(
                  _decisionResult,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _isSpinning ? Colors.amberAccent : Colors.tealAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Spin Decision Engine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: _isSpinning
                        ? null
                        : () {
                            setState(() {
                              _isSpinning = true;
                              _decisionResult = 'Analyzing weights & micro-factors...';
                            });
                            Timer(const Duration(seconds: 1), () {
                              setState(() {
                                _isSpinning = false;
                                final picked = (_decisionChoices..shuffle()).first;
                                _decisionResult = 'Smart Recommendation:\n"$picked"';
                              });
                            });
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddChoiceDialog(BuildContext context) {
    final TextEditingController optionController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF18202A),
          title: const Text('Add New Option', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: TextField(
            controller: optionController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'e.g. Order pizza / Cook pasta',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (optionController.text.isNotEmpty) {
                  setState(() {
                    _decisionChoices.add(optionController.text);
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}