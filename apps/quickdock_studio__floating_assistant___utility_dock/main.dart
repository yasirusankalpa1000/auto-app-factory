import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QuickDockApp());
}

class QuickDockApp extends StatelessWidget {
  const QuickDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickDock Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
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

class _MainDockScreenState extends State<MainDockScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  bool _overlayPermission = true;
  bool _notificationPermission = true;
  bool _isFloatingHudExpanded = false;
  String _activeNotificationToast = '';
  Offset _hudPosition = const Offset(20, 180);

  // Stats for Engagement
  int _cleanedLinksCount = 14;
  int _styledTextCount = 38;
  int _hoursSavedShopping = 12;

  // Controllers
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _textStylerController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _hourlyWageController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();

  // State Variables
  String _cleanedUrlResult = '';
  int _trackingParamsRemoved = 0;
  String _calculatedWorkHours = '';
  String _impulseAdvice = '';
  Color _impulseAdviceColor = Colors.teal;

  // Clipboard Snippets Data
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Home Address',
      'content': 'No. 45, Palm Grove Avenue, High Street District',
      'tag': 'Personal'
    },
    {
      'title': 'Instagram Hashtag Pack',
      'content': '#tech #flutter #productivity #tools #dailyhacks #design',
      'tag': 'Social'
    },
    {
      'title': 'Bank Account details',
      'content': 'IBAN: US98 4400 1234 5678 9012 34 | Swift: DOCKUS33',
      'tag': 'Finance'
    },
    {
      'title': 'Quick Away Reply',
      'content': 'Hey! In a deep focus session right now. Will reply shortly.',
      'tag': 'Work'
    },
  ];

  @override
  void initState() {
    super.initState();
    _urlController.text =
        'https://example.com/product?id=99&utm_source=facebook&fbclid=IwAR231498172948&ref=ad_campaign';
    _textStylerController.text = 'QuickDock Assistant';
    _itemPriceController.text = '149.99';
    _hourlyWageController.text = '18.50';
    _itemNameController.text = 'Wireless Gaming Headset';
    _calculateWorkHours();
  }

  void _showNotification(String message) {
    setState(() {
      _activeNotificationToast = message;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _activeNotificationToast == message) {
        setState(() {
          _activeNotificationToast = '';
        });
      }
    });
  }

  void _sanitizeUrl() {
    String input = _urlController.text.trim();
    if (input.isEmpty) return;

    try {
      Uri uri = Uri.parse(input);
      Map<String, String> originalParams = uri.queryParameters;
      Map<String, String> cleanParams = Map.from(originalParams);

      List<String> trackingKeys = [
        'utm_source',
        'utm_medium',
        'utm_campaign',
        'utm_term',
        'utm_content',
        'fbclid',
        'gclid',
        'ref',
        'mc_eid',
        'si'
      ];

      int removed = 0;
      for (String key in trackingKeys) {
        if (cleanParams.containsKey(key)) {
          cleanParams.remove(key);
          removed++;
        }
      }

      Uri cleanedUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: cleanParams.isEmpty ? null : cleanParams,
      );

      setState(() {
        _cleanedUrlResult = cleanedUri.toString();
        _trackingParamsRemoved = removed;
        _cleanedLinksCount++;
      });
      _showNotification(
          'Privacy Shield: Removed $removed tracking parameters!');
    } catch (e) {
      setState(() {
        _cleanedUrlResult = input;
        _trackingParamsRemoved = 0;
      });
    }
  }

  void _calculateWorkHours() {
    double price = double.tryParse(_itemPriceController.text) ?? 0;
    double wage = double.tryParse(_hourlyWageController.text) ?? 1;
    if (wage <= 0) wage = 1;

    double hours = price / wage;
    setState(() {
      _calculatedWorkHours = '${hours.toStringAsFixed(1)} Hours';
      if (hours > 20) {
        _impulseAdvice =
            'HIGH IMPULSE RISK: Costs over half a working week! Sleep on it for 48 hours.';
        _impulseAdviceColor = Colors.red;
      } else if (hours > 8) {
        _impulseAdvice =
            'MODERATE VALUE: Requires a full 8-hour workday to earn this amount.';
        _impulseAdviceColor = Colors.amber;
      } else {
        _impulseAdvice =
            'REASONABLE COST: Less than a full workday. Enjoy your purchase!';
        _impulseAdviceColor = Colors.teal;
      }
    });
  }

  String _applyUnicodeStyle(String text, String style) {
    if (text.isEmpty) return text;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      int code = text.codeUnitAt(i);
      if (style == 'bold' && code >= 65 && code <= 90) {
        buffer.write(String.fromCharCode(code + 119743));
      } else if (style == 'bold' && code >= 97 && code <= 122) {
        buffer.write(String.fromCharCode(code + 119737));
      } else if (style == 'monospace' && code >= 65 && code <= 90) {
        buffer.write(String.fromCharCode(code + 120367));
      } else if (style == 'monospace' && code >= 97 && code <= 122) {
        buffer.write(String.fromCharCode(code + 120361));
      } else if (style == 'bubble' && code >= 65 && code <= 90) {
        buffer.write(String.fromCharCode(code + 9333));
      } else if (style == 'bubble' && code >= 97 && code <= 122) {
        buffer.write(String.fromCharCode(code + 9327));
      } else {
        buffer.write(text[i]);
      }
    }
    return buffer.toString();
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
                _buildPermissionStatusBanner(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTabSelector(),
                          const SizedBox(height: 16),
                          if (_selectedTab == 0) _buildLinkSanitizerView(),
                          if (_selectedTab == 1) _buildTextStylerView(),
                          if (_selectedTab == 2) _buildImpulseShieldView(),
                          if (_selectedTab == 3) _buildSnippetVaultView(),
                          const SizedBox(height: 24),
                          _buildEngagementFooter(),
                          const SizedBox(height: 80), // Padding for floating HUD
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Top Floating Notification Toast
            if (_activeNotificationToast.isNotEmpty)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal.shade800,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _activeNotificationToast,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Interactive Floating Overlay HUD Dock
            Positioned(
              left: _hudPosition.dx,
              top: _hudPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _hudPosition += details.delta;
                  });
                },
                child: Column(
                  children: [
                    if (_isFloatingHudExpanded)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade900.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.deepPurpleAccent, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            _buildHudIconButton(Icons.link, 'Clean Link', 0),
                            _buildHudIconButton(
                                Icons.text_fields, 'Text Style', 1),
                            _buildHudIconButton(
                                Icons.calculate, 'Impulse Shield', 2),
                            _buildHudIconButton(
                                Icons.bookmark, 'Snippet Bank', 3),
                          ],
                        ),
                      ),
                    FloatingActionButton.extended(
                      heroTag: 'hud_btn',
                      backgroundColor: Colors.deepPurple,
                      onPressed: () {
                        setState(() {
                          _isFloatingHudExpanded = !_isFloatingHudExpanded;
                        });
                      },
                      icon: Icon(
                        _isFloatingHudExpanded
                            ? Icons.close
                            : Icons.widgets,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'QuickDock HUD',
                        style: TextStyle(
                            color: Colors.white, FontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHudIconButton(IconData icon, String label, int tabIndex) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tabIndex;
          _isFloatingHudExpanded = false;
        });
        _showNotification('Switched to $label mode');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.tealAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161522),
        border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.widgets, color: Colors.tealAccent),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QuickDock Studio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Smart Floating Utility Dock',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.stars, color: Colors.amber),
            onPressed: () {
              _showNotification('Pro Floating Engine: Active & Ready');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStatusBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1D2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade900),
      ),
      child: Row(
        children: [
          const Icon(Icons.security, color: Colors.tealAccent, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Floating Dock Overlay Permissions',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                selected: _overlayPermission,
                label: const Text('Display Above Apps',
                    style: TextStyle(fontSize: 11)),
                onSelected: (val) {
                  setState(() => _overlayPermission = val);
                  _showNotification(
                      val ? 'Overlay Activated' : 'Overlay Disabled');
                },
                selectedColor: Colors.deepPurple,
              ),
              FilterChip(
                selected: _notificationPermission,
                label: const Text('Floating Banner',
                    style: TextStyle(fontSize: 11)),
                onSelected: (val) {
                  setState(() => _notificationPermission = val);
                },
                selectedColor: Colors.teal.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabChip(0, 'Link Cleaner', Icons.link),
          _buildTabChip(1, 'Font Styler', Icons.text_fields),
          _buildTabChip(2, 'Impulse Shield', Icons.calculate),
          _buildTabChip(3, 'Snippet Vault', Icons.bookmark),
        ],
      ),
    );
  }

  Widget _buildTabChip(int index, String label, IconData icon) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : const Color(0xFF1E1D2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.tealAccent : Colors.grey.shade800,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? Colors.tealAccent : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: LINK SANITIZER ---
  Widget _buildLinkSanitizerView() {
    return Card(
      color: const Color(0xFF1E1D2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.privacy_tip, color: Colors.tealAccent),
                SizedBox(width: 8),
                Text(
                  'Privacy URL Cleaner & Tracker Stripper',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Strips away utm_source, fbclid, affiliate tags, and tracking tokens from shared links.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Paste Link to Clean',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF161522),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _sanitizeUrl,
                icon: const Icon(Icons.bolt, color: Colors.white),
                label: const Text('Strip Trackers & Sanitize Link',
                    style: TextStyle(
                        color: Colors.white, FontWeight: FontWeight.bold)),
              ),
            ),
            if (_cleanedUrlResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Cleaned Link ($_trackingParamsRemoved Trackers Stripped):',
                    style: const TextStyle(
                        color: Colors.tealAccent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF161522),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _cleanedUrlResult,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _cleanedUrlResult));
                        _showNotification('Cleaned link copied to clipboard!');
                      },
                      icon: const Icon(Icons.content_copy, size: 16),
                      label: const Text('Copy Clean URL'),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  // --- TAB 2: UNICODE FONT STYLER ---
  Widget _buildTextStylerView() {
    return Card(
      color: const Color(0xFF1E1D2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.text_fields, color: Colors.tealAccent),
                SizedBox(width: 8),
                Text(
                  'Social Text Font Styler',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Instantly format text for Instagram bios, WhatsApp messages, and TikTok captions.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textStylerController,
              onChanged: (val) => setState(() {
                _styledTextCount++;
              }),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Enter Text to Style',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF161522),
              ),
            ),
            const SizedBox(height: 16),
            _buildFontCopyRow(
                'Bold Format',
                _applyUnicodeStyle(_textStylerController.text, 'bold')),
            _buildFontCopyRow(
                'Monospace Format',
                _applyUnicodeStyle(_textStylerController.text, 'monospace')),
            _buildFontCopyRow(
                'Bubble Format',
                _applyUnicodeStyle(_textStylerController.text, 'bubble')),
            _buildFontCopyRow('UPPERCASE CLEAN',
                _textStylerController.text.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget _buildFontCopyRow(String label, String formattedText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF161522),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  formattedText.isEmpty ? 'Sample Text' : formattedText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.content_copy, color: Colors.tealAccent, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formattedText));
              _showNotification('Copied "$label" to clipboard!');
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 3: IMPULSE SHOPPING SHIELD ---
  Widget _buildImpulseShieldView() {
    return Card(
      color: const Color(0xFF1E1D2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calculate, color: Colors.tealAccent),
                SizedBox(width: 8),
                Text(
                  'Impulse Purchase Work-Hour Shield',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Before buying online, calculate how many hard work hours this item costs you.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _itemNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Item Name',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF161522),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _calculateWorkHours(),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Price (\$)',
                      labelStyle: TextStyle(color: Colors.tealAccent),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFF161522),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hourlyWageController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _calculateWorkHours(),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Hourly Wage (\$)',
                      labelStyle: TextStyle(color: Colors.tealAccent),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFF161522),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161522),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _impulseAdviceColor),
              ),
              child: Column(
                children: [
                  const Text('Real Cost in Work Labor:',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    _calculatedWorkHours,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _impulseAdviceColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _impulseAdvice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: SNIPPET VAULT ---
  Widget _buildSnippetVaultView() {
    return Card(
      color: const Color(0xFF1E1D2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bookmark, color: Colors.tealAccent),
                    SizedBox(width: 8),
                    Text(
                      'Quick Clipboard Bank',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.tealAccent),
                  onPressed: () {
                    _showAddSnippetDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'One-tap copy for your addresses, bank accounts, and hashtags.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final item = _snippets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161522),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade800,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item['tag'] ?? 'General',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['content'] ?? '',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy,
                            color: Colors.tealAccent),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: item['content'] ?? ''));
                          _showNotification(
                              'Copied "${item['title']}" to clipboard!');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSnippetDialog() {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController contentCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1D2B),
        title: const Text('Add Quick Snippet',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Snippet Title',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Text Content',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            backgroundColor: Colors.deepPurple,
            child: const Text('Save Snippet',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _snippets.add({
                    'title': titleCtrl.text,
                    'content': contentCtrl.text,
                    'tag': 'Custom'
                  });
                });
                Navigator.pop(context);
                _showNotification('New snippet saved successfully!');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161522),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Dock Productivity Insights',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              Icon(Icons.bolt, color: Colors.amber, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Clean Links', '$_cleanedLinksCount'),
              _buildStatItem('Texts Styled', '$_styledTextCount'),
              _buildStatItem('Hours Saved', '$_hoursSavedShopping h'),
            ],
          ),
          const SizedBox(height: 12),
          // Simulated AdMob Banner Slot
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.shade900),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on, color: Colors.amber, size: 14),
                SizedBox(width: 6),
                Text(
                  'AdMob Placement: QuickDock Banner Active',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}