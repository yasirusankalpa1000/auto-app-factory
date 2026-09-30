import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ClipDirectApp());
}

class ClipDirectApp extends StatelessWidget {
  const ClipDirectApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'ClipDirect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        cardTheme: CardTheme(
          color: const Color(0xFF1F1D2B),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class VaultItem {
  final String id;
  final String title;
  final String content;
  final String category;

  VaultItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;
  String _activeClipboard = "Tap refresh to check active clipboard...";
  String _detectedType = "Unknown";
  bool _isFloatingAssistEnabled = true;
  bool _isNotificationBarActive = true;

  // Floating assist bubble position
  Offset _bubblePosition = const Offset(20, 180);

  // Default Vault Clips
  final List<VaultItem> _vaultList = [
    VaultItem(
      id: '1',
      title: 'Bank Transfer Info',
      content: 'Sampath Bank\nAcc: 102938475612\nBranch: Colombo Central',
      category: 'Finance',
    ),
    VaultItem(
      id: '2',
      title: 'Home Delivery Address',
      content: 'No 45, Main Street, Grand Pass, Colombo 14.',
      category: 'Personal',
    ),
    VaultItem(
      id: '3',
      title: 'Customer Reply Template',
      content: 'Thank you for contacting us! Your order will be dispatched within 24 hours.',
      category: 'Business',
    ),
  ];

  // Controllers for utility tools
  final TextEditingController _phoneInputController = TextEditingController();
  final TextEditingController _urlInputController = TextEditingController();
  final TextEditingController _textCleanController = TextEditingController();
  final TextEditingController _vaultTitleController = TextEditingController();
  final TextEditingController _vaultContentController = TextEditingController();

  String _cleanUrlResult = '';
  String _cleanedTextResult = '';

  @override
  void initState() {
    super.initState();
    _checkClipboard();
  }

  Future<void> _checkClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null && data.text!.isNotEmpty) {
      final text = data.text!.trim();
      setState(() {
        _activeClipboard = text;
        _detectContentType(text);
      });
    }
  }

  void _detectContentType(String text) {
    final phoneRegex = RegExp(r'^(?:\+?94|0)?7[0-9]{8}$');
    final urlRegex = RegExp(r'^(http|https)://');

    if (phoneRegex.hasMatch(text.replaceAll(RegExp(r'\s+'), ''))) {
      _detectedType = "Phone Number";
    } else if (urlRegex.hasMatch(text)) {
      _detectedType = "Web URL";
    } else if (text.contains('@') && text.contains('.')) {
      _detectedType = "Email Address";
    } else {
      _detectedType = "General Text";
    }
  }

  void _copyToClipboard(String content, String message) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sanitizeUrl() {
    final raw = _urlInputController.text.trim();
    if (raw.isEmpty) return;

    try {
      final uri = Uri.parse(raw);
      // Strip utm parameters
      final cleanUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        port: uri.port,
      );
      setState(() {
        _cleanUrlResult = cleanUri.toString();
      });
    } catch (_) {
      setState(() {
        _cleanUrlResult = raw.split('?').first;
      });
    }
  }

  void _cleanTextFormat() {
    String text = _textCleanController.text;
    if (text.isEmpty) return;

    // Remove emojis and excess whitespace
    String sanitized = text.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ').trim();

    setState(() {
      _cleanedTextResult = sanitized;
    });
  }

  void _addNewVaultClip() {
    final title = _vaultTitleController.text.trim();
    final content = _vaultContentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      setState(() {
        _vaultList.add(VaultItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: 'Custom',
        ));
      });
      _vaultTitleController.clear();
      _vaultContentController.clear();
      Navigator.pop(context);
      _copyToClipboard(content, 'New clip saved to Vault!');
    }
  }

  void _showAddClipDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1D2B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Save Quick Vault Clip',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _vaultTitleController,
                decoration: const InputDecoration(
                  labelText: 'Title (e.g., Bank Account, NIC)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _vaultContentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Content to copy',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _addNewVaultClip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Save to Quick Access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Custom Header Bar
                _buildTopAppBar(),

                // Persistent Simulated Dynamic Notification Status Banner
                if (_isNotificationBarActive) _buildNotificationBar(),

                // Active Tab View Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildCurrentTabContent(),
                  ),
                ),
              ],
            ),
          ),

          // Floating System Assist Widget Overlay Simulator
          if (_isFloatingAssistEnabled) _buildDraggableFloatingAssist(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        backgroundColor: const Color(0xFF161522),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Live Clip'),
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Assist Bar'),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161522),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.content_copy, color: Colors.deepPurpleAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ClipDirect',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'Smart Action & Floating Utility Hub',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.tealAccent),
            onPressed: () {
              _checkClipboard();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Clipboard synchronized!'), duration: Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBar() {
    return Container(
      width: double.infinity,
      color: Colors.indigo.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Active Bar: Detected [$_detectedType] in system tray',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () => setState(() => _isNotificationBarActive = false),
            child: const Icon(Icons.close, color: Colors.grey, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildLiveClipTab();
      case 1:
        return _buildVaultTab();
      case 2:
        return _buildToolsTab();
      case 3:
        return _buildAssistSettingsTab();
      default:
        return _buildLiveClipTab();
    }
  }

  // TAB 1: Live Clipboard & Auto Detector Actions
  Widget _buildLiveClipTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Clipboard Card
        Card(
          color: const Color(0xFF1F1D2B),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'TYPE: $_detectedType',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                      ),
                    ),
                    const Icon(Icons.bolt, color: Colors.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'CURRENT CLIPBOARD CONTENT:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Text(
                    _activeClipboard,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(_activeClipboard, 'Copied to clipboard!'),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Re-Copy'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _textCleanController.text = _activeClipboard;
                          _phoneInputController.text = _activeClipboard;
                          _urlInputController.text = _activeClipboard;
                          setState(() => _selectedTabIndex = 2);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                        label: const Text('Process Text', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'SMART 1-TAP CONTEXT ACTIONS',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
        ),
        const SizedBox(height: 10),

        // Contextual Quick Actions based on text type
        if (_detectedType == "Phone Number" || _phoneInputController.text.isNotEmpty)
          _buildQuickActionTile(
            title: 'Direct WhatsApp Launcher',
            subtitle: 'Chat directly without saving contact to address book',
            icon: Icons.chat,
            color: Colors.green,
            actionText: 'Open Direct Chat Link',
            onTap: () {
              final cleanPhone = _activeClipboard.replaceAll(RegExp(r'[^0-9+]'), '');
              final url = 'https://wa.me/$cleanPhone';
              _copyToClipboard(url, 'Direct WhatsApp link generated and copied!');
            },
          ),

        _buildQuickActionTile(
          title: 'Strip Tracking Parameters',
          subtitle: 'Clean ugly tracking clutter from copied links',
          icon: Icons.cleaning_services,
          color: Colors.orange,
          actionText: 'Sanitize URL',
          onTap: () {
            _urlInputController.text = _activeClipboard;
            _sanitizeUrl();
            setState(() => _selectedTabIndex = 2);
          },
        ),

        _buildQuickActionTile(
          title: 'Save to Vault Clips',
          subtitle: 'Store bank accounts, addresses or replies for quick floating access',
          icon: Icons.star,
          color: Colors.blue,
          actionText: 'Save to Vault',
          onTap: () {
            _vaultContentController.text = _activeClipboard;
            _showAddClipDialog();
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              child: Text(actionText, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Quick Vault & Pinboard
  Widget _buildVaultTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Vault Clips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Tap to copy instantly anywhere', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _showAddClipDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text('Add Clip', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _vaultList.length,
          itemBuilder: (context, index) {
            final item = _vaultList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.tealAccent)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(item.category, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.content,
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            setState(() {
                              _vaultList.removeAt(index);
                            });
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _copyToClipboard(item.content, '${item.title} copied!'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                          icon: const Icon(Icons.copy, size: 14, color: Colors.white),
                          label: const Text('1-Tap Copy', style: TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // TAB 3: Instant Micro-Tools
  Widget _buildToolsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Instant Micro-Tools Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 14),

        // Tool 1: Direct WhatsApp Chat
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.phone_android, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Direct WhatsApp Launcher', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneInputController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number (e.g. 0771234567)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final raw = _phoneInputController.text.trim();
                      if (raw.isNotEmpty) {
                        final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                        final waUrl = 'https://wa.me/$clean';
                        _copyToClipboard(waUrl, 'Direct WhatsApp link generated & copied!');
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Generate Direct Chat Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Tool 2: Link Sanitizer
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.link_off, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('URL Sanitizer & Tracking Remover', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _urlInputController,
                  decoration: const InputDecoration(
                    hintText: 'Paste link with tracking parameters',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _sanitizeUrl,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    icon: const Icon(Icons.cleaning_services, color: Colors.white),
                    label: const Text('Strip Tracking Parameters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (_cleanUrlResult.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                    child: SelectableText(_cleanUrlResult, style: const TextStyle(color: Colors.tealAccent, fontSize: 12)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _copyToClipboard(_cleanUrlResult, 'Clean URL copied!'),
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text('Copy Clean Link'),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Tool 3: Text Formatter & Sanitizer
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.spellcheck, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Text Cleaner & Emoji Stripper', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textCleanController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Paste messy text to clean',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _cleanTextFormat,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    icon: const Icon(Icons.auto_awesome, color: Colors.white),
                    label: const Text('Clean & Format Text', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (_cleanedTextResult.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                    child: Text(_cleanedTextResult, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _copyToClipboard(_cleanedTextResult, 'Clean text copied!'),
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text('Copy Cleaned Text'),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TAB 4: Assist Settings & Permissions Simulation
  Widget _buildAssistSettingsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('System Overlay & Widget Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 14),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  value: _isFloatingAssistEnabled,
                  activeColor: Colors.deepPurpleAccent,
                  title: const Text('Floating Assist Bubble Overlay', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: const Text('Simulates dynamic overlay bubble that stays visible over other apps'),
                  onChanged: (val) => setState(() => _isFloatingAssistEnabled = val),
                ),
                const Divider(),
                SwitchListTile(
                  value: _isNotificationBarActive,
                  activeColor: Colors.deepPurpleAccent,
                  title: const Text('Persistent Top Notification Tray Widget', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  subtitle: const Text('Shows live clipboard status in system notification bar'),
                  onChanged: (val) => setState(() => _isNotificationBarActive = val),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Card(
          color: Colors.blueGrey.withOpacity(0.2),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.tealAccent),
                    SizedBox(width: 8),
                    Text('Why ClipDirect is Essential', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'ClipDirect reduces daily copy-paste actions from 8 steps down to 1 single tap. By combining smart text analysis, link sanitizing, direct WhatsApp launching, and rapid template access, you save over 15 minutes of repetitive daily friction.',
                  style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Floating Assist Overlay Widget Simulation
  Widget _buildDraggableFloatingAssist() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          color: Colors.deepPurple,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              _checkClipboard();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Floating Assist: Checked Clipboard -> $_detectedType'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt, color: Colors.amber, size: 22),
                  SizedBox(width: 6),
                  Text('ClipAssist', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}