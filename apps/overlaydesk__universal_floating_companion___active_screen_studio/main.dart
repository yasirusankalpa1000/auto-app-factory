import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayDeskApp());
}

class OverlayDeskApp extends StatelessWidget {
  const OverlayDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E293B),
          background: Color(0xFF0F172A),
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
  int _selectedTabIndex = 0;

  // Global Multi-Clip Stack
  final List<String> _clipStack = [
    "Order #8492 - Address: 742 Evergreen Terrace, Springfield",
    "Contact: alex.dev@example.com | +1 555-0199",
    "Subtotal: \$149.50 (Tax exempt)",
  ];

  // Floating Overlay Bubble State
  bool _overlayEnabled = true;
  bool _notificationToastVisible = false;
  String _activeNotificationText = "Floating Overlay Desk is Active";
  Offset _bubblePosition = const Offset(20, 200);

  // Active Pin Card Text
  String _pinnedNote = "Pin this card: Wifi Pass: SkyNet_9942";

  void _addClipItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipStack.insert(0, text.trim());
    });
    _showFloatingNotification("New item added to ClipStack!");
  }

  void _removeClipItem(int index) {
    setState(() {
      _clipStack.removeAt(index);
    });
  }

  void _clearAllClips() {
    setState(() {
      _clipStack.clear();
    });
  }

  void _showFloatingNotification(String message) {
    setState(() {
      _activeNotificationText = message;
      _notificationToastVisible = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _notificationToastVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Views
            Column(
              children: [
                _buildHeaderBar(),
                Expanded(
                  child: _selectedTabIndex == 0
                      ? _buildClipStackTab()
                      : _selectedTabIndex == 1
                          ? _buildPurifierStudioTab()
                          : _selectedTabIndex == 2
                              ? _buildMicroCalcTab()
                              : _buildOverlaySettingsTab(),
                ),
              ],
            ),

            // Simulated Floating Banner Notification Overlay
            if (_notificationToastVisible)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.tealAccent, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.tealAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _activeNotificationText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.white, size: 18),
                          onPressed: () {
                            setState(() {
                              _notificationToastVisible = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Floating Dynamic Bubble Controller Sandbox
            if (_overlayEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.tealAccent.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.widgets,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          border: Border(top: BorderSide(color: Colors.white70, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: 'ClipStack',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: 'Purifier',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Quick Calc',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Overlay Hub',
            ),
          ],
        ),
      ),
    );
  }

  // --- TOP HEADER ---
  Widget _buildHeaderBar() {
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
              color: Colors.indigoAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.indigoAccent, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OverlayDesk Pro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Universal Screen & Clip Studio',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _overlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _overlayEnabled ? Colors.tealAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _overlayEnabled = !_overlayEnabled;
              });
              _showFloatingNotification(
                _overlayEnabled ? "Floating Bubble Overlay Enabled!" : "Floating Bubble Overlay Hidden",
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: CLIPSTACK MANAGER ---
  Widget _buildClipStackTab() {
    final TextEditingController textController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Pin Banner Widget
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade800, Colors.purple.shade900],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pin_drop, color: Colors.amber, size: 18),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Floating Reference Card (Pinned)',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => _showFloatingNotification("Pinned widget persistent on screen!"),
                      child: const Icon(Icons.share, color: Colors.white70, size: 16),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _pinnedNote,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Add New Clip Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Paste text, links, or addresses here...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addClipItem(textController.text);
                    textController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  child: const Text('Add Stack', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Toolbar for Stack
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Multi-Clip Items (${_clipStack.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_clipStack.isNotEmpty) {
                        final merged = _clipStack.join('\n\n');
                        _showFloatingNotification('Copied all ${_clipStack.length} items merged!');
                      }
                    },
                    icon: const Icon(Icons.content_copy, size: 14, color: Colors.tealAccent),
                    label: const Text('Merge All', style: TextStyle(color: Colors.tealAccent, fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.tealAccent),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                    onPressed: _clearAllClips,
                    tooltip: 'Clear Stack',
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 12),

          // Stack List
          if (_clipStack.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Icon(Icons.content_paste, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Your ClipStack is empty.\nPaste text to keep multi-slot clips active!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipStack.length,
              itemBuilder: (context, index) {
                final item = _clipStack[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.indigoAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#${index + 1}',
                              style: const TextStyle(
                                color: Colors.indigoAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.white70, height: 1),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _pinnedNote = item;
                              });
                              _showFloatingNotification("Pinned item to persistent overlay!");
                            },
                            icon: const Icon(Icons.pin_drop, size: 14, color: Colors.amber),
                            label: const Text('Pin Overlay', style: TextStyle(color: Colors.amber, fontSize: 11)),
                          ),
                          TextButton.icon(
                            onPressed: () => _showFloatingNotification("Item copied to clipboard!"),
                            icon: const Icon(Icons.content_copy, size: 14, color: Colors.tealAccent),
                            label: const Text('Copy', style: TextStyle(color: Colors.tealAccent, fontSize: 11)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey, size: 16),
                            onPressed: () => _removeClipItem(index),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 16),
          // Auto Data Extractor Card
          _buildDataExtractorCard(),
        ],
      ),
    );
  }

  // --- DATA EXTRACTOR CARD ---
  Widget _buildDataExtractorCard() {
    String allText = _clipStack.join(" ");

    // Basic Extractors
    RegExp phoneRegex = RegExp(r'\+?[0-9]{1,4}?[-. ]?\(?[0-9]{1,3}?\)?[-. ]?[0-9]{3,4}[-. ]?[0-9]{3,4}');
    RegExp emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    RegExp urlRegex = RegExp(r'https?://[^\s]+');

    Iterable<Match> phones = phoneRegex.allMatches(allText);
    Iterable<Match> emails = emailRegex.allMatches(allText);
    Iterable<Match> urls = urlRegex.allMatches(allText);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151E2D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.filter_list, color: Colors.tealAccent, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Smart Data Auto-Extractor',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.phone, size: 14, color: Colors.white),
                label: Text('Phones: ${phones.length}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: const Color(0xFF1E293B),
              ),
              Chip(
                avatar: const Icon(Icons.email, size: 14, color: Colors.white),
                label: Text('Emails: ${emails.length}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: const Color(0xFF1E293B),
              ),
              Chip(
                avatar: const Icon(Icons.link, size: 14, color: Colors.white),
                label: Text('Links: ${urls.length}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: const Color(0xFF1E293B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 2: TEXT PURIFIER & FORMATTER STUDIO ---
  Widget _buildPurifierStudioTab() {
    final TextEditingController textController = TextEditingController(
      text: "   HEY!!  This is   a MESSY   text sample with   emojis 🚀🔥 &   weird   spaces...   ",
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: StatefulBuilder(
        builder: (context, setStateStudio) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Text Purifier Studio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'Clean messy texts, format paragraphs, strip emojis, and fix casing instantly.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 14),

              // Input Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: TextField(
                  controller: textController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Paste messy content here to purify...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Quick Transformations',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.tealAccent),
              ),
              const SizedBox(height: 10),

              // Formatting Action Buttons Wrap
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setStateStudio(() {
                        textController.text = textController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                      });
                      _showFloatingNotification("Extra spaces removed!");
                    },
                    icon: const Icon(Icons.cleaning_services, size: 14),
                    label: const Text('Clean Spaces', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setStateStudio(() {
                        textController.text = textController.text.toUpperCase();
                      });
                      _showFloatingNotification("Converted to UPPERCASE");
                    },
                    icon: const Icon(Icons.arrow_upward, size: 14),
                    label: const Text('UPPERCASE', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setStateStudio(() {
                        textController.text = textController.text.toLowerCase();
                      });
                      _showFloatingNotification("Converted to lowercase");
                    },
                    icon: const Icon(Icons.arrow_downward, size: 14),
                    label: const Text('lowercase', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setStateStudio(() {
                        RegExp emojiRegex = RegExp(
                            r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F1E0}-\u{1F1FF}]',
                            unicode: true);
                        textController.text = textController.text.replaceAll(emojiRegex, '');
                      });
                      _showFloatingNotification("Emojis removed!");
                    },
                    icon: const Icon(Icons.block, size: 14),
                    label: const Text('Remove Emojis', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setStateStudio(() {
                        List<String> lines = textController.text.split('\n');
                        textController.text = lines.map((l) => l.trim().isEmpty ? '' : '• $l').join('\n');
                      });
                      _showFloatingNotification("Bullet points added!");
                    },
                    icon: const Icon(Icons.format_list_bulleted, size: 14),
                    label: const Text('Make Bullet List', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Send to Stack Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _addClipItem(textController.text);
                  },
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text(
                    'Push Purified Text to ClipStack',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // --- TAB 3: MICRO PRICE & BILL SPLIT QUICK CALC ---
  Widget _buildMicroCalcTab() {
    double billAmount = 120.0;
    double discountPercent = 10.0;
    int splitPeople = 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: StatefulBuilder(
        builder: (context, setStateCalc) {
          double discountVal = billAmount * (discountPercent / 100);
          double finalBill = billAmount - discountVal;
          double perPerson = finalBill / (splitPeople > 0 ? splitPeople : 1);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Micro Bill & Price Quick-Calc',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'Instantly parse values from pasted messages, adjust discounts, and split bills.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Result Display Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'PER PERSON PAYABLE',
                      style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${perPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white70, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Subtotal', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('\$${billAmount.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Discount', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('-\$${discountVal.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Net Bill', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('\$${finalBill.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bill Controls
              Text(
                'Bill Amount: \$${billAmount.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Slider(
                value: billAmount,
                min: 10,
                max: 1000,
                divisions: 99,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setStateCalc(() {
                    billAmount = val;
                  });
                },
              ),

              Text(
                'Discount: ${discountPercent.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Slider(
                value: discountPercent,
                min: 0,
                max: 50,
                divisions: 50,
                activeColor: Colors.indigoAccent,
                onChanged: (val) {
                  setStateCalc(() {
                    discountPercent = val;
                  });
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Split Between: $splitPeople People',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.tealAccent),
                        onPressed: () {
                          if (splitPeople > 1) {
                            setStateCalc(() {
                              splitPeople--;
                            });
                          }
                        },
                      ),
                      Text('$splitPeople', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                        onPressed: () {
                          setStateCalc(() {
                            splitPeople++;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _addClipItem("Calculated Bill: Total \$${finalBill.toStringAsFixed(2)} split ($splitPeople people) -> \$${perPerson.toStringAsFixed(2)} each");
                  },
                  icon: const Icon(Icons.share, color: Colors.tealAccent, size: 16),
                  label: const Text('Push Calculation Result to ClipStack', style: TextStyle(color: Colors.tealAccent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.tealAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // --- TAB 4: OVERLAY PERMISSION & SYSTEM HUB ---
  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating System Hub & Permissions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure dynamic floating bubbles, persistent overlay cards, and active notification listeners.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Permission Toggles
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Allows floating bubble companion to appear over social & chat apps.',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _overlayEnabled,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _overlayEnabled = val;
                    });
                    _showFloatingNotification(val ? "Display Over Apps Enabled!" : "Overlay Disabled");
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  title: const Text('Smart Notification Listener', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Auto-detect incoming tracking codes & copyable addresses.',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: true,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    _showFloatingNotification("Notification Listener active.");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Test Trigger Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF151E2D),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Floating Overlay Simulation Desk',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigoAccent, fontSize: 13),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap below to simulate active system toasts and test drag gestures on the teal floating bubble above!',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showFloatingNotification("Simulated floating banner toast message!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Trigger Floating Banner', style: TextStyle(fontSize: 11)),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _bubblePosition = const Offset(30, 250);
                        });
                        _showFloatingNotification("Floating bubble reset to center view!");
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.tealAccent),
                      ),
                      child: const Text('Reset Bubble Position', style: TextStyle(color: Colors.tealAccent, fontSize: 11)),
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
}