import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OverlayXApp());
}

class OverlayXApp extends StatelessWidget {
  const OverlayXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayX Assistant',
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
      home: const MainHomeScreen(),
    );
  }
}

class MicroSnippet {
  final String id;
  final String title;
  final String content;
  final String category;
  final Color badgeColor;

  MicroSnippet({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.badgeColor,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Floating Bubble Overlay State
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;
  bool _overlayPermissionEnabled = true;
  bool _persistentNotificationEnabled = true;
  bool _autoCleanSpaces = false;
  int _copiedCountToday = 14;
  int _activeStreakDays = 6;

  // WhatsApp Tool
  final TextEditingController _waPhoneController = TextEditingController();
  final TextEditingController _waMessageController = TextEditingController();
  String _generatedWaLink = '';

  // Bank Snippet Tool
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccController = TextEditingController();
  final TextEditingController _bankHolderController = TextEditingController();
  final TextEditingController _bankBranchController = TextEditingController();

  // Address Builder Tool
  final TextEditingController _addrNameController = TextEditingController();
  final TextEditingController _addrPhoneController = TextEditingController();
  final TextEditingController _addrStreetController = TextEditingController();
  final TextEditingController _addrCityController = TextEditingController();

  // Text Transformer Tool
  final TextEditingController _transformInputController = TextEditingController();
  String _transformedOutput = '';

  // Snippets List
  final List<MicroSnippet> _snippets = [
    MicroSnippet(
      id: '1',
      title: 'Primary Bank Details',
      content: 'Bank: Commercial Bank\nAccount: 8001239941\nName: A. B. Silva\nBranch: Colombo Central',
      category: 'Payment',
      badgeColor: Colors.teal,
    ),
    MicroSnippet(
      id: '2',
      title: 'Home Delivery Address',
      content: 'Recipient: K. Perera\nPhone: +94771234567\nAddress: No. 45, Flower Road\nCity: Kandy',
      category: 'Delivery',
      badgeColor: Colors.amber,
    ),
    MicroSnippet(
      id: '3',
      title: 'Standard Inquiry Reply',
      content: 'Hello! Thank you for contacting us. Our daily operational hours are 9 AM to 6 PM. How can we assist you today?',
      category: 'Business',
      badgeColor: Colors.blue,
    ),
  ];

  @override
  void dispose() {
    _waPhoneController.dispose();
    _waMessageController.dispose();
    _bankNameController.dispose();
    _bankAccController.dispose();
    _bankHolderController.dispose();
    _bankBranchController.dispose();
    _addrNameController.dispose();
    _addrPhoneController.dispose();
    _addrStreetController.dispose();
    _addrCityController.dispose();
    _transformInputController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    if (text.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      _copiedCountToday++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cleanTextSpaces() {
    final raw = _transformInputController.text;
    if (raw.isEmpty) return;
    final cleaned = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    setState(() {
      _transformedOutput = cleaned;
    });
  }

  void _extractPhoneNumbers() {
    final raw = _transformInputController.text;
    final regExp = RegExp(r'(\+?\d[\d\-\s]{7,}\d)');
    final matches = regExp.allMatches(raw).map((m) => m.group(0)?.trim() ?? '').where((s) => s.isNotEmpty).toList();
    setState(() {
      _transformedOutput = matches.isNotEmpty ? matches.join('\n') : 'No phone numbers detected.';
    });
  }

  void _extractEmails() {
    final raw = _transformInputController.text;
    final regExp = RegExp(r'[a-zA-Z0-9.\_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final matches = regExp.allMatches(raw).map((m) => m.group(0) ?? '').toList();
    setState(() {
      _transformedOutput = matches.isNotEmpty ? matches.join('\n') : 'No email addresses detected.';
    });
  }

  void _formatWaLink() {
    String phone = _waPhoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.isEmpty) return;
    String msg = Uri.encodeComponent(_waMessageController.text.trim());
    String link = 'https://wa.me/$phone';
    if (msg.isNotEmpty) {
      link += '?text=$msg';
    }
    setState(() {
      _generatedWaLink = link;
    });
  }

  void _addNewSnippet(String title, String content, String category, Color color) {
    if (title.isEmpty || content.isEmpty) return;
    setState(() {
      _snippets.insert(
        0,
        MicroSnippet(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: category,
          badgeColor: color,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Page View
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildOverlayControlTab(),
                _buildSnippetsTab(),
                _buildTextToolsTab(),
                _buildEngagementHubTab(),
              ],
            ),
          ),

          // Floating Assistant HUD Bubble
          if (_overlayPermissionEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Keep within screen boundaries
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(30.0, screenSize.height - 120.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isBubbleExpanded) _buildExpandedHudMenu(),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'hud_bubble',
                      backgroundColor: Colors.teal,
                      elevation: 8,
                      onPressed: () {
                        setState(() {
                          _isBubbleExpanded = !_isBubbleExpanded;
                        });
                      },
                      child: Icon(
                        _isBubbleExpanded ? Icons.close : Icons.layers,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
            _isBubbleExpanded = false;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.teal.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bolt, color: Colors.grey),
            selectedIcon: Icon(Icons.bolt, color: Colors.teal),
            label: 'HUD Control',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets, color: Colors.grey),
            selectedIcon: Icon(Icons.widgets, color: Colors.teal),
            label: 'Snippets',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services, color: Colors.grey),
            selectedIcon: Icon(Icons.cleaning_services, color: Colors.teal),
            label: 'Text Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars, color: Colors.grey),
            selectedIcon: Icon(Icons.stars, color: Colors.teal),
            label: 'Activity',
          ),
        ],
      ),
    );
  }

