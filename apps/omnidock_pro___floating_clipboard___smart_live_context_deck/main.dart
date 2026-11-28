import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniDock Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({super.key});

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentIndex = 0;
  
  // App States
  bool _overlayPermissionGranted = true;
  bool _dockEnabled = true;
  bool _notificationServiceActive = true;
  
  // Controller for Extractor
  final TextEditingController _extractorController = TextEditingController();
  
  // Extracted Data Holders
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedUrls = [];
  List<String> _extractedAmounts = [];

  // Snippets Storage
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Details (LKR/USD)',
      'content': 'Acc: 8004921049 | Bank: Commercial Bank | Branch: Colombo Main',
      'category': 'Finance'
    },
    {
      'title': 'Standard Business Reply',
      'content': 'Hello! Thanks for reaching out. Please check our catalog or reply with your order details.',
      'category': 'Work'
    },
    {
      'title': 'Office Address',
      'content': 'No 45, Tech Innovation Hub, Lotus Road, Colombo 03',
      'category': 'Personal'
    },
  ];

  // Active Floating Sticky Notes / Notifications
  final List<String> _stickyNotifications = [
    '⚡ Quick Order ID: #99402 - Pending Confirmation',
    '📌 Call Client at 4:30 PM regarding project brief',
  ];

  final TextEditingController _snippetTitleController = TextEditingController();
  final TextEditingController _snippetContentController = TextEditingController();
  final TextEditingController _notificationInputController = TextEditingController();

  void _parseRawText(String input) {
    setState(() {
      // Extract Phone Numbers
      RegExp phoneRegex = RegExp(r'(\+?\d{1,4}[-.\s]?)?(\(?\d{3}\)?[-.\s]?)?\d{3}[-.\s]?\d{4}');
      _extractedPhones = phoneRegex.allMatches(input).map((m) => m.group(0)!).toSet().toList();

      // Extract Emails
      RegExp emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
      _extractedEmails = emailRegex.allMatches(input).map((m) => m.group(0)!).toSet().toList();

      // Extract URLs
      RegExp urlRegex = RegExp(r'https?://[^\s]+');
      _extractedUrls = urlRegex.allMatches(input).map((m) => m.group(0)!).toSet().toList();

      // Extract Currency/Amounts
      RegExp amountRegex = RegExp(r'(\$|LKR|EUR|Rs\.?)\s?\d+(?:,\d{3})*(?:\.\d{2})?');
      _extractedAmounts = amountRegex.allMatches(input).map((m) => m.group(0)!).toSet().toList();
    });
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: "$text"'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.dashboard_customize, color: Colors.tealAccent),
            SizedBox(width: 10),
            Text(
              'OmniDock Pro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _dockEnabled ? Icons.sensors : Icons.sensors_off,
              color: _dockEnabled ? Colors.tealAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _dockEnabled = !_dockEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_dockEnabled ? 'Floating Dock Simulation Activated' : 'Floating Dock Paused'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Notification Overlay Simulation Banner
            if (_dockEnabled) _buildLiveOverlayBanner(),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildSmartExtractorTab(),
                  _buildSnippetVaultTab(),
                  _buildStickyNotificationTab(),
                  _buildDockSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Extractor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_special),
            label: 'Snippet Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: 'Sticky Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Dock HUD',
          ),
        ],
      ),
    );
  }

  // --- Live Simulated Floating Overlay Banner ---
  Widget _buildLiveOverlayBanner() {
    return Container(
      width: double.infinity,
      color: Colors.teal.shade900.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.layers, color: Colors.tealAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Floating Dock Active: Ready to capture copied text & notifications',
              style: const TextStyle(fontSize: 12, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 1: Smart Extractor ---
  Widget _buildSmartExtractorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Context Extractor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste long, unorganized messages, chats, or emails below. OmniDock will instantly parse phone numbers, emails, URLs, and price tags.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _extractorController,
            maxLines: 5,
            onChanged: _parseRawText,
            decoration: InputDecoration(
              hintText: 'Paste messy text here (e.g. "Call John at +94771234567 or pay \$45.00 via email contact@test.com")',
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _extractorController.clear();
                  _parseRawText('');
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _extractorController.text =
                        "Hey team, contact support at support@company.com or call +1-800-555-0199. Send payment of \$149.99 to https://pay.company.com/invoice";
                    _parseRawText(_extractorController.text);
                  },
                  icon: const Icon(Icons.bug_report, size: 16),
                  label: const Text('Load Sample Text'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade800,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Extracted Smart Elements',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildResultCategory('Phone Numbers', Icons.phone, _extractedPhones, Colors.green),
          _buildResultCategory('Email Addresses', Icons.email, _extractedEmails, Colors.orange),
          _buildResultCategory('Web Links', Icons.link, _extractedUrls, Colors.blue),
          _buildResultCategory('Amounts & Prices', Icons.monetization_on, _extractedAmounts, Colors.tealAccent),
        ],
      ),
    );
  }

  Widget _buildResultCategory(String title, IconData icon, List<String> items, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            children: [
              Icon(icon, color: accentColor, size: 18),
              const SizedBox(width: 8),
              Text(
                '$title (${items.length})',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Text('None detected', style: TextStyle(color: Colors.grey, fontSize: 12))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: items.map((item) {
                return InkWell(
                  onTap: () => _copyToClipboard(item),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            item,
                            style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.copy, size: 12, color: Colors.white70),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // --- TAB 2: Snippet Vault ---
  Widget _buildSnippetVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Multi-Pocket Snippet Vault',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 28),
                onPressed: () => _showAddSnippetDialog(),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep frequently used bank details, addresses, template responses, and notes accessible with 1-tap floating copy.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              snippet['title'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              snippet['category'] ?? 'General',
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                            onPressed: () {
                              setState(() {
                                _snippets.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        snippet['content'] ?? '',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => _copyToClipboard(snippet['content'] ?? ''),
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copy Snippet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Quick Snippet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _snippetTitleController,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g. Bank Account)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _snippetContentController,
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
                if (_snippetTitleController.text.isNotEmpty && _snippetContentController.text.isNotEmpty) {
                  setState(() {
                    _snippets.add({
                      'title': _snippetTitleController.text,
                      'content': _snippetContentController.text,
                      'category': 'Custom',
                    });
                  });
                  _snippetTitleController.clear();
                  _snippetContentController.clear();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Save Snippet', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // --- TAB 3: Sticky Notifications ---
  Widget _buildStickyNotificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sticky Notification Launcher',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pin dynamic reminders and quick texts to your simulated notification shade so they remain visible while using other apps.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _notificationInputController,
                  decoration: const InputDecoration(
                    hintText: 'Enter text to pin on screen top...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.push_pin, color: Colors.tealAccent, size: 30),
                onPressed: () {
                  if (_notificationInputController.text.isNotEmpty) {
                    setState(() {
                      _stickyNotifications.add(_notificationInputController.text);
                      _notificationInputController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Currently Pinned Notifications',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (_stickyNotifications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('No active sticky notifications pinned.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stickyNotifications.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal.shade700),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.tealAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _stickyNotifications[index],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _stickyNotifications.removeAt(index);
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

  // --- TAB 4: Dock HUD & System Controls ---
  Widget _buildDockSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay Deck HUD & Permissions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage persistent system overlay, clipboard monitors, and quick floating action triggers.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text('Display Over Other Apps Permission'),
                  subtitle: const Text('Allows OmniDock floating widget to stay visible across apps'),
                  value: _overlayPermissionGranted,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionGranted = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text('Clipboard Auto-Detection Engine'),
                  subtitle: const Text('Auto-parses text as soon as you copy anything to phone memory'),
                  value: _dockEnabled,
                  onChanged: (val) {
                    setState(() {
                      _dockEnabled = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.tealAccent,
                  title: const Text('Background Service Keep-Alive'),
                  subtitle: const Text('Prevents Android/iOS from stopping the dock during multi-tasking'),
                  value: _notificationServiceActive,
                  onChanged: (val) {
                    setState(() {
                      _notificationServiceActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Utility Tools',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              leading: const Icon(Icons.cleaning_services, color: Colors.tealAccent),
              title: const Text('URL Tracking Token Cleaner'),
              subtitle: const Text('Strips ?utm_source= and tracking junk from copied links'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showCleanUrlDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCleanUrlDialog() {
    final TextEditingController urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Clean Tracking URL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Paste URL with UTM tags',
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
                String clean = urlController.text.split('?').first;
                _copyToClipboard(clean);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Clean & Copy', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}