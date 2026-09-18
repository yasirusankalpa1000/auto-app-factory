import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ClipFlyApp());
}

class ClipFlyApp extends StatelessWidget {
  const ClipFlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipFly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          surface: const Color(0xFF12181F),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardTheme: CardTheme(
          color: const Color(0xFF161B22),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF30363D), width: 1),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Floating overlay state (simulated dynamic screen overlay)
  bool _overlayEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoCleanLinks = true;
  
  // Interactive floating bubble coordinates
  double _bubbleX = 20.0;
  double _bubbleY = 150.0;
  bool _isBubbleExpanded = false;

  // Active notification message
  String _floatingNotificationText = "ClipFly Active: Ready for quick action!";

  // Data State
  final TextEditingController _extractorController = TextEditingController();
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedLinks = [];
  String _cleanedTextResult = "";

  // Direct Chat Controller
  final TextEditingController _directPhoneController = TextEditingController();

  // Quick Snippets
  final List<Map<String, String>> _snippets = [
    {"title": "My Bank Details", "content": "Bank: Chase | Acc: 9876543210 | Swift: CHASEUS33"},
    {"title": "Home Address", "content": "124 Conch Street, Apt 4B, New York, NY 10001"},
    {"title": "Work Email", "content": "alex.dev@business.com"},
  ];

  final TextEditingController _snippetTitleController = TextEditingController();
  final TextEditingController _snippetContentController = TextEditingController();

  // Micro Splitter Calculator
  double _billAmount = 0.0;
  int _peopleCount = 2;
  double _tipPercentage = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Custom Header
                _buildTopAppBar(),

                // Active Notification Banner Simulation
                if (_notificationsEnabled) _buildFloatingNotificationBar(),

                // Main Tab Content
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildOverlayControlTab(),
                      _buildSmartExtractorTab(),
                      _buildQuickSnippetsTab(),
                      _buildMicroSplitterTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Bubble Overlay Simulation
          if (_overlayEnabled) _buildInteractiveFloatingBubble(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF161B22),
        indicatorColor: Colors.teal.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers, color: Colors.tealAccent),
            label: 'Floating Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services, color: Colors.tealAccent),
            label: 'Extractor',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt, color: Colors.tealAccent),
            label: 'Snippets',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate, color: Colors.tealAccent),
            label: 'Micro Split',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(bottom: BorderSide(color: Color(0xFF30363D))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.flash_on, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ClipFly Companion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'System Utility & Floating Assistant',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
                _floatingNotificationText = _overlayEnabled
                    ? "ClipFly Overlay Head Activated!"
                    : "Overlay Widget Suspended";
              });
            },
            tooltip: 'Toggle Overlay Widget',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNotificationBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade900, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _floatingNotificationText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: "https://wa.me/"));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quick utility shortcut triggered!')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'FAST ACTION',
                style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: OVERLAY CONTROL & FAST DIRECT CHAT
  Widget _buildOverlayControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direct WhatsApp Chat Launcher Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat, color: Colors.greenAccent),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Direct WhatsApp Launcher',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'No Saving Needed',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Stop saving temporary contacts! Type or paste any phone number below to open instant chat.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _directPhoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone Number with Country Code (e.g. +14155552671)',
                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.phone, color: Colors.tealAccent),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.content_paste, color: Colors.tealAccent),
                        onPressed: () async {
                          final data = await Clipboard.getData('text/plain');
                          if (data?.text != null) {
                            setState(() {
                              _directPhoneController.text = data!.text!;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.send),
                      label: const Text('Launch WhatsApp Direct Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final numText = _directPhoneController.text.trim().replaceAll(RegExp(r'[^0-9+]'), '');
                        if (numText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid phone number.')),
                          );
                          return;
                        }
                        final url = "https://wa.me/$numText";
                        Clipboard.setData(ClipboardData(text: url));
                        setState(() {
                          _floatingNotificationText = "WhatsApp link generated for $numText";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Chat link copied to clipboard: $url')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Permissions & Floating Overlay Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Overlay & Permission Controls',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Configure dynamic screen floating helper features.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Divider(color: Color(0xFF30363D), height: 24),
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Display Over Apps (Floating Head)', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Show draggable quick access bubble on top of screen', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    value: _overlayEnabled,
                    onChanged: (val) {
                      setState(() {
                        _overlayEnabled = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Floating Active Notification', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Keep quick action status bar pinned on top', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                  SwitchListTile(
                    activeColor: Colors.tealAccent,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Auto URL Link Cleaner', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Automatically strip tracking parameters (utm_, fbclid) from links', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    value: _autoCleanLinks,
                    onChanged: (val) {
                      setState(() {
                        _autoCleanLinks = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Instructions
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.touch_app, color: Colors.tealAccent, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pro Tip: You can drag the floating teal ClipFly bubble anywhere on your screen! Tap it anytime to open fast system options.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: SMART EXTRACTOR & LINK CLEANER
  Widget _buildSmartExtractorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.cleaning_services, color: Colors.tealAccent),
                      SizedBox(width: 8),
                      Text(
                        'Smart Text & Link Parser',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Paste messy text, social posts, or complex links. ClipFly will clean tracker codes and parse phone numbers, emails, and links automatically!',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _extractorController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Paste messy content here (e.g., "Contact me at +18005550199 or visit https://example.com/item?utm_source=fb&fbclid=12345")',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.flash_on),
                          label: const Text('Parse & Clean Text'),
                          onPressed: _parseAndCleanText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _extractorController.clear();
                            _extractedPhones.clear();
                            _extractedEmails.clear();
                            _extractedLinks.clear();
                            _cleanedTextResult = "";
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cleaned Link Output
          if (_cleanedTextResult.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sanitized / Cleaned Text',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _cleanedTextResult));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cleaned text copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _cleanedTextResult,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Extracted Items Sections
          if (_extractedPhones.isNotEmpty)
            _buildExtractedCategory('Extracted Phone Numbers', _extractedPhones, Icons.phone, Colors.greenAccent),
          if (_extractedEmails.isNotEmpty)
            _buildExtractedCategory('Extracted Emails', _extractedEmails, Icons.email, Colors.amberAccent),
          if (_extractedLinks.isNotEmpty)
            _buildExtractedCategory('Extracted Clean Web Links', _extractedLinks, Icons.link, Colors.blueAccent),
        ],
      ),
    );
  }

  void _parseAndCleanText() {
    final raw = _extractorController.text;
    if (raw.trim().isEmpty) return;

    // Extract Phones
    final phoneRegex = RegExp(r'(\+?\d{1,4}[-.\s]?)?(\(?\d{3}\)?[-.\s]?)?\d{3}[-.\s]?\d{4}');
    final phones = phoneRegex.allMatches(raw).map((m) => m.group(0)!).toSet().toList();

    // Extract Emails
    final emailRegex = RegExp(r'[a-zA-Z0-9.\_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final emails = emailRegex.allMatches(raw).map((m) => m.group(0)!).toSet().toList();

    // Extract Links & Strip Tracking URL Params (utm_, fbclid, gclid, etc.)
    final urlRegex = RegExp(r'https?://[^\s]+');
    final rawLinks = urlRegex.allMatches(raw).map((m) => m.group(0)!).toList();
    final cleanedLinks = <String>[];

    for (var link in rawLinks) {
      if (_autoCleanLinks) {
        try {
          final uri = Uri.parse(link);
          final cleanQueryParams = Map<String, String>.from(uri.queryParameters)
            ..removeWhere((key, value) =>
                key.startsWith('utm_') || key == 'fbclid' || key == 'gclid' || key == 'ref');
          final cleanUri = uri.replace(queryParameters: cleanQueryParams.isEmpty ? null : cleanQueryParams);
          cleanedLinks.add(cleanUri.toString());
        } catch (_) {
          cleanedLinks.add(link);
        }
      } else {
        cleanedLinks.add(link);
      }
    }

    // Replace original raw links in text with cleaned links
    String cleanedFull = raw;
    for (int i = 0; i < rawLinks.length; i++) {
      if (i < cleanedLinks.length) {
        cleanedFull = cleanedFull.replaceAll(rawLinks[i], cleanedLinks[i]);
      }
    }

    setState(() {
      _extractedPhones = phones;
      _extractedEmails = emails;
      _extractedLinks = cleanedLinks;
      _cleanedTextResult = cleanedFull;
      _floatingNotificationText = "Extracted ${phones.length} phones, ${emails.length} emails, ${cleanedLinks.length} links!";
    });
  }

  Widget _buildExtractedCategory(String title, List<String> items, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) {
                return ActionChip(
                  avatar: const Icon(Icons.copy, size: 14, color: Colors.white),
                  label: Text(
                    item,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  backgroundColor: const Color(0xFF21262D),
                  side: const BorderSide(color: Color(0xFF30363D)),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: item));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied: $item')),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: QUICK SNIPPETS VAULT
  Widget _buildQuickSnippetsTab() {
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
                    'Quick Snippet Vault',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    '1-Tap copy bank details, emails, & standard replies',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 28),
                onPressed: _showAddSnippetDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    snippet["title"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent, fontSize: 14),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      snippet["content"] ?? "",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: snippet["content"] ?? ""));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied "${snippet["title"]}" to clipboard!')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _snippets.removeAt(index);
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

  void _showAddSnippetDialog() {
    _snippetTitleController.clear();
    _snippetContentController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Add Quick Snippet', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _snippetTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Snippet Title (e.g. Bank Account)',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _snippetContentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Text Content to Copy',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_snippetTitleController.text.isNotEmpty && _snippetContentController.text.isNotEmpty) {
                setState(() {
                  _snippets.add({
                    "title": _snippetTitleController.text,
                    "content": _snippetContentController.text,
                  });
                });
                Navigator.pop(ctx);
              }
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: MICRO SPLITTER & FAST BILL SPLIT TOOL
  Widget _buildMicroSplitterTab() {
    final double totalTip = _billAmount * (_tipPercentage / 100.0);
    final double grandTotal = _billAmount + totalTip;
    final double perPerson = _peopleCount > 0 ? (grandTotal / _peopleCount) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calculate, color: Colors.amberAccent),
                      SizedBox(width: 8),
                      Text(
                        'Instant Micro Bill & Tip Splitter',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Quickly split dynamic group bills, tips, or group expenses on the fly.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Total Bill Amount (\$)',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.amberAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _billAmount = double.tryParse(val) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tip Percentage: ${_tipPercentage.toInt()}%',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    activeColor: Colors.amberAccent,
                    inactiveColor: Colors.grey.shade800,
                    onChanged: (val) {
                      setState(() {
                        _tipPercentage = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Number of People:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.tealAccent),
                            onPressed: () {
                              if (_peopleCount > 1) {
                                setState(() => _peopleCount--);
                              }
                            },
                          ),
                          Text(
                            '$_peopleCount',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                            onPressed: () {
                              setState(() => _peopleCount++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Result Card
          Card(
            color: const Color(0xFF1F2630),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Tip:', style: TextStyle(color: Colors.grey)),
                      Text('\$${totalTip.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Grand Total:', style: TextStyle(color: Colors.grey)),
                      Text('\$${grandTotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(color: Color(0xFF30363D), height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Each Person Pays:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${perPerson.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.tealAccent,
                        side: const BorderSide(color: Colors.tealAccent),
                      ),
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Copy Split Breakdown Text'),
                      onPressed: () {
                        final summary = "Bill Breakdown: Total \$${grandTotal.toStringAsFixed(2)} split between $_peopleCount people. Each pays \$${perPerson.toStringAsFixed(2)}.";
                        Clipboard.setData(ClipboardData(text: summary));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Split breakdown copied to clipboard!')),
                        );
                      },
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

  // INTERACTIVE FLOATING OVERLAY BUBBLE (SIMULATING FLOATING APP OVERLAY)
  Widget _buildInteractiveFloatingBubble() {
    return Positioned(
      left: _bubbleX,
      top: _bubbleY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubbleX += details.delta.dx;
            _bubbleY += details.delta.dy;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isBubbleExpanded ? 220 : 56,
          height: _isBubbleExpanded ? 160 : 56,
          decoration: BoxDecoration(
            color: const Color(0xFF00B4D8),
            borderRadius: BorderRadius.circular(_isBubbleExpanded ? 16 : 28),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: _isBubbleExpanded ? _buildExpandedBubbleContent() : _buildCollapsedBubbleIcon(),
        ),
      ),
    );
  }

  Widget _buildCollapsedBubbleIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          _isBubbleExpanded = true;
        });
      },
      child: const Center(
        child: Icon(
          Icons.flash_on,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildExpandedBubbleContent() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.black, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'ClipFly Quick Overlay',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = false;
                  });
                },
                child: const Icon(Icons.close, color: Colors.black, size: 18),
              ),
            ],
          ),
          const Divider(color: Colors.black87, height: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      final data = await Clipboard.getData('text/plain');
                      if (data?.text != null) {
                        setState(() {
                          _extractorController.text = data!.text!;
                          _currentIndex = 1;
                          _isBubbleExpanded = false;
                        });
                        _parseAndCleanText();
                      }
                    },
                    child: const Text('Parse Clipboard', style: TextStyle(fontSize: 11)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                        _isBubbleExpanded = false;
                      });
                    },
                    child: const Text('Open Direct Chat', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}