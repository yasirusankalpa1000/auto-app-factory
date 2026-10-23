import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayLensApp());
}

class OverlayLensApp extends StatelessWidget {
  const OverlayLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayLens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFA8B5DB),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String title;
  final String originalText;
  final String cleanedText;
  final String category;
  final DateTime timestamp;
  bool isFavorite;

  SnippetItem({
    required this.id,
    required this.title,
    required this.originalText,
    required this.cleanedText,
    required this.category,
    required this.timestamp,
    this.isFavorite = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global state metrics
  int _trackersStripped = 142;
  int _piiLeaksPrevented = 89;
  int _snippetsCleaned = 67;

  // Floating HUD simulator state
  bool _isOverlayEnabled = true;
  bool _isNotificationAccessGiven = true;
  bool _isClipboardListenerActive = true;
  Offset _floatingPos = const Offset(20, 200);
  bool _isFloatingMenuExpanded = false;

  // Snippets library state
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Cleaned Promo Link',
      originalText: 'https://shop.example.com/product/99?utm_source=facebook&utm_medium=cpc&fbclid=IwAR23123',
      cleanedText: 'https://shop.example.com/product/99',
      category: 'Link Stripper',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isFavorite: true,
    ),
    SnippetItem(
      id: '2',
      title: 'Redacted Customer Invoice',
      originalText: 'Client: John Doe, Email: john.doe@email.com, Phone: +1-555-0199, Amount: \$450.00',
      cleanedText: 'Client: John Doe, Email: j***@email.com, Phone: +1-555-****, Amount: \$450.00',
      category: 'Privacy Shield',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isFavorite: false,
    ),
  ];

  void _addSnippet(String title, String original, String cleaned, String category) {
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          originalText: original,
          cleanedText: cleaned,
          category: category,
          timestamp: DateTime.now(),
        ),
      );
      _snippetsCleaned++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildStudioTab(),
      _buildLinkPrivacyTab(),
      _buildTransformerTab(),
      _buildPermissionsOverlayTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.layers, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'OverlayLens HUD',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.indigo : Colors.grey,
            ),
            tooltip: 'Toggle Overlay HUD Preview',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isOverlayEnabled
                        ? 'Floating HUD Overlay Enabled!'
                        : 'Floating HUD Overlay Hidden',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
          if (_isOverlayEnabled) _buildDraggableFloatingHUD(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Privacy & Links',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            selectedIcon: Icon(Icons.text_fields),
            label: 'Transform',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_system_daydream_outlined),
            selectedIcon: Icon(Icons.settings_system_daydream),
            label: 'HUD Dock',
          ),
        ],
      ),
    );
  }

  // --- FLOATING HUD OVERLAY SIMULATION ---
  Widget _buildDraggableFloatingHUD() {
    return Positioned(
      left: _floatingPos.dx,
      top: _floatingPos.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _floatingPos += details.delta;
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(28),
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900.withOpacity(0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.indigoAccent, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                    const SizedBox(width: 6),
                    const Text(
                      'Lens Dock',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isFloatingMenuExpanded = !_isFloatingMenuExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFloatingMenuExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isFloatingMenuExpanded) ...[
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white70, height: 1),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      _buildFloatingActionButton(
                        icon: Icons.cleaning_services,
                        label: 'Clean Link',
                        onTap: () {
                          _showQuickHUDDialog('Quick Link Stripped',
                              'Cleaned clipboard link and removed 3 tracker tags.');
                          setState(() {
                            _trackersStripped += 3;
                          });
                        },
                      ),
                      _buildFloatingActionButton(
                        icon: Icons.security,
                        label: 'Mask PII',
                        onTap: () {
                          _showQuickHUDDialog('Privacy Mask Applied',
                              'Redacted phone numbers and emails in clipboard snippet.');
                          setState(() {
                            _piiLeaksPrevented += 2;
                          });
                        },
                      ),
                      _buildFloatingActionButton(
                        icon: Icons.copy,
                        label: 'Quick Snippet',
                        onTap: () {
                          _addSnippet(
                            'HUD Quick Clip',
                            'Text copied via Floating Overlay Assistant',
                            'Text copied via Floating Overlay Assistant',
                            'HUD Quick',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved quick snippet to library!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.tealAccent, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickHUDDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: STUDIO OVERVIEW ---
  Widget _buildStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Cards Header
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Trackers Removed',
                  '$_trackersStripped',
                  Icons.link_off,
                  Colors.teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  'PII Shields',
                  '$_piiLeaksPrevented',
                  Icons.shield,
                  Colors.indigo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  'Clean Clips',
                  '$_snippetsCleaned',
                  Icons.cleaning_services,
                  Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Active Mode Switch Banner
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flash_on, color: Colors.indigo),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Live Floating Assistant Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Switch(
                        value: _isOverlayEnabled,
                        onChanged: (val) {
                          setState(() {
                            _isOverlayEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isOverlayEnabled
                        ? 'HUD Overlay is active! Drag the lens widget anywhere on your screen for instant auto-cleaning.'
                        : 'Overlay HUD is off. Turn on to enjoy instant one-tap tracking link cleaning & text redaction.',
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Recent Activity Snippets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Cleaned Snippets',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                onPressed: () {
                  _showNewSnippetDialog();
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Custom'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_snippets.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: const [
                    Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No snippets saved yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _snippets.length,
              itemBuilder: (context, index) {
                final item = _snippets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                item.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: item.isFavorite
                                    ? Colors.amber
                                    : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  item.isFavorite = !item.isFavorite;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red, size: 20),
                              onPressed: () {
                                setState(() {
                                  _snippets.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Cleaned Result:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 4, bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            item.cleanedText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                            softWrap: true,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Cleaned text copied to clipboard!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy, size: 14),
                              label: const Text('Copy',
                                  style: TextStyle(fontSize: 12)),
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

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: LINK & PRIVACY SCRUBBER ---
  Widget _buildLinkPrivacyTab() {
    return const LinkPrivacyStudioWidget();
  }

  // --- TAB 3: TEXT TRANSFORMER & EXTRACTOR ---
  Widget _buildTransformerTab() {
    return const TextTransformerWidget();
  }

  // --- TAB 4: PERMISSIONS & HUD DOCK SETUP ---
  Widget _buildPermissionsOverlayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Assistant & System Permissions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure background floating dock permissions and assistant parameters.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Permission Toggles Simulation
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text(
                      'Allows floating lens HUD button to stay visible over social & messaging apps.'),
                  value: _isOverlayEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Floating Notifications Access'),
                  subtitle: const Text(
                      'Shows dynamic heads-up notification cards when new tracking links are detected.'),
                  value: _isNotificationAccessGiven,
                  onChanged: (val) {
                    setState(() {
                      _isNotificationAccessGiven = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Auto-Scrub Clipboard Listener'),
                  subtitle: const Text(
                      'Automatically cleans tracking parameters when you tap the floating assistant dock.'),
                  value: _isClipboardListenerActive,
                  onChanged: (val) {
                    setState(() {
                      _isClipboardListenerActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Overlay Appearance & Dock Tuning',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('HUD Dock Visibility'),
                      Chip(
                        label: Text(_isOverlayEnabled ? 'Active' : 'Disabled'),
                        backgroundColor: _isOverlayEnabled
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _floatingPos = const Offset(20, 150);
                        _isOverlayEnabled = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reset Floating HUD to default position!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Floating Dock Position'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
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
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                _addSnippet(
                  titleController.text,
                  contentController.text,
                  contentController.text,
                  'Custom',
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// --- LINK & PRIVACY STUDIO WIDGET ---
class LinkPrivacyStudioWidget extends StatefulWidget {
  const LinkPrivacyStudioWidget({super.key});

  @override
  State<LinkPrivacyStudioWidget> createState() =>
      _LinkPrivacyStudioWidgetState();
}

class _LinkPrivacyStudioWidgetState extends State<LinkPrivacyStudioWidget> {
  final TextEditingController _linkController = TextEditingController(
    text:
        'https://example.com/item/4820?utm_source=newsletter&utm_medium=email&fbclid=IwAR3XyZ99&affiliate=partner88',
  );
  String _cleanedLink = '';
  int _removedCount = 0;

  final TextEditingController _piiController = TextEditingController(
    text:
        'Contact Alice at alice.smith@domain.com or call +1-800-555-0199 for invoice details of \$1,250.00.',
  );
  String _maskedPII = '';
  bool _maskEmails = true;
  bool _maskPhones = true;
  bool _maskCurrencies = false;

  @override
  void initState() {
    super.initState();
    _cleanLinkNow();
    _maskPIINow();
  }

  void _cleanLinkNow() {
    final raw = _linkController.text;
    try {
      final uri = Uri.parse(raw);
      if (uri.hasQuery) {
        final queryParams = Map<String, String>.from(uri.queryParameters);
        final keysToRemove = queryParams.keys.where((key) {
          final k = key.toLowerCase();
          return k.startsWith('utm_') ||
              k.contains('fbclid') ||
              k.contains('igshid') ||
              k.contains('affiliate') ||
              k.contains('gclid');
        }).toList();

        for (var k in keysToRemove) {
          queryParams.remove(k);
        }

        final cleanUri = uri.replace(queryParameters: queryParams.isEmpty ? null : queryParams);
        setState(() {
          _cleanedLink = cleanUri.toString();
          _removedCount = keysToRemove.length;
        });
      } else {
        setState(() {
          _cleanedLink = raw;
          _removedCount = 0;
        });
      }
    } catch (_) {
      setState(() {
        _cleanedLink = raw;
        _removedCount = 0;
      });
    }
  }

  void _maskPIINow() {
    String text = _piiController.text;

    if (_maskEmails) {
      final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
      text = text.replaceAllMapped(emailRegex, (match) {
        final email = match.group(0)!;
        final parts = email.split('@');
        if (parts[0].length > 2) {
          return '${parts[0].substring(0, 2)}***@${parts[1]}';
        }
        return '***@${parts[1]}';
      });
    }

    if (_maskPhones) {
      final phoneRegex = RegExp(r'\+?\d[\d\s\-\(\)]{7,}\d');
      text = text.replaceAllMapped(phoneRegex, (match) {
        return '[PHONE REDACTED]';
      });
    }

    if (_maskCurrencies) {
      final currencyRegex = RegExp(r'\$\d+(?:,\d{3})*(?:\.\d{2})?');
      text = text.replaceAllMapped(currencyRegex, (match) {
        return '[$HIDDEN]';
      });
    }

    setState(() {
      _maskedPII = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Tracking Link Stripper
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.link_off, color: Colors.teal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tracking Link Stripper',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _linkController,
                    maxLines: 2,
                    onChanged: (_) => _cleanLinkNow(),
                    decoration: const InputDecoration(
                      labelText: 'Paste Raw URL',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cleaned URL Result:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                      Chip(
                        avatar: const Icon(Icons.check, size: 14),
                        label: Text('Removed $_removedCount Tracker(s)'),
                        backgroundColor: Colors.teal.shade50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Text(
                      _cleanedLink,
                      style: const TextStyle(
                          fontSize: 12, fontFamily: 'monospace'),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cleaned link copied!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Clean URL'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: Privacy (PII) Redactor Shield
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.security, color: Colors.indigo),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Privacy (PII) Masker Shield',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _piiController,
                    maxLines: 3,
                    onChanged: (_) => _maskPIINow(),
                    decoration: const InputDecoration(
                      labelText: 'Text with Personal Data',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('Mask Emails'),
                        selected: _maskEmails,
                        onSelected: (val) {
                          setState(() {
                            _maskEmails = val;
                          });
                          _maskPIINow();
                        },
                      ),
                      FilterChip(
                        label: const Text('Mask Phone Numbers'),
                        selected: _maskPhones,
                        onSelected: (val) {
                          setState(() {
                            _maskPhones = val;
                          });
                          _maskPIINow();
                        },
                      ),
                      FilterChip(
                        label: const Text('Mask Amounts (\$)'),
                        selected: _maskCurrencies,
                        onSelected: (val) {
                          setState(() {
                            _maskCurrencies = val;
                          });
                          _maskPIINow();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Protected Safe Output:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.indigo.shade200),
                    ),
                    child: Text(
                      _maskedPII,
                      style: const TextStyle(fontSize: 13),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Redacted snippet copied safely!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shield, size: 16),
                      label: const Text('Copy Redacted Text'),
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
}

// --- TEXT TRANSFORMER WIDGET ---
class TextTransformerWidget extends StatefulWidget {
  const TextTransformerWidget({super.key});

  @override
  State<TextTransformerWidget> createState() => _TextTransformerWidgetState();
}

class _TextTransformerWidgetState extends State<TextTransformerWidget> {
  final TextEditingController _inputController = TextEditingController(
    text:
        'Hello World! Visit https://flutter.dev or email info@test.org. Total amount is \$199.99.',
  );

  String _output = '';
  String _activeMode = 'UPPERCASE';

  @override
  void initState() {
    super.initState();
    _transformText('UPPERCASE');
  }

  void _transformText(String mode) {
    setState(() {
      _activeMode = mode;
      final text = _inputController.text;

      switch (mode) {
        case 'UPPERCASE':
          _output = text.toUpperCase();
          break;
        case 'lowercase':
          _output = text.toLowerCase();
          break;
        case 'Title Case':
          _output = text.split(' ').map((word) {
            if (word.isEmpty) return '';
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }).join(' ');
          break;
        case 'Extract URLs':
          final urlRegex = RegExp(r'https?://[^\s]+');
          final matches = urlRegex.allMatches(text);
          final urls = matches.map((m) => m.group(0)).toList();
          final sb = StringBuffer();
          sb.writeln('Extracted (${urls.length}) Links:');
          for (var u in urls) {
            sb.writeln('• $u');
          }
          _output = sb.toString();
          break;
        case 'Extract Prices':
          final priceRegex = RegExp(r'\$\d+(?:\.\d{2})?');
          final matches = priceRegex.allMatches(text);
          final prices = matches.map((m) => m.group(0)).toList();
          final sb = StringBuffer();
          sb.writeln('Found (${prices.length}) Price Items:');
          for (var p in prices) {
            sb.writeln('• $p');
          }
          _output = sb.toString();
          break;
        case 'Clean Spacing':
          _output = text.replaceAll(RegExp(r'\s+'), ' ').trim();
          break;
        default:
          _output = text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Multi-Mode Text Workbench',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _inputController,
                    maxLines: 4,
                    onChanged: (_) => _transformText(_activeMode),
                    decoration: const InputDecoration(
                      labelText: 'Input Snippet',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quick Transform Actions:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      'UPPERCASE',
                      'lowercase',
                      'Title Case',
                      'Extract URLs',
                      'Extract Prices',
                      'Clean Spacing',
                    ].map((mode) {
                      final isSelected = _activeMode == mode;
                      return ChoiceChip(
                        label: Text(mode),
                        selected: isSelected,
                        selectedColor: Colors.indigo.shade100,
                        onSelected: (sel) {
                          if (sel) _transformText(mode);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transformed Result:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${_output.length} characters',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Result copied to clipboard!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Output'),
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
}