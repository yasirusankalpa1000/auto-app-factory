import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDeckApp());
}

class BubbleDeckApp extends StatelessWidget {
  const BubbleDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentIndex = 0;

  // Global State for Multi-Clip Stash
  final List<Map<String, String>> _clipStash = [
    {
      'id': '1',
      'title': 'Bank Details (Personal)',
      'content': 'Commercial Bank - Acc: 8001239941 - Name: A.D. Silva - Branch: Colombo Main',
      'category': 'Banking',
    },
    {
      'id': '2',
      'title': 'Delivery Address',
      'content': 'No. 42/B, Flower Road, Colombo 07, Near Liberty Plaza Roundabout',
      'category': 'Address',
    },
    {
      'id': '3',
      'title': 'E-Commerce Clean Link',
      'content': 'https://store.example.com/item/1092',
      'category': 'Links',
    },
    {
      'id': '4',
      'title': 'Standard Support Reply',
      'content': 'Hi there! Thank you for reaching out. Your order is currently being packed and will ship within 24 hours.',
      'category': 'Work',
    },
  ];

  // Global Metrics
  int _linksCleanedCount = 14;
  int _clipsSavedCount = 28;
  int _timeSavedMinutes = 45;

  void _addStashItem(String title, String content, String category) {
    setState(() {
      _clipStash.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'content': content,
        'category': category,
      });
      _clipsSavedCount++;
    });
  }

  void _removeStashItem(String id) {
    setState(() {
      _clipStash.removeWhere((item) => item['id'] == id);
    });
  }

  void _incrementCleanedCount() {
    setState(() {
      _linksCleanedCount++;
      _timeSavedMinutes += 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CopilotTransformerPage(
        onSaveToStash: _addStashItem,
        onLinkCleaned: _incrementCleanedCount,
      ),
      const OverlayControlPage(),
      ClipStashPage(
        stashList: _clipStash,
        onDeleteItem: _removeStashItem,
        onAddItem: _addStashItem,
      ),
      AnalyticsHubPage(
        linksCleaned: _linksCleanedCount,
        clipsSaved: _clipsSavedCount,
        timeSavedMin: _timeSavedMinutes,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.indigo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.flash_on, color: Colors.white70),
            selectedIcon: Icon(Icons.flash_on, color: Colors.white),
            label: 'Copilot',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers, color: Colors.white70),
            selectedIcon: Icon(Icons.layers, color: Colors.white),
            label: 'Overlay',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste, color: Colors.white70),
            selectedIcon: Icon(Icons.content_paste, color: Colors.white),
            label: 'Stash & Drafts',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics, color: Colors.white70),
            selectedIcon: Icon(Icons.analytics, color: Colors.white),
            label: 'Deck Hub',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PAGE 1: SMART COPILOT & REAL-TIME TRANSFORMER
// ==========================================
class CopilotTransformerPage extends StatefulWidget {
  final Function(String title, String content, String category) onSaveToStash;
  final VoidCallback onLinkCleaned;

  const CopilotTransformerPage({
    super.key,
    required onSaveToStash,
    required onLinkCleaned,
  })  : onSaveToStash = onSaveToStash,
        onLinkCleaned = onLinkCleaned;

  @override
  State<CopilotTransformerPage> createState() => _CopilotTransformerPageState();
}

class _CopilotTransformerPageState extends State<CopilotTransformerPage> {
  final TextEditingController _inputController = TextEditingController(
    text: 'Check this deal https://shop.com/item?id=8831&utm_source=facebook&utm_medium=ad&ref=affiliate123. Price is \$149.99! Call +1-555-0192 for info.',
  );

  String _transformedOutput = '';
  List<String> _extractedPhones = [];
  List<String> _extractedUrls = [];
  List<String> _extractedPrices = [];
  double _convertedLKR = 0.0;
  double _convertedEUR = 0.0;

  @override
  void initState() {
    super.initState();
    _processText(_inputController.text);
  }

  void _processText(String text) {
    setState(() {
      _transformedOutput = text;

      // Extract Phone Numbers (basic regex pattern)
      final phoneRegex = RegExp(r'\+?\d[\d\s\-]{8,}\d');
      _extractedPhones = phoneRegex.allMatches(text).map((m) => m.group(0)!).toList();

      // Extract URLs
      final urlRegex = RegExp(r'https?://[^\s]+');
      _extractedUrls = urlRegex.allMatches(text).map((m) => m.group(0)!).toList();

      // Extract Prices
      final priceRegex = RegExp(r'\$\d+(\.\d{1,2})?');
      final prices = priceRegex.allMatches(text).map((m) => m.group(0)!).toList();
      _extractedPrices = prices;

      if (prices.isNotEmpty) {
        final rawVal = double.tryParse(prices.first.replaceAll('\$', '')) ?? 0.0;
        _convertedLKR = rawVal * 305.50;
        _convertedEUR = rawVal * 0.92;
      } else {
        _convertedLKR = 0.0;
        _convertedEUR = 0.0;
      }
    });
  }

  void _cleanTrackingUrls() {
    String current = _inputController.text;
    final cleaned = current.replaceAll(RegExp(r'(\?|&)(utm_[^&=]+|ref|affiliate|tracking)[^&\s]*'), '');
    _inputController.text = cleaned;
    _processText(cleaned);
    widget.onLinkCleaned();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stripped tracking parameters & affiliate tags!'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _formatAsBullets() {
    final lines = _inputController.text.split(RegExp(r'[\n\.,]')).where((s) => s.trim().isNotEmpty).toList();
    final bulleted = lines.map((l) => '• ${l.trim()}').join('\n');
    _inputController.text = bulleted;
    _processText(bulleted);
  }

  void _uppercaseText() {
    final upper = _inputController.text.toUpperCase();
    _inputController.text = upper;
    _processText(upper);
  }

  void _lowercaseText() {
    final lower = _inputController.text.toLowerCase();
    _inputController.text = lower;
    _processText(lower);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BubbleDeck Copilot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services, color: Colors.amber),
            tooltip: 'Clean URL Junk',
            onPressed: _cleanTrackingUrls,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Floating Status Banner
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Active Floating Clipboard Copilot running in background',
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Active Clipboard Field
              const Text(
                'ACTIVE CLIPBOARD / INPUT BUFFER',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _inputController,
                maxLines: 4,
                onChanged: _processText,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Paste any copied message, tracking link, or bill details...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),

              // Quick Action Transformers
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _cleanTrackingUrls,
                    icon: const Icon(Icons.cleaning_services, size: 16, color: Colors.amber),
                    label: const Text('Strip Tracking Links', style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334155),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _formatAsBullets,
                    icon: const Icon(Icons.format_list_bulleted, size: 16, color: Colors.cyan),
                    label: const Text('Format Bullets', style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334155),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _uppercaseText,
                    icon: const Icon(Icons.text_fields, size: 16, color: Colors.green),
                    label: const Text('UPPERCASE', style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334155),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _lowercaseText,
                    icon: const Icon(Icons.text_fields, size: 16, color: Colors.purple),
                    label: const Text('lowercase', style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF334155),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Instant Smart Data Extractors
              const Text(
                'AUTO-DETECTED SMART HUD',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
              ),
              const SizedBox(height: 10),

              // Currency Conversion HUD Card
              if (_extractedPrices.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.monetization_on, color: Colors.teal, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Live Currency Preview HUD',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Original Detected Price: ${_extractedPrices.join(", ")}',
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          Chip(
                            avatar: const Icon(Icons.currency_exchange, size: 14, color: Colors.white),
                            label: Text('LKR ${_convertedLKR.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: Colors.teal.shade800,
                          ),
                          Chip(
                            avatar: const Icon(Icons.euro, size: 14, color: Colors.white),
                            label: Text('EUR ${_convertedEUR.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: Colors.indigo.shade800,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Detected Phone Numbers Card
              if (_extractedPhones.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.blue, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phone Number Detected', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(_extractedPhones.join(', '), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied: ${_extractedPhones.first}')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Detected URLs Card
              if (_extractedUrls.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.link, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text('Sanitized URL Ready', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _extractedUrls.first,
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Quick Save to Multi-Stash Deck Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_inputController.text.trim().isNotEmpty) {
                      widget.onSaveToStash(
                        'Saved Clip #${DateTime.now().second}',
                        _inputController.text,
                        'General',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saved to Multi-Clip Stash Deck!'),
                          backgroundColor: Colors.indigo,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_to_photos, color: Colors.white),
                  label: const Text('Save Active Buffer to Stash Deck', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PAGE 2: OVERLAY CONTROL & FLOATING PREVIEW
// ==========================================
class OverlayControlPage extends StatefulWidget {
  const OverlayControlPage({super.key});

  @override
  State<OverlayControlPage> createState() => _OverlayControlPageState();
}

class _OverlayControlPageState extends State<OverlayControlPage> {
  bool _overlayPermissionGranted = true;
  bool _notificationBarEnabled = true;
  bool _autoCleanUrlEnabled = true;
  bool _bubbleDockLeft = false;

  double _bubbleOpacity = 0.85;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Overlay Engine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Permissions Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.indigo.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.security, color: Colors.indigoAccent, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'System Overlay Permissions',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      value: _overlayPermissionGranted,
                      activeColor: Colors.teal,
                      title: const Text('Display Above Other Apps', style: TextStyle(fontSize: 13, color: Colors.white)),
                      subtitle: const Text('Allows floating copilot bubble on screen', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      onChanged: (val) {
                        setState(() {
                          _overlayPermissionGranted = val;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(color: Colors.white70),
                    SwitchListTile(
                      value: _notificationBarEnabled,
                      activeColor: Colors.teal,
                      title: const Text('Smart Persistent Notification HUD', style: TextStyle(fontSize: 13, color: Colors.white)),
                      subtitle: const Text('Instant 1-tap clipboard access from notification shade', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      onChanged: (val) {
                        setState(() {
                          _notificationBarEnabled = val;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(color: Colors.white70),
                    SwitchListTile(
                      value: _autoCleanUrlEnabled,
                      activeColor: Colors.teal,
                      title: const Text('Auto-Strip Affiliate Tracking on Copy', style: TextStyle(fontSize: 13, color: Colors.white)),
                      subtitle: const Text('Automatically cleans copied URLs in background', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      onChanged: (val) {
                        setState(() {
                          _autoCleanUrlEnabled = val;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive Floating Preview Box
              const Text(
                'LIVE SCREEN SIMULATOR PREVIEW',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
              ),
              const SizedBox(height: 10),

              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Stack(
                  children: [
                    // Simulated Background Smartphone Screen
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone_android, size: 40, color: Colors.white70),
                          SizedBox(height: 8),
                          Text(
                            'Simulated Screen Environment\n(WhatsApp, Browser, Instagram Active)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Floating Bubble Badge Mockup
                    Positioned(
                      top: 40,
                      left: _bubbleDockLeft ? 16 : null,
                      right: _bubbleDockLeft ? null : 16,
                      child: Opacity(
                        opacity: _bubbleOpacity,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Bubble Deck Tapped! Floating Quick Dock Active.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.6),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.flash_on, color: Colors.amber, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bubble Dock Customizer Controls
              const Text(
                'BUBBLE CUSTOMIZATION',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Dock Side:', style: TextStyle(color: Colors.white, fontSize: 13)),
                  const Spacer(),
                  ChoiceChip(
                    label: const Text('Right Edge', style: TextStyle(fontSize: 11, color: Colors.white)),
                    selected: !_bubbleDockLeft,
                    selectedColor: Colors.indigo,
                    onSelected: (selected) {
                      setState(() {
                        _bubbleDockLeft = !selected;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Left Edge', style: TextStyle(fontSize: 11, color: Colors.white)),
                    selected: _bubbleDockLeft,
                    selectedColor: Colors.indigo,
                    onSelected: (selected) {
                      setState(() {
                        _bubbleDockLeft = selected;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Opacity:', style: TextStyle(color: Colors.white, fontSize: 13)),
                  Expanded(
                    child: Slider(
                      value: _bubbleOpacity,
                      min: 0.3,
                      max: 1.0,
                      activeColor: Colors.indigoAccent,
                      onChanged: (val) {
                        setState(() {
                          _bubbleOpacity = val;
                        });
                      },
                    ),
                  ),
                  Text('${(_bubbleOpacity * 100).toInt()}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// PAGE 3: MULTI-CLIP STASH & DRAFT STUDIO
// ==========================================
class ClipStashPage extends StatefulWidget {
  final List<Map<String, String>> stashList;
  final Function(String id) onDeleteItem;
  final Function(String title, String content, String category) onAddItem;

  const ClipStashPage({
    super.key,
    required this.stashList,
    required this.onDeleteItem,
    required this.onAddItem,
  });

  @override
  State<ClipStashPage> createState() => _ClipStashPageState();
}

class _ClipStashPageState extends State<ClipStashPage> {
  String _selectedCategory = 'All';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Clip to Stash', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Title / Label',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Content / Text Snippet',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
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
              if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                widget.onAddItem(
                  _titleController.text,
                  _contentController.text,
                  'Custom',
                );
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedCategory == 'All'
        ? widget.stashList
        : widget.stashList.where((item) => item['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Clip Stash & Drafts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: const Color(0xFF0F172A),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Banking', 'Address', 'Links', 'Work', 'Custom'].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: FilterChip(
                        label: Text(cat, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey)),
                        selected: isSelected,
                        selectedColor: Colors.indigo,
                        backgroundColor: const Color(0xFF1E293B),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Stash Deck List
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        'No saved clips in "$_selectedCategory"',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Card(
                          color: const Color(0xFF1E293B),
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item['category'] ?? 'General',
                                        style: const TextStyle(fontSize: 10, color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.copy, size: 18, color: Colors.teal),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Copied "${item['title']}" to active clipboard!'),
                                            backgroundColor: Colors.teal,
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                                      onPressed: () => widget.onDeleteItem(item['id']!),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['content'] ?? '',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Snippet', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }
}

// ==========================================
// PAGE 4: ANALYTICS & AD-MOB READY HUB
// ==========================================
class AnalyticsHubPage extends StatelessWidget {
  final int linksCleaned;
  final int clipsSaved;
  final int timeSavedMin;

  const AnalyticsHubPage({
    super.key,
    required this.linksCleaned,
    required this.clipsSaved,
    required this.timeSavedMin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Analytics & Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Productivity Hero Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.stars, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Daily Copilot Streak: Active',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'BubbleDeck has saved you approximately $timeSavedMin minutes of tedious app-switching today.',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Counter Grid Badges
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      'Links Sanitized',
                      '$linksCleaned',
                      Icons.cleaning_services,
                      Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      'Clips Stashed',
                      '$clipsSaved',
                      Icons.layers,
                      Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Native Ad Integration Placeholder Container
              const Text(
                'COMMUNITY & SPONSORED COPILOT DECK',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('AD', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Sponsored Utility Tool: Ultra Express VPN',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Protect your copied passwords and private data over public Wi-Fi networks in 1-tap.',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.indigoAccent),
                        ),
                        child: const Text('Learn More', style: TextStyle(color: Colors.indigoAccent, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}