  // Expanded Floating HUD Quick Palette
  Widget _buildExpandedHudMenu() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bolt, color: Colors.teal, size: 18),
              SizedBox(width: 6),
              Text(
                'Overlay Quick HUD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white70, height: 16),
          _hudMenuItem(
            icon: Icons.content_copy,
            label: 'Copy Bank Snippet',
            onTap: () {
              if (_snippets.isNotEmpty) {
                _copyToClipboard(_snippets.first.content, 'Bank Info');
              }
              setState(() => _isBubbleExpanded = false);
            },
          ),
          _hudMenuItem(
            icon: Icons.cleaning_services,
            label: 'Clean System Clipboard',
            onTap: () async {
              final data = await Clipboard.getData(ClipboardkText);
              if (data?.text != null) {
                final cleaned = data!.text!.replaceAll(RegExp(r'\s+'), ' ').trim();
                await Clipboard.setData(ClipboardData(text: cleaned));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Clipboard spaces cleaned!'), backgroundColor: Colors.teal),
                  );
                }
              }
              setState(() => _isBubbleExpanded = false);
            },
          ),
          _hudMenuItem(
            icon: Icons.phone_forwarded,
            label: 'Open WA Quick Link',
            onTap: () {
              setState(() {
                _currentTabIndex = 1;
                _isBubbleExpanded = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _hudMenuItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: OVERLAY HUD CONTROLS & NOTIFICATION SIMULATOR
  Widget _buildOverlayControlTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Floating Overlay Controls', 'Persistent dynamic utility widget active over apps'),
          const SizedBox(height: 16),

          // Simulation Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900.withOpacity(0.8), const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.layers, color: Colors.teal, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Floating Widget Status',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            _overlayPermissionEnabled ? 'Active & On Top' : 'Disabled',
                            style: TextStyle(
                              color: _overlayPermissionEnabled ? Colors.greenAccent : Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _overlayPermissionEnabled,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _overlayPermissionEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'The Floating HUD Bubble can be dragged anywhere on your mobile display. Tap it at any time to copy snippets or format text instantly!',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'System Integrations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Settings Switches
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Simulates system overlay permission for global bubble access', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _overlayPermissionEnabled,
                  activeColor: Colors.teal,
                  onChanged: (v) => setState(() => _overlayPermissionEnabled = v),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  title: const Text('Persistent Notification Drawer Bar', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Keep quick action bar in your notification shade', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _persistentNotificationEnabled,
                  activeColor: Colors.teal,
                  onChanged: (v) => setState(() => _persistentNotificationEnabled = v),
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  title: const Text('Auto-Trim Copied Spaces', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Automatically remove double spaces when copying', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  value: _autoCleanSpaces,
                  activeColor: Colors.teal,
                  onChanged: (v) => setState(() => _autoCleanSpaces = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Live Notification Bar Preview',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Notification Simulator Preview Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey.shade700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications_active, color: Colors.teal, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'OverlayX Quick Assistant Service',
                      style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text('Now', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Quick Tools Ready • Tap any button below to trigger helper',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.teal,
                        side: const BorderSide(color: Colors.teal),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () => _copyToClipboard('Standard Reply Sent!', 'Notification Quick Action'),
                      icon: const Icon(Icons.flash_on, size: 14),
                      label: const Text('Quick Reply', style: TextStyle(fontSize: 11)),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber,
                        side: const BorderSide(color: Colors.amber),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () {
                        setState(() => _currentTabIndex = 2);
                      },
                      icon: const Icon(Icons.cleaning_services, size: 14),
                      label: const Text('Clean Text', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: QUICK SNIPPETS & DIRECT GENERATORS
  Widget _buildSnippetsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Micro Snippets & Generators', 'Generate payment, address, and chat links in seconds'),
          const SizedBox(height: 16),

          // Direct WhatsApp Builder Accordion
          ExpansionTile(
            backgroundColor: const Color(0xFF1E293B),
            collapsedBackgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.phone_forwarded, color: Colors.green),
            title: const Text('Direct WhatsApp Chat Generator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Send WhatsApp message without saving contact number', style: TextStyle(fontSize: 11, color: Colors.grey)),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _waPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number (with Country Code)',
                        hintText: 'e.g. 94771234567',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      onChanged: (_) => _formatWaLink(),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _waMessageController,
                      decoration: const InputDecoration(
                        labelText: 'Optional Preset Message',
                        hintText: 'e.g. Hello, I am inquiring about...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.message),
                      ),
                      onChanged: (_) => _formatWaLink(),
                    ),
                    if (_generatedWaLink.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _generatedWaLink,
                                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.white, size: 18),
                              onPressed: () => _copyToClipboard(_generatedWaLink, 'WhatsApp Link'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bank Details Builder
          ExpansionTile(
            backgroundColor: const Color(0xFF1E293B),
            collapsedBackgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.account_balance, color: Colors.amber),
            title: const Text('Bank Details Format Builder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Format clean transfer details for instant sharing', style: TextStyle(fontSize: 11, color: Colors.grey)),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _bankNameController,
                      decoration: const InputDecoration(labelText: 'Bank Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _bankAccController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Account Number', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _bankHolderController,
                      decoration: const InputDecoration(labelText: 'Account Holder Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _bankBranchController,
                      decoration: const InputDecoration(labelText: 'Branch Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () {
                        String bankInfo = 'Bank: ${_bankNameController.text}\nAccount: ${_bankAccController.text}\nName: ${_bankHolderController.text}\nBranch: ${_bankBranchController.text}';
                        _addNewSnippet(_bankNameController.text.isNotEmpty ? '${_bankNameController.text} Account' : 'Bank Account', bankInfo, 'Payment', Colors.amber);
                        _copyToClipboard(bankInfo, 'Bank Details Snippet');
                      },
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Generate & Save Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Snippets Bank',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              Chip(
                label: Text('${_snippets.length} Saved', style: const TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: Colors.teal.shade800,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Snippet Cards List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final snippet = _snippets[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              snippet.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: snippet.badgeColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: snippet.badgeColor, width: 0.8),
                            ),
                            child: Text(
                              snippet.category,
                              style: TextStyle(color: snippet.badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snippet.content,
                        style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                            onPressed: () {
                              setState(() {
                                _snippets.removeAt(index);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.teal, size: 18),
                            onPressed: () => _copyToClipboard(snippet.content, snippet.title),
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
    );
  }

  // TAB 3: SMART TEXT TRANSFORMER & CLEANER
  Widget _buildTextToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Text Micro-Transformer', 'Clean messy pasted text, extract phones, emails & standard format'),
          const SizedBox(height: 16),

          // Raw Input Field
          TextField(
            controller: _transformInputController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Paste messy raw text, copied paragraphs, or customer inquiries here...',
              fillColor: const Color(0xFF1E293B),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),

          // Tool Buttons Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                onPressed: _cleanTextSpaces,
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text('Clean Spaces'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                onPressed: _extractPhoneNumbers,
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Extract Numbers'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                onPressed: _extractEmails,
                icon: const Icon(Icons.email, size: 16),
                label: const Text('Extract Emails'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                onPressed: () {
                  setState(() {
                    _transformedOutput = _transformInputController.text.toUpperCase();
                  });
                },
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('UPPERCASE'),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text('Transformed Output Preview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          const SizedBox(height: 8),

          // Output Container
          Container(
            width: double.infinity,
            minHeight: 120,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: SelectableText(
              _transformedOutput.isEmpty ? 'Your processed text result will appear here...' : _transformedOutput,
              style: TextStyle(
                color: _transformedOutput.isEmpty ? Colors.grey : Colors.greenAccent,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 12),
          if (_transformedOutput.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _copyToClipboard(_transformedOutput, 'Transformed Result'),
                icon: const Icon(Icons.copy),
                label: const Text('Copy Result to Clipboard', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  // TAB 4: ENGAGEMENT HUB & MONETIZATION DASHBOARD
  Widget _buildEngagementHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('Activity & Engagement Hub', 'Track your daily automated micro-actions and productivity'),
          const SizedBox(height: 16),

          // Engagement Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Copied Today', '$_copiedCountToday Items', Icons.content_copy, Colors.teal),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard('Active Streak', '$_activeStreakDays Days', Icons.local_fire_department, Colors.deepOrange),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Utility Gamification Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Daily Micro-Tool Session Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                    Text('Level 3 Pro', style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: (_copiedCountToday / 30).clamp(0.1, 1.0),
                  backgroundColor: Colors.black87,
                  color: Colors.teal,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete ${30 - _copiedCountToday} more copy formatting actions to unlock Cyber HUD theme skin!',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Simulated AdMob Monetization Placeholder Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3), style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 6),
                    Text('SPONSORED PROMOTIONAL BANNER', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.star, color: Colors.amber, size: 14),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Boost mobile workflow efficiency with OverlayX Pro Features!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('Overlay HUD Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          const SizedBox(height: 8),

          _buildTipItem(Icons.touch_app, 'Drag the teal HUD bubble to any edge of your screen so it never blocks your view.'),
          _buildTipItem(Icons.copy_all, 'Save your frequently used bank account info or address for instant 1-tap copying.'),
          _buildTipItem(Icons.phonelink_setup, 'Use Direct WhatsApp generator to avoid cluttering your contacts list with temporary buyers/sellers.'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String tipText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tipText,
              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}