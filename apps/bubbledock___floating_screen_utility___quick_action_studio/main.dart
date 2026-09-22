import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDockApp());
}

class BubbleDockApp extends StatelessWidget {
  const BubbleDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: CardTheme(
          color: const Color(0xFF1E293B),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainStudioScreen(),
    );
  }
}

class MainStudioScreen extends StatefulWidget {
  const MainStudioScreen({super.key});

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  int _selectedTabIndex = 0;

  // Global App States
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _isBubbleDockActive = true;
  double _bubbleOpacity = 0.85;
  String _bubblePosition = 'Right Side';

  // Floating Clips State
  final List<String> _pinnedClips = [
    'Wi-Fi Pass: SecureHome2025!',
    'Delivery Note: Leave package near front door',
    'Discount Code: SAVE20NOW',
  ];
  final TextEditingController _clipInputController = TextEditingController();

  // Text Transformer State
  final TextEditingController _textTransformerController = TextEditingController(
    text: 'Welcome to BubbleDock! Copy any text to reformat, extract tags, or convert casing instantly.',
  );
  String _transformedResult = '';

  // Micro Calculator State
  double _originalPrice = 120.0;
  double _discountPercent = 15.0;
  double _taxPercent = 8.0;

  @override
  void initState() {
    super.initState();
    _transformText('bullet');
  }

  @override
  void dispose() {
    _clipInputController.dispose();
    _textTransformerController.dispose();
    super.dispose();
  }

  void _transformText(String mode) {
    final raw = _textTransformerController.text;
    setState(() {
      if (mode == 'bullet') {
        _transformedResult = raw
            .split('.')
            .where((s) => s.trim().isNotEmpty)
            .map((s) => '• ${s.trim()}')
            .join('\n');
      } else if (mode == 'hashtag') {
        _transformedResult = raw
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .map((w) => '#${w.replaceAll(RegExp(r'[^\w]'), '')}')
            .join(' ');
      } else if (mode == 'clean') {
        _transformedResult = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
      } else if (mode == 'uppercase') {
        _transformedResult = raw.toUpperCase();
      } else if (mode == 'lowercase') {
        _transformedResult = raw.toLowerCase();
      }
    });
  }

  void _addNewClip() {
    if (_clipInputController.text.trim().isNotEmpty) {
      setState(() {
        _pinnedClips.add(_clipInputController.text.trim());
        _clipInputController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pinned snippet added to Floating Dock!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.tealAccent),
            SizedBox(width: 10),
            Text(
              'BubbleDock Studio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isBubbleDockActive ? Icons.notifications : Icons.notifications_off,
              color: _isBubbleDockActive ? Colors.tealAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isBubbleDockActive = !_isBubbleDockActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBubbleDockActive
                        ? 'Floating Overlay Service Activated'
                        : 'Floating Overlay Service Paused',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Status Banner
            Container(
              color: Colors.teal.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _isBubbleDockActive ? Colors.greenAccent : Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isBubbleDockActive
                          ? 'Bubble Dock Active - Ready over apps'
                          : 'Dock Paused - Tap bell icon to enable overlay',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'v2.4 HUD',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            // Main Body Views
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  _buildLiveStudioTab(),
                  _buildTextTransformerTab(),
                  _buildMicroCalculatorTab(),
                  _buildSettingsAndPermissionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.teal.withOpacity(0.3),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets, color: Colors.tealAccent),
            label: 'Overlay Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            selectedIcon: Icon(Icons.text_fields, color: Colors.tealAccent),
            label: 'Text Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            selectedIcon: Icon(Icons.calculate, color: Colors.tealAccent),
            label: 'Micro Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            selectedIcon: Icon(Icons.settings, color: Colors.tealAccent),
            label: 'System HUD',
          ),
        ],
      ),
    );
  }

  // TAB 1: Live Interactive Overlay Dock Simulation
  Widget _buildLiveStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Floating Dock Visual Simulator Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Live Screen Overlay Preview',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Switch(
                        value: _isBubbleDockActive,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) {
                          setState(() {
                            _isBubbleDockActive = val;
                          });
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Simulated mobile screen showing how the floating bubble stays accessible over messaging, browser, and shopping apps.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Phone Frame Simulation
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF020617),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.teal.withOpacity(0.4), width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        // Background App Simulation Text
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 200,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Shopping Item: Wireless Headphones - Price \$85.00',
                                    style: TextStyle(fontSize: 11, color: Colors.white70),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Interactive Floating Bubble
                        if (_isBubbleDockActive)
                          Positioned(
                            top: 40,
                            right: _bubblePosition == 'Right Side' ? 12 : null,
                            left: _bubblePosition == 'Left Side' ? 12 : null,
                            child: GestureDetector(
                              onTap: () {
                                _showFloatingQuickMenuDialog(context);
                              },
                              child: Opacity(
                                opacity: _bubbleOpacity,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.teal, Colors.blueAccent],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.tealAccent.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.bolt, color: Colors.white, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Dock HUD',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Floating Pinboard Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Floating Snippet Pins',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent),
                onPressed: () => _showAddSnippetDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_pinnedClips.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No snippets pinned yet. Tap + to add floating notes!',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedClips.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.push_pin, color: Colors.amberAccent, size: 20),
                    title: Text(
                      _pinnedClips[index],
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: Colors.tealAccent),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied: "${_pinnedClips[index]}"')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _pinnedClips.removeAt(index);
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

  // TAB 2: Text Transformer & Format Studio
  Widget _buildTextTransformerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Text Transformer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Format copied texts instantly without switching apps.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Raw Input TextField
          TextField(
            controller: _textTransformerController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Input Raw Text or Paste Clipboard',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => _transformText('bullet'),
          ),

          const SizedBox(height: 12),

          // Transformation Actions Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ActionChip(
                avatar: const Icon(Icons.format_list_bulleted, size: 16, color: Colors.tealAccent),
                label: const Text('Bullet Points'),
                onPressed: () => _transformText('bullet'),
              ),
              ActionChip(
                avatar: const Icon(Icons.tag, size: 16, color: Colors.amberAccent),
                label: const Text('Hashtags'),
                onPressed: () => _transformText('hashtag'),
              ),
              ActionChip(
                avatar: const Icon(Icons.cleaning_services, size: 16, color: Colors.lightBlueAccent),
                label: const Text('Clean Spaces'),
                onPressed: () => _transformText('clean'),
              ),
              ActionChip(
                avatar: const Icon(Icons.text_fields, size: 16, color: Colors.orangeAccent),
                label: const Text('UPPERCASE'),
                onPressed: () => _transformText('uppercase'),
              ),
              ActionChip(
                avatar: const Icon(Icons.text_format, size: 16, color: Colors.purpleAccent),
                label: const Text('lowercase'),
                onPressed: () => _transformText('lowercase'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Transformed Result Display Box
          Card(
            color: const Color(0xFF090D16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Transformed Output',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Transformed text copied to clipboard!')),
                          );
                        },
                      )
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  Text(
                    _transformedResult.isEmpty ? 'No result generated yet.' : _transformedResult,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Instant Micro-Calculators (Discount, Tip Splitter, Unit)
  Widget _buildMicroCalculatorTab() {
    double discountAmount = (_originalPrice * _discountPercent) / 100;
    double taxAmount = ((_originalPrice - discountAmount) * _taxPercent) / 100;
    double finalPrice = (_originalPrice - discountAmount) + taxAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Discount & Price HUD',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate actual final checkout prices while browsing shopping apps.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Price Input
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Original Price (\$)'),
                      ),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: _originalPrice,
                          min: 5.0,
                          max: 1000.0,
                          divisions: 199,
                          activeColor: Colors.tealAccent,
                          label: '\$${_originalPrice.toStringAsFixed(0)}',
                          onChanged: (val) {
                            setState(() {
                              _originalPrice = val;
                            });
                          },
                        ),
                      ),
                      Text(
                        '\$${_originalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Discount Slider
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Discount (%)'),
                      ),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: _discountPercent,
                          min: 0.0,
                          max: 90.0,
                          divisions: 18,
                          activeColor: Colors.amberAccent,
                          label: '${_discountPercent.toStringAsFixed(0)}%',
                          onChanged: (val) {
                            setState(() {
                              _discountPercent = val;
                            });
                          },
                        ),
                      ),
                      Text(
                        '${_discountPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tax Slider
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text('Tax / VAT (%)'),
                      ),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: _taxPercent,
                          min: 0.0,
                          max: 30.0,
                          divisions: 30,
                          activeColor: Colors.deepOrangeAccent,
                          label: '${_taxPercent.toStringAsFixed(0)}%',
                          onChanged: (val) {
                            setState(() {
                              _taxPercent = val;
                            });
                          },
                        ),
                      ),
                      Text(
                        '${_taxPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Final Calculated Price Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Discount Savings:'),
                    Text('-\$${discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated Tax:'),
                    Text('+\$${taxAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const Divider(color: Colors.white70, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Final Total Pay:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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

  // TAB 4: Overlay Settings & System Permissions
  Widget _buildSettingsAndPermissionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overlay & System Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure system overlay options for optimal micro-app experience.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.layers, color: Colors.tealAccent),
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Allows floating dock bubble to sit above active apps.'),
                  value: _overlayPermissionGranted,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionGranted = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications, color: Colors.amberAccent),
                  title: const Text('Foreground Service Notification'),
                  subtitle: const Text('Keeps BubbleDock instant service active in background.'),
                  value: _notificationPermissionGranted,
                  activeColor: Colors.amberAccent,
                  onChanged: (val) {
                    setState(() {
                      _notificationPermissionGranted = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Dock Appearance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bubble Transparency (${(_bubbleOpacity * 100).toInt()}%)'),
                  Slider(
                    value: _bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    divisions: 7,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _bubbleOpacity = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Screen Dock Anchor Position'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Left Side')),
                          selected: _bubblePosition == 'Left Side',
                          selectedColor: Colors.teal,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _bubblePosition = 'Left Side';
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Right Side')),
                          selected: _bubblePosition == 'Right Side',
                          selectedColor: Colors.teal,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _bubblePosition = 'Right Side';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Floating Action Dialog to add Snippet
  void _showAddSnippetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pin New Floating Snippet'),
          content: TextField(
            controller: _clipInputController,
            decoration: const InputDecoration(
              hintText: 'e.g. Coupon code, address, phone...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                _addNewClip();
                Navigator.pop(context);
              },
              child: const Text('Pin Snippet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Floating Quick Menu Overlay Dialog Demo
  void _showFloatingQuickMenuDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'BubbleDock Quick Overlay',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                    ),
                    Icon(Icons.bolt, color: Colors.amberAccent),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.copy, color: Colors.tealAccent),
                  title: const Text('Paste & Format Clipboard'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calculate, color: Colors.amberAccent),
                  title: const Text('Instant Discount Splitter (\$)'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedTabIndex = 2;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.push_pin, color: Colors.orangeAccent),
                  title: Text('Active Snippets (${_pinnedClips.length})'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}