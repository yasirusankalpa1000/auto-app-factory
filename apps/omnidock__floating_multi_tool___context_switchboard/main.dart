import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.teal,
          tertiary: Colors.amber,
        ),
        scaffoldBackgroundColor: const Color(0xFFA6B0C3),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          primary: Colors.indigoAccent,
          secondary: Colors.tealAccent,
          tertiary: Colors.amberAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFF10141D),
      ),
      themeMode: ThemeMode.system,
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
  bool _overlayServiceEnabled = true;
  bool _floatingNotificationActive = true;
  Offset _dockPosition = const Offset(20, 200);
  bool _dockExpanded = false;

  // Stash Items Data
  final List<Map<String, String>> _stashItems = [
    {
      'title': 'Delivery Address Dump',
      'content': '124 Main Street, Suite 4B, NY 10001. Phone: +15550192834',
      'tag': 'Address',
      'time': '10 mins ago',
    },
    {
      'title': 'Quick OTP & Reference',
      'content': 'Verification Code: 849201 for Order #99102',
      'tag': 'Code',
      'time': '25 mins ago',
    },
    {
      'title': 'Supplier Price Quote',
      'content': 'Item A: \$12.50 / unit, Bulk discount at 100 units: \$9.99',
      'tag': 'Finance',
      'time': '1 hour ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pages = [
      _buildSmartExtractorTab(theme),
      _buildWhatsAppDirectTab(theme),
      _buildMultiStashTab(theme),
      _buildOverlaySettingsTab(theme),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.layers, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 10),
            const Text(
              'OmniDock',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _overlayServiceEnabled
                  ? Icons.sensors
                  : Icons.sensors_off,
              color: _overlayServiceEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Floating Service',
            onPressed: () {
              setState(() {
                _overlayServiceEnabled = !_overlayServiceEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _overlayServiceEnabled
                        ? 'Floating Overlay Dock Enabled!'
                        : 'Overlay Service Suspended',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          pages[_currentIndex],
          if (_overlayServiceEnabled) _buildDraggableFloatingDock(theme),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bolt),
            selectedIcon: Icon(Icons.bolt, color: Colors.indigo),
            label: 'Extractor',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: 'Quick Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            selectedIcon: Icon(Icons.content_paste_go),
            label: 'Clip Shelf',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets_outlined),
            label: 'Dock Control',
          ),
        ],
      ),
    );
  }

  // TAB 1: Smart Data Extractor & Workbench
  final TextEditingController _rawTextController = TextEditingController(
    text: 'Hey check this product at https://store.example.com/item?id=883 '
        'Contact sales at support@example.com or call +14155552671. '
        'Total price is \$49.99 with discount code OTP-99412.',
  );

  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  List<String> _extractedLinks = [];
  List<String> _extractedPrices = [];

  void _parseText Dump() {
    final text = _rawTextController.text;
    
    // Phone regex matcher
    final phoneRegEx = RegExp(r'\+?[0-9]{10,14}');
    // Email regex matcher
    final emailRegEx = RegExp(r'[a-zA-Z0-9.\-_]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+');
    // URL regex matcher
    final urlRegEx = RegExp(r'https?://[^\s]+');
    // Price regex matcher
    final priceRegEx = RegExp(r'\$[0-9]+(\.[0-9]{2})?');

    setState(() {
      _extractedPhones = phoneRegEx.allMatches(text).map((m) => m.group(0)!).toList();
      _extractedEmails = emailRegEx.allMatches(text).map((m) => m.group(0)!).toList();
      _extractedLinks = urlRegEx.allMatches(text).map((m) => m.group(0)!).toList();
      _extractedPrices = priceRegEx.allMatches(text).map((m) => m.group(0)!).toList();
    });
  }

  Widget _buildSmartExtractorTab(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paste any copied message or block text. OmniDock automatically dissects actionable phone numbers, emails, links, and prices.',
                      style: theme.textTheme.bodyMedium,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Input Field
            TextField(
              controller: _rawTextController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Clipboard Text Dump',
                hintText: 'Paste mixed messages, text blocks, addresses...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _rawTextController.clear();
                    _parseTextDump();
                  },
                ),
              ),
              onChanged: (_) => _parseTextDump(),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _parseTextDump,
                    icon: const Icon(Icons.search),
                    label: const Text('Parse Clipboard Dump'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _rawTextController.text =
                        'Urgent payment needed \$120.00 to account manager. Call +18005550199 or email billing@firm.org. Visit https://pay.firm.org/now';
                    _parseTextDump();
                  },
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Sample Dump'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Extracted Actionable Elements',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Extracted Sections
            _buildExtractedCategoryCard(
              theme,
              title: 'Phone Numbers',
              icon: Icons.phone,
              color: Colors.teal,
              items: _extractedPhones,
              actionLabel: 'Quick Message',
              onAction: (val) {
                _navigateToWhatsAppWith(val);
              },
            ),
            const SizedBox(height: 10),

            _buildExtractedCategoryCard(
              theme,
              title: 'Web Links & URLs',
              icon: Icons.link,
              color: Colors.blue,
              items: _extractedLinks,
              actionLabel: 'Copy Link',
              onAction: (val) => _copyToClipboard(val),
            ),
            const SizedBox(height: 10),

            _buildExtractedCategoryCard(
              theme,
              title: 'Email Addresses',
              icon: Icons.email,
              color: Colors.purple,
              items: _extractedEmails,
              actionLabel: 'Copy Email',
              onAction: (val) => _copyToClipboard(val),
            ),
            const SizedBox(height: 10),

            _buildExtractedCategoryCard(
              theme,
              title: 'Prices & Dollar Amounts',
              icon: Icons.monetization_on,
              color: Colors.amber,
              items: _extractedPrices,
              actionLabel: 'Save Snippet',
              onAction: (val) => _saveToStash('Price Tag', val, 'Finance'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedCategoryCard(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    required String actionLabel,
    required Function(String) onAction,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'None detected in text block',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAxisAlignment.center,
                children: items.map((item) {
                  return Chip(
                    avatar: Icon(icon, size: 14, color: color),
                    label: Text(
                      item,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    deleteIcon: const Icon(Icons.arrow_forward_ios, size: 12),
                    onDeleted: () => onAction(item),
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Direct Unsaved WhatsApp Switchboard
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customMsgController = TextEditingController();
  String _selectedTemplate = 'General Inquiry';

  final Map<String, String> _msgTemplates = {
    'General Inquiry': 'Hello! I am reaching out regarding your listing/service. Is it available?',
    'Address Share': 'Hi! Please send the drop-off location or delivery details here.',
    'Payment Proof': 'Hello, payment has been processed. Please find the confirmation details attached.',
    'Quick Follow Up': 'Hi, just following up on our previous conversation. Thanks!',
  };

  Widget _buildWhatsAppDirectTab(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.chat, color: Colors.teal),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Message any phone number directly without saving them as temporary contacts in your phone address book.',
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Unsaved Contact Switchboard',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number (with Country Code)',
                hintText: '+14155552671',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Quick Message Templates Macro',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _msgTemplates.keys.map((key) {
                  final isSelected = _selectedTemplate == key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(key),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedTemplate = key;
                            _customMsgController.text = _msgTemplates[key]!;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _customMsgController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message Body Draft',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final number = _phoneController.text.trim();
                      if (number.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid phone number!')),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Launching Direct Chat Switchboard for $number...'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text('Launch Direct Chat', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  icon: const Icon(Icons.content_copy),
                  tooltip: 'Copy Message',
                  onPressed: () => _copyToClipboard(_customMsgController.text),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Recent Quick Launch Log',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildRecentChatTile(theme, '+1 (415) 555-2671', 'Delivery Confirmation', '12 mins ago'),
            _buildRecentChatTile(theme, '+44 7911 123456', 'Price quote inquiry', '1 hour ago'),
            _buildRecentChatTile(theme, '+1 (800) 555-0199', 'Support Ticket #4012', 'Yesterday'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentChatTile(ThemeData theme, String number, String tag, String time) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.15)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.phone, color: Colors.white, size: 18),
        ),
        title: Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$tag • $time'),
        trailing: IconButton(
          icon: const Icon(Icons.double_arrow, size: 18),
          onPressed: () {
            setState(() {
              _phoneController.text = number;
            });
          },
        ),
      ),
    );
  }

  // TAB 3: Multi-Slot Clipboard Stash & Temporary Shelf
  Widget _buildMultiStashTab(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Multi-Slot Stash Shelf',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddStashDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Slot'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Store active snippets, reference numbers, addresses, or prices temporarily without losing them.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stashItems.length,
              itemBuilder: (context, index) {
                final item = _stashItems[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getTagColor(item['tag']!).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['tag']!,
                                style: TextStyle(
                                  color: _getTagColor(item['tag']!),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['title']!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item['time']!,
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['content']!,
                          style: theme.textTheme.bodyMedium,
                          softWrap: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Copy'),
                              onPressed: () => _copyToClipboard(item['content']!),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () {
                                setState(() {
                                  _stashItems.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Address':
        return Colors.teal;
      case 'Code':
        return Colors.purple;
      case 'Finance':
        return Colors.amber;
      default:
        return Colors.indigo;
    }
  }

  void _showAddStashDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String selectedTag = 'Quick Note';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pin New Stash Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Slot Label',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                _saveToStash(titleCtrl.text, contentCtrl.text, selectedTag);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Pin Item'),
          ),
        ],
      ),
    );
  }

  void _saveToStash(String title, String content, String tag) {
    setState(() {
      _stashItems.insert(0, {
        'title': title,
        'content': content,
        'tag': tag,
        'time': 'Just now',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pinned "$title" to Clip Shelf!')),
    );
  }

  // TAB 4: Overlay Dock Control & System Permissions Simulation
  Widget _buildOverlaySettingsTab(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Floating Dock & Permissions',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Control system overlay behavior, dynamic triggers, and floating notification badges.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Toggle Service Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: SwitchListTile(
                title: const Text('Display Above Other Apps', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Renders floating bubble utility dock over social & browser apps'),
                value: _overlayServiceEnabled,
                onChanged: (val) {
                  setState(() {
                    _overlayServiceEnabled = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: SwitchListTile(
                title: const Text('Floating Sticky Notification', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Keeps quick-parse actions inside the phone top notification shade'),
                value: _floatingNotificationActive,
                onChanged: (val) {
                  setState(() {
                    _floatingNotificationActive = val;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Interactive Dock Visual Customizer',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.touch_app, color: Colors.indigo),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Test Dragging the Floating Widget on screen! Tap bubble to expand dynamic tools.',
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _dockPosition = const Offset(20, 200);
                        _dockExpanded = true;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Floating Bubble Position'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Daily Engagement & Utility Features',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildFeatureInfoTile(
              theme,
              icon: Icons.shield,
              title: 'Privacy Focused Parsing',
              desc: 'Clipboard text parsing occurs 100% locally on device memory.',
            ),
            _buildFeatureInfoTile(
              theme,
              icon: Icons.flash_on,
              title: 'Zero Contact Clutter',
              desc: 'Initiate WhatsApp discussions without bloating your Google/iCloud phonebook.',
            ),
            _buildFeatureInfoTile(
              theme,
              icon: Icons.layers,
              title: 'Persistent Clip Workspace',
              desc: 'Never lose critical codes, flight numbers, or delivery notes during context switches.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureInfoTile(ThemeData theme, {required IconData icon, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Draggable Interactive Floating Overlay Dock Widget Simulation
  Widget _buildDraggableFloatingDock(ThemeData theme) {
    return Positioned(
      left: _dockPosition.dx,
      top: _dockPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _dockPosition += details.delta;
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(_dockExpanded ? 20 : 30),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(_dockExpanded ? 20 : 30),
              border: Border.all(color: theme.colorScheme.primary, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: _dockExpanded ? _buildExpandedDockContent(theme) : _buildCollapsedDockBubble(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedDockBubble(ThemeData theme) {
    return InkWell(
      onTap: () {
        setState(() {
          _dockExpanded = true;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            radius: 18,
            child: const Icon(Icons.bolt, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 6),
          const Text(
            'OmniDock',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildExpandedDockContent(ThemeData theme) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.layers, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              const Text(
                'Quick Switchboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    _dockExpanded = false;
                  });
                },
                child: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          const Divider(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildFloatingActionChip(
                theme,
                icon: Icons.content_paste,
                label: 'Parse Clip',
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                    _dockExpanded = false;
                  });
                  _parseTextDump();
                },
              ),
              _buildFloatingActionChip(
                theme,
                icon: Icons.chat_outlined,
                label: 'Direct Chat',
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                    _dockExpanded = false;
                  });
                },
              ),
              _buildFloatingActionChip(
                theme,
                icon: Icons.bookmark_add,
                label: 'Stash Note',
                onTap: () {
                  _showAddStashDialog(context);
                },
              ),
              _buildFloatingActionChip(
                theme,
                icon: Icons.share,
                label: 'Share Stash',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing active stash items...')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionChip(ThemeData theme, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Utilities
  void _navigateToWhatsAppWith(String phone) {
    setState(() {
      _phoneController.text = phone;
      _currentIndex = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone number $phone sent to Quick Chat Tab!')),
    );
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$text" to Clipboard!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'OmniDock Utility',
      applicationVersion: 'v2.4.0',
      applicationIcon: const Icon(Icons.layers, size: 40, color: Colors.indigo),
      children: [
        const Text(
          'OmniDock eliminates daily multi-app clutter by extracting contacts, links, and financial data directly from copied blocks, enabling instant unsaved chats and persistent clip shelves.',
        ),
      ],
    );
  }
}