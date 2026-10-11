import 'package:flutter/material.dart';

void main() {
  runApp(const ClipPulseApp());
}

class ClipPulseApp extends StatelessWidget {
  const ClipPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101418),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ClipSnippet {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;
  final List<String> extractedLinks;
  final List<String> extractedPhones;
  final List<String> extractedEmails;

  ClipSnippet({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
    required this.extractedLinks,
    required this.extractedPhones,
    required this.extractedEmails,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Settings & Permission simulation states
  bool _overlayEnabled = true;
  bool _floatingNotificationActive = true;
  bool _autoSanitizeUrls = true;
  bool _showFloatingBubble = true;

  // Floating bubble positions in simulator
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;

  // Stored snippets
  final List<ClipSnippet> _snippets = [
    ClipSnippet(
      id: '1',
      title: 'Meeting Link & Contact',
      content: 'Hey join the call at https://meet.example.com/room?utm_source=share&ref=123 or call +18005550199 or email dev@service.org for password.',
      category: 'Work',
      timestamp: DateTime.now().subtract(const Duration(minutes: 14)),
      extractedLinks: ['https://meet.example.com/room?utm_source=share&ref=123'],
      extractedPhones: ['+18005550199'],
      extractedEmails: ['dev@service.org'],
    ),
    ClipSnippet(
      id: '2',
      title: 'Delivery Address Snippet',
      content: 'Package code #99482. Address: 742 Evergreen Terrace. Urgent inquiry email: support@logistics.com',
      category: 'Personal',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      extractedLinks: [],
      extractedPhones: [],
      extractedEmails: ['support@logistics.com'],
    ),
  ];

  // Text Studio Controllers
  final TextEditingController _inputStudioController = TextEditingController();
  final TextEditingController _titleInputController = TextEditingController();
  String _selectedCategory = 'General';

  // Parser output states
  List<String> _foundUrls = [];
  List<String> _foundPhones = [];
  List<String> _foundEmails = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _inputStudioController.addListener(_parseInputText);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputStudioController.dispose();
    _titleInputController.dispose();
    super.dispose();
  }

  void _parseInputText() {
    final text = _inputStudioController.text;
    
    // Extract URLs
    final urlRegExp = RegExp(r'https?://[^\s]+', caseSensitive: false);
    final urls = urlRegExp.allMatches(text).map((m) => m.group(0) ?? '').where((s) => s.isNotEmpty).toList();

    // Extract Phone Numbers
    final phoneRegExp = RegExp(r'\+?[0-9]{8,15}');
    final phones = phoneRegExp.allMatches(text).map((m) => m.group(0) ?? '').where((s) => s.isNotEmpty).toList();

    // Extract Emails
    final emailRegExp = RegExp(r'[a-zA-Z0-9.\_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final emails = emailRegExp.allMatches(text).map((m) => m.group(0) ?? '').where((s) => s.isNotEmpty).toList();

    setState(() {
      _foundUrls = urls;
      _foundPhones = phones;
      _foundEmails = emails;
    });
  }

  void _sanitizeUrlText() {
    String text = _inputStudioController.text;
    if (text.isEmpty) return;

    // Remove tracking parameters like utm_source, ref, fbclid, etc.
    text = text.replaceAll(RegExp(r'(\?|&)(utm_[^&=]+|ref|fbclid|gclid|gclsrc|mc_eid)=[^&]*'), '');
    text = text.replaceAll(RegExp(r'\?&'), '?');
    if (text.endsWith('?') || text.endsWith('&')) {
      text = text.substring(0, text.length - 1);
    }

    _inputStudioController.text = text;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stripped all web tracking tags & referral strings!'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveCurrentStudioSnippet() {
    final text = _inputStudioController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or paste text first!')),
      );
      return;
    }

    final newSnippet = ClipSnippet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleInputController.text.trim().isEmpty ? 'Quick Note' : _titleInputController.text.trim(),
      content: text,
      category: _selectedCategory,
      timestamp: DateTime.now(),
      extractedLinks: List.from(_foundUrls),
      extractedPhones: List.from(_foundPhones),
      extractedEmails: List.from(_foundEmails),
    );

    setState(() {
      _snippets.insert(0, newSnippet);
      _inputStudioController.clear();
      _titleInputController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Snippet saved into ClipPulse Stash!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _copyToClipboard(String content, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $label to clipboard!'),
        backgroundColor: Colors.indigo,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _quickLaunchUnsavedWhatsApp(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening direct conversation stream for $phone without saving...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeaderBar(),
                _buildNotificationOverlayBanner(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSmartStudioTab(),
                      _buildSnippetStashTab(),
                      _buildQuickToolsTab(),
                      _buildOverlaySettingsTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Interactive Dynamic Floating Bubble Simulator (Display Over Apps Simulation)
            if (_showFloatingBubble && _overlayEnabled)
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade800,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.tealAccent, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        const Text(
                          'ClipPulse Live',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            _inputStudioController.text = 'Sample copied text with https://site.com?ref=99 and +19998887777';
                            _tabController.animateTo(0);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.content_paste, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1A2129),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'ClipPulse Suite',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ambient Overlay & Smart Extractor',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showFloatingBubble ? Icons.visibility : Icons.visibility_off,
              color: _showFloatingBubble ? Colors.tealAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _showFloatingBubble = !_showFloatingBubble;
              });
            },
            tooltip: 'Toggle Floating Overlay Bubble',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationOverlayBanner() {
    if (!_floatingNotificationActive) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.teal.shade900.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.amber, size: 18),
            const SizedBox(width: 8),
            const Text(
              'System Overlay Bar Active: Quick-Extract running',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                _copyToClipboard('https://cleanlink.org', 'Quick Sanitized Link');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Quick Clean', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF141A20),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.tealAccent,
        labelColor: Colors.tealAccent,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(icon: Icon(Icons.edit_note), text: 'Smart Studio'),
          Tab(icon: Icon(Icons.folder_special), text: 'Snippet Stash'),
          Tab(icon: Icon(Icons.build_circle), text: 'Quick Tools'),
          Tab(icon: Icon(Icons.tune), text: 'Overlay Settings'),
        ],
      ),
    );
  }

  Widget _buildSmartStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Clipboard Parser & Sanitizer',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste dirty links, cluttered texts, or numbers to instantly clean and categorize them.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleInputController,
            decoration: const InputDecoration(
              labelText: 'Snippet Title (Optional)',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _inputStudioController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Paste any text, WhatsApp message, address or URL here...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _sanitizeUrlText,
                  icon: const Icon(Icons.cleaning_services, size: 16),
                  label: const Text('Strip URL Tracking Tag (\$)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _saveCurrentStudioSnippet,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save Snippet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildExtractedEntitiesSection(),
        ],
      ),
    );
  }

  Widget _buildExtractedEntitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detected Smart Action Chips',
          style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        if (_foundUrls.isEmpty && _foundPhones.isEmpty && _foundEmails.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2129),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: const Text(
              'No links, phone numbers, or emails detected yet. Paste text above to extract smart actions.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        if (_foundUrls.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text('Web Links Cleaned:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _foundUrls.map((url) {
              return Chip(
                avatar: const Icon(Icons.link, color: Colors.blue, size: 16),
                label: Text(url, style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: const Color(0xFF1A2129),
                deleteIcon: const Icon(Icons.copy, size: 14, color: Colors.grey),
                onDeleted: () => _copyToClipboard(url, 'Link'),
              );
            }).toList(),
          ),
        ],
        if (_foundPhones.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Phone Numbers (Direct WhatsApp Action):', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _foundPhones.map((phone) {
              return ActionChip(
                avatar: const Icon(Icons.phone, color: Colors.green, size: 16),
                label: Text('Chat with $phone', style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: Colors.green.shade900.withOpacity(0.5),
                onPressed: () => _quickLaunchUnsavedWhatsApp(phone),
              );
            }).toList(),
          ),
        ],
        if (_foundEmails.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Emails Extracted:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _foundEmails.map((email) {
              return ActionChip(
                avatar: const Icon(Icons.email, color: Colors.amber, size: 16),
                label: Text(email, style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: const Color(0xFF1A2129),
                onPressed: () => _copyToClipboard(email, 'Email Address'),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSnippetStashTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _snippets.length,
      itemBuilder: (context, index) {
        final item = _snippets[index];
        return Card(
          color: const Color(0xFF1A2129),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade900,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.content,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _copyToClipboard(item.content, item.title),
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text('Copy All', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    if (item.extractedPhones.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: () => _quickLaunchUnsavedWhatsApp(item.extractedPhones.first),
                        icon: const Icon(Icons.chat, size: 14),
                        label: const Text('Direct Chat', style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade800,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(80, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
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

  Widget _buildQuickToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Utility Toolbox',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            title: 'URL Tracking Parameter Stripper',
            description: 'Cleans tracking codes like utm_source, ref, and affiliate parameters instantly from links.',
            icon: Icons.link_off,
            color: Colors.indigo,
            onTap: () {
              _inputStudioController.text = 'https://store.example.com/item?id=8832&utm_source=facebook&ref=promo99';
              _tabController.animateTo(0);
              _sanitizeUrlText();
            },
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            title: 'Unsaved WhatsApp Direct Launcher',
            description: 'Start messaging any phone number extracted from text without clogging your mobile phone contacts.',
            icon: Icons.message,
            color: Colors.green,
            onTap: () {
              _quickLaunchUnsavedWhatsApp('+18005550199');
            },
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            title: 'Case Converter & Format Sanitizer',
            description: 'Converts clipboard text to UPPERCASE, lowercase, Title Case, or removes line breaks.',
            icon: Icons.text_fields,
            color: Colors.purple,
            onTap: () {
              if (_inputStudioController.text.isNotEmpty) {
                _inputStudioController.text = _inputStudioController.text.toUpperCase();
                _tabController.animateTo(0);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter text in Smart Studio tab first!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1A2129),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        onTap: onTap,
      ),
    );
  }

  Widget _buildOverlaySettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ambient System Permissions & Preferences',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'ClipPulse uses dynamic system overlays to detect and format copied text across apps.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            activeColor: Colors.tealAccent,
            title: const Text('Display Above Other Apps Permission', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Enables the live floating widget bubble overlay over social and messaging apps.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            value: _overlayEnabled,
            onChanged: (val) {
              setState(() {
                _overlayEnabled = val;
              });
            },
          ),
          const Divider(color: Colors.grey),
          SwitchListTile(
            activeColor: Colors.tealAccent,
            title: const Text('Persistent Notification Toolbar', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Show quick action bar in notification center for 1-tap link cleaning.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            value: _floatingNotificationActive,
            onChanged: (val) {
              setState(() {
                _floatingNotificationActive = val;
              });
            },
          ),
          const Divider(color: Colors.grey),
          SwitchListTile(
            activeColor: Colors.tealAccent,
            title: const Text('Auto-Sanitize URLs on Copy', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Automatically strip tracking tags (\$) whenever a web link is copied.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            value: _autoSanitizeUrls,
            onChanged: (val) {
              setState(() {
                _autoSanitizeUrls = val;
              });
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield, color: Colors.tealAccent),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ClipPulse operates 100% locally on device. No snippets or copied details ever leave your smartphone.',
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
}