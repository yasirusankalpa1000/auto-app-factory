import 'package:flutter/material.dart';

void main() {
  runApp(const FloatAssistApp());
}

class FloatAssistApp extends StatelessWidget {
  const FloatAssistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatAssist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay States
  bool _isFloatingHUDEnabled = true;
  bool _isOverlayExpanded = false;
  Offset _floatingOffset = const Offset(20, 180);
  double _floatingOpacity = 0.95;

  // Permission States Simulation
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;

  // Notification Banner Feed Simulation
  String _lastNotificationMessage = "FloatAssist HUD is active on overlay layer.";
  bool _showNotificationBanner = true;

  // Clipboard Memory Stack
  final List<Map<String, String>> _clipboardStack = [
    {
      'id': '1',
      'title': 'Bank Details (Commercial)',
      'content': 'ACC: 8001928371 | Commercial Bank | Nugegoda',
      'category': 'Banking'
    },
    {
      'id': '2',
      'title': 'Delivery Address',
      'content': 'No. 45/2, Lotus Road, Colombo 03, Sri Lanka',
      'category': 'Personal'
    },
    {
      'id': '3',
      'title': 'Tax ID / NIC Number',
      'content': '199518204930 / 951820493V',
      'category': 'Work'
    },
    {
      'id': '4',
      'title': 'Promo Voucher Code',
      'content': 'SUPERDISCOUNT50',
      'category': 'Shopping'
    },
  ];

  String _pinnedSnippet = "ACC: 8001928371 | Commercial Bank | Nugegoda";
  String _searchQuery = "";

  // Controllers
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newContentController = TextEditingController();
  final TextEditingController _transformController = TextEditingController();
  String _transformedResult = "";

  // Quick Currency Convert
  final TextEditingController _amountController = TextEditingController(text: "100");
  double _convertedUsd = 0.31;
  double _convertedLkr = 310.0;

  void _triggerToast(String msg) {
    setState(() {
      _lastNotificationMessage = msg;
      _showNotificationBanner = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _pinToFloat(String content) {
    setState(() {
      _pinnedSnippet = content;
    });
    _triggerToast("Pinned to Floating Screen HUD!");
  }

  void _addClipboardItem() {
    if (_newTitleController.text.trim().isEmpty || _newContentController.text.trim().isEmpty) {
      _triggerToast("Please enter both title and snippet text!");
      return;
    }
    setState(() {
      _clipboardStack.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _newTitleController.text.trim(),
        'content': _newContentController.text.trim(),
        'category': 'Custom',
      });
      _newTitleController.clear();
      _newContentController.clear();
    });
    Navigator.of(context).pop();
    _triggerToast("Snippet added to dynamic stack!");
  }

  void _deleteSnippet(String id) {
    setState(() {
      _clipboardStack.removeWhere((item) => item['id'] == id);
    });
    _triggerToast("Snippet removed from stack.");
  }

  void _calculateCurrency() {
    double inputVal = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _convertedUsd = inputVal * 0.0032;
      _convertedLkr = inputVal * 310.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Nav Views
          SafeArea(
            child: Column(
              children: [
                // Top Custom Header
                _buildHeaderBar(),

                // System Floating Notification Simulation Bar
                if (_showNotificationBanner) _buildNotificationSimulationBanner(),

                // Main Dynamic Body View
                Expanded(
                  child: _buildSelectedTabContent(),
                ),
              ],
            ),
          ),

          // Floating Assistant HUD Bubble Overlay Simulation
          if (_isFloatingHUDEnabled)
            Positioned(
              left: _floatingOffset.dx,
              top: _floatingOffset.dy,
              child: _buildFloatingWidgetBubble(screenSize),
            ),

          // Expandable Floating HUD Window Modal Simulation
          if (_isFloatingHUDEnabled && _isOverlayExpanded)
            Positioned(
              left: 20,
              top: 100,
              right: 20,
              child: _buildExpandedFloatingWindow(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Float Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Clip Stack',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Smart Transformer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'HUD Config',
          ),
        ],
      ),
    );
  }

  // Header Bar
  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.blueGrey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'FloatAssist',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _isFloatingHUDEnabled ? 'Floating HUD Active' : 'HUD Disabled',
                  style: TextStyle(
                    color: _isFloatingHUDEnabled ? Colors.tealAccent : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: _isFloatingHUDEnabled,
            activeColor: Colors.teal,
            onChanged: (val) {
              setState(() {
                _isFloatingHUDEnabled = val;
                if (!val) _isOverlayExpanded = false;
              });
              _triggerToast(val ? "Floating Screen HUD Enabled" : "Floating HUD Disabled");
            },
          ),
        ],
      ),
    );
  }

  // Notification Banner Simulation
  Widget _buildNotificationSimulationBanner() {
    return Container(
      color: Colors.indigo.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _lastNotificationMessage,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showNotificationBanner = false;
              });
            },
            child: const Icon(Icons.close, color: Colors.white70, size: 16),
          ),
        ],
      ),
    );
  }

  // Content Router
  Widget _buildSelectedTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildClipboardStackTab();
      case 2:
        return _buildSmartTransformerTab();
      case 3:
        return _buildHUDConfigTab();
      default:
        return _buildDashboardTab();
    }
  }

  // TAB 0: Dashboard
  Widget _buildDashboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade800, const Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade300, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.amber, size: 22),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Pinned Screen Float Snippet',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.white70, size: 20),
                        onPressed: () {
                          _triggerToast("Copied pinned text to system clipboard!");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _pinnedSnippet,
                      style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.w600, fontSize: 14),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isOverlayExpanded = !_isOverlayExpanded;
                          });
                        },
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: Text(_isOverlayExpanded ? "Close Floating Window" : "Expand Floating HUD"),
                      ),
                      const Text(
                        'Drag bubble anywhere',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Floating Micro-Tool: Price / Unit Converter
            const Text(
              'Quick Floating Price & Unit Helper',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.shade700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Input Base Value (\$ / Unit)',
                            labelStyle: TextStyle(color: Colors.tealAccent),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) => _calculateCurrency(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                        onPressed: _calculateCurrency,
                        child: const Icon(Icons.calculate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal.shade700),
                        ),
                        child: Text(
                          'USD Standard: \$${_convertedUsd.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal.shade700),
                        ),
                        child: Text(
                          'LKR Estimate: Rs. ${_convertedLkr.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // System Overlay Permissions & Floating Toggles
            const Text(
              'System Overlay Permissions HUD',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.shade700),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.layers, color: Colors.teal),
                    title: const Text('Display Over Other Apps Permission', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Required for floating bubble & pinned clips', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    trailing: Switch(
                      value: _overlayPermissionGranted,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _overlayPermissionGranted = val;
                        });
                        _triggerToast(val ? "Overlay permission granted." : "Overlay permission revoked.");
                      },
                    ),
                  ),
                  const Divider(color: Colors.blueGrey, height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.amber),
                    title: const Text('Persistent Notification Service', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Keeps floating service background active', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    trailing: Switch(
                      value: _notificationPermissionGranted,
                      activeColor: Colors.teal,
                      onChanged: (val) {
                        setState(() {
                          _notificationPermissionGranted = val;
                        });
                        _triggerToast(val ? "Persistent service enabled." : "Persistent service disabled.");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: Clipboard Stack Tab
  Widget _buildClipboardStackTab() {
    List<Map<String, String>> filteredStack = _clipboardStack.where((item) {
      return item['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['content']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search snippets, codes, addresses...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.teal),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                  onPressed: () => _showAddSnippetDialog(),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredStack.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.history, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No snippets found in stack.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredStack.length,
                    itemBuilder: (context, index) {
                      final item = filteredStack[index];
                      final bool isPinned = _pinnedSnippet == item['content'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isPinned ? Colors.teal : Colors.blueGrey.shade800,
                            width: isPinned ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade900,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item['category'] ?? 'General',
                                    style: const TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                  onPressed: () => _deleteSnippet(item['id']!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              item['content'] ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.blueGrey),
                                  ),
                                  onPressed: () {
                                    _triggerToast("Copied to system clipboard!");
                                  },
                                  icon: const Icon(Icons.content_copy, size: 14),
                                  label: const Text('Copy'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isPinned ? Colors.amber.shade800 : Colors.teal,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => _pinToFloat(item['content']!),
                                  icon: Icon(isPinned ? Icons.check : Icons.push_pin, size: 14),
                                  label: Text(isPinned ? 'Pinned HUD' : 'Pin to Float'),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Smart Transformer
  Widget _buildSmartTransformerTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Context Text Transformer & Polisher',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Paste raw draft text, email snippets, or codes to polish, fix formatting, or summarize before floating.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _transformController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Paste raw text here...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  onPressed: () {
                    setState(() {
                      _transformedResult = _transformController.text.toUpperCase();
                    });
                  },
                  icon: const Icon(Icons.text_fields, size: 16),
                  label: const Text('UPPERCASE'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  onPressed: () {
                    List<String> lines = _transformController.text.split('\n');
                    setState(() {
                      _transformedResult = lines.map((l) => '• ${l.trim()}').join('\n');
                    });
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Bullet Points'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                  onPressed: () {
                    String clean = _transformController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                    setState(() {
                      _transformedResult = "Formal Draft: $clean\n[Verified & Polished by FloatAssist]";
                    });
                  },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Formal Polish'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_transformedResult.isNotEmpty) ...[
              const Text(
                'Transformed Output:',
                style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      _transformedResult,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _pinToFloat(_transformedResult),
                          icon: const Icon(Icons.push_pin, size: 14),
                          label: const Text('Pin Output to Floating HUD'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // TAB 3: HUD Config
  Widget _buildHUDConfigTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating HUD Appearance & Behavior',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.shade700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HUD Bubble Opacity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Slider(
                    value: _floatingOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _floatingOpacity = val;
                      });
                    },
                  ),
                  Text(
                    'Opacity: ${(_floatingOpacity * 100).toInt()}%',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.blueGrey),
                  const SizedBox(height: 12),
                  const Text('Reset Floating Bubble Position', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                    onPressed: () {
                      setState(() {
                        _floatingOffset = const Offset(20, 180);
                      });
                      _triggerToast("Floating Bubble position reset.");
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Position to Top-Left'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Overlay Bubble Widget
  Widget _buildFloatingWidgetBubble(Size screenSize) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          double newX = _floatingOffset.dx + details.delta.dx;
          double newY = _floatingOffset.dy + details.delta.dy;
          newX = newX.clamp(0.0, screenSize.width - 60.0);
          newY = newY.clamp(0.0, screenSize.height - 120.0);
          _floatingOffset = Offset(newX, newY);
        });
      },
      onTap: () {
        setState(() {
          _isOverlayExpanded = !_isOverlayExpanded;
        });
      },
      child: Opacity(
        opacity: _floatingOpacity,
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Colors.tealAccent, Colors.teal, Colors.indigo],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Center(
            child: Icon(Icons.bolt, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  // Expanded Floating HUD Window
  Widget _buildExpandedFloatingWindow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.layers, color: Colors.tealAccent, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'FloatAssist Quick HUD',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () {
                  setState(() {
                    _isOverlayExpanded = false;
                  });
                },
              )
            ],
          ),
          const Divider(color: Colors.blueGrey),
          const SizedBox(height: 6),
          const Text(
            'ACTIVE PINNED SNIPPET:',
            style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _pinnedSnippet,
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 13, fontWeight: FontWeight.w600),
                    softWrap: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy, color: Colors.white, size: 18),
                  onPressed: () {
                    _triggerToast("Copied pinned item to clipboard!");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentTabIndex = 1;
                    _isOverlayExpanded = false;
                  });
                },
                icon: const Icon(Icons.search, size: 14),
                label: const Text('Open Clip Stack'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.blueGrey)),
                onPressed: () {
                  setState(() {
                    _isOverlayExpanded = false;
                  });
                },
                child: const Text('Minimize HUD'),
              )
            ],
          )
        ],
      ),
    );
  }

  // Dialog to Add New Custom Snippet
  void _showAddSnippetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Snippet to Stack', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _newTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title (e.g., WiFi Password)',
                    labelStyle: TextStyle(color: Colors.tealAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newContentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Text Content / Number / Link',
                    labelStyle: TextStyle(color: Colors.tealAccent),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: _addClipboardItem,
              child: const Text('Save Snippet'),
            ),
          ],
        );
      },
    );
  }
}