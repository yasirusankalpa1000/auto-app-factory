import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OmniDock HUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({Key? key}) : super(key: key);

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _selectedTabIndex = 0;
  bool _isFloatingHudEnabled = true;
  bool _isOverlayExpanded = false;
  Offset _bubblePosition = const Offset(20, 200);

  // Sanitizer Tool States
  final TextEditingController _linkInputController = TextEditingController();
  String _cleanedLinkOutput = '';
  int _cleanedCount = 0;

  // Splitter & Currency State
  final TextEditingController _amountController = TextEditingController();
  double _tipPercentage = 15.0;
  int _peopleCount = 2;
  double _convertedRate = 1.0;
  String _selectedCurrency = 'USD (\$)';

  // Clipboard Vault State
  final List<Map<String, String>> _clipboardVault = [
    {
      'type': 'URL',
      'content': 'https://example.com/item?utm_source=social&fbclid=xyz123',
      'time': 'Just now'
    },
    {
      'type': 'TEXT',
      'content': 'Meeting scheduled at 4:30 PM today with team.',
      'time': '10 mins ago'
    },
    {
      'type': 'PRICE',
      'content': 'Total Amount: \$149.99 USD',
      'time': '1 hour ago'
    },
  ];

  // Bionic Reader State
  final TextEditingController _bionicTextController = TextEditingController();
  String _bionicOutputText = '';

  void _sanitizeUrl() {
    String raw = _linkInputController.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _cleanedLinkOutput = 'Please paste or enter a URL first.';
      });
      return;
    }

    try {
      Uri uri = Uri.parse(raw);
      if (uri.hasQuery) {
        Map<String, String> queryParams = Map.from(uri.queryParameters);
        queryParams.removeWhere((key, value) =>
            key.startsWith('utm_') ||
            key == 'fbclid' ||
            key == 'gclid' ||
            key == 'ref' ||
            key == 'si');
        
        Uri cleanUri = uri.replace(queryParameters: queryParams.isEmpty ? null : queryParams);
        setState(() {
          _cleanedLinkOutput = cleanUri.toString();
          _cleanedCount++;
        });
      } else {
        setState(() {
          _cleanedLinkOutput = raw;
        });
      }
    } catch (e) {
      setState(() {
        _cleanedLinkOutput = 'Cleaned: ' + raw.split('?')[0];
        _cleanedCount++;
      });
    }
  }

  void _generateBionicText() {
    String input = _bionicTextController.text;
    if (input.trim().isEmpty) {
      setState(() {
        _bionicOutputText = 'Enter text to generate Bionic speed reading structure.';
      });
      return;
    }
    setState(() {
      _bionicOutputText = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Content Dashboard
            Column(
              children: [
                _buildHeader(),
                _buildCategoryNavigationBar(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildFloatingHudDashboardTab(),
                      _buildLinkSanitizerTab(),
                      _buildSmartClipboardTab(),
                      _buildBionicReaderTab(),
                      _buildQuickSplitterTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Floating System HUD Bubble Dynamic Overlay
            if (_isFloatingHudEnabled)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubblePosition += details.delta;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _isOverlayExpanded = !_isOverlayExpanded;
                    });
                  },
                  child: DynamicOverlayBubble(
                    isExpanded: _isOverlayExpanded,
                    onClose: () {
                      setState(() {
                        _isOverlayExpanded = false;
                      });
                    },
                    onQuickSanitize: () {
                      setState(() {
                        _selectedTabIndex = 1;
                        _isOverlayExpanded = false;
                      });
                    },
                    onQuickClipboard: () {
                      setState(() {
                        _selectedTabIndex = 2;
                        _isOverlayExpanded = false;
                      });
                    },
                    onQuickBionic: () {
                      setState(() {
                        _selectedTabIndex = 3;
                        _isOverlayExpanded = false;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade600,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(Icons.widgets, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'OmniDock HUD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Floating Context Engine',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'HUD Bubble',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Switch(
                value: _isFloatingHudEnabled,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isFloatingHudEnabled = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryNavigationBar() {
    final List<Map<String, dynamic>> tabs = [
      {'title': 'Dock Controller', 'icon': Icons.dashboard},
      {'title': 'Link Sanitizer', 'icon': Icons.link},
      {'title': 'Smart Vault', 'icon': Icons.content_paste},
      {'title': 'Bionic Speed', 'icon': Icons.visibility},
      {'title': 'Quick Splitter', 'icon': Icons.calculate},
    ];

    return Container(
      height: 52,
      color: const Color(0xFF1E293B),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          bool isSelected = _selectedTabIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.indigo.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.indigo.shade300 : Colors.white70,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      tabs[index]['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tabs[index]['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // TAB 1: Floating HUD Dashboard Controls
  Widget _buildFloatingHudDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.indigo.shade400),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bolt, color: Colors.amber, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Overlay HUD Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'The floating bubble is ready on your screen! Drag it anywhere or tap it to open instant micro-tools while using other apps.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatChip(Icons.cleaning_services, '$_cleanedCount Links Cleaned'),
                    _buildStatChip(Icons.folder_special, '${_clipboardVault.length} Saved Clips'),
                    _buildStatChip(Icons.tune, 'System Overlay Ready'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Floating Micro-Utility Deck',
            style: TextStyle(color: Colors.white, fontSize: 16, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Interactive Shortcut Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildFeatureCard(
                'Link Stripper',
                'Remove tracking parameters',
                Icons.link_off,
                Colors.teal,
                () => setState(() => _selectedTabIndex = 1),
              ),
              _buildFeatureCard(
                'Smart Vault',
                'Multi-clip instant storage',
                Icons.content_paste_go,
                Colors.amber,
                () => setState(() => _selectedTabIndex = 2),
              ),
              _buildFeatureCard(
                'Bionic Reader',
                '3x Speed reading mode',
                Icons.auto_awesome,
                Colors.purple,
                () => setState(() => _selectedTabIndex = 3),
              ),
              _buildFeatureCard(
                'Quick Splitter',
                'Instant tips & split calc',
                Icons.calculate,
                Colors.deepOrange,
                () => setState(() => _selectedTabIndex = 4),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Permission & Settings Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HUD Customization & System Options',
                  style: TextStyle(color: Colors.white, fontSize: 14, FontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.phonelink_setup, color: Colors.cyan),
                  title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white, fontSize: 13)),
                  subtitle: const Text('Simulated system overlay permission', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.touch_app, color: Colors.orange),
                  title: const Text('Bubble Haptic Feedback', style: TextStyle(color: Colors.white, fontSize: 13)),
                  subtitle: const Text('Vulate on floating tap', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: Switch(value: true, onChanged: (v) {}, activeColor: Colors.teal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Link & Text Tracking Sanitizer
  Widget _buildLinkSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Link Tracking Stripper',
            style: TextStyle(color: Colors.white, fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste messy social URLs (Facebook, X, Instagram, Shopping) to automatically remove hidden tracking tags (utm, fbclid, ref) before sharing.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _linkInputController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Paste link here e.g. https://site.com/product?utm_source=ad&fbclid=123',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sanitizeUrl,
                  icon: const Icon(Icons.cleaning_services, size: 18),
                  label: const Text('Sanitize & Clean Link'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.vertical: 14),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  _linkInputController.clear();
                  setState(() {
                    _cleanedLinkOutput = '';
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.grey),
                tooltip: 'Clear input',
              )
            ],
          ),
          const SizedBox(height: 20),

          if (_cleanedLinkOutput.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.teal.shade700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.teal, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Cleaned Link Output:',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.teal, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cleaned link copied to clipboard!')),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _cleanedLinkOutput,
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // TAB 3: Smart Clipboard Vault
  Widget _buildSmartClipboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Smart Clipboard Stack',
                style: TextStyle(color: Colors.white, fontSize: 18, FontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _clipboardVault.insert(0, {
                      'type': 'TEXT',
                      'content': 'Newly auto-captured text clip item \$29.99',
                      'time': 'Just now'
                    });
                  });
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Simulate Copy', style: TextStyle(fontSize: 11)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade600, foregroundColor: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Dynamic floating stack holding your recent clips with instant micro-actions.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clipboardVault.length,
            itemBuilder: (context, index) {
              final item = _clipboardVault[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.white70),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item['type'] == 'URL' ? Colors.teal.shade800 : Colors.indigo.shade800,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['type'] ?? 'TEXT',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          item['time'] ?? '',
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['content'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, size: 16, color: Colors.grey),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16, color: Colors.teal),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied clip item!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _clipboardVault.removeAt(index);
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 4: Bionic Reader Engine
  Widget _buildBionicReaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bionic Speed Reading Converter',
            style: TextStyle(color: Colors.white, fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Transform long web articles or chat text into Bionic reading format to focus your eyes on initial letters for 3x faster reading speed.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _bionicTextController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Paste long paragraph or web article text here...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generateBionicText,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Convert to Speed Reader Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (_bionicOutputText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.purple.shade400),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Speed Reading View:',
                    style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildFormattedBionicWidget(_bionicOutputText),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormattedBionicWidget(String originalText) {
    List<String> words = originalText.split(' ');
    return Wrap(
      spacing: 4.0,
      runSpacing: 6.0,
      crossAxisAlignment: WrapCrossAxisAlignment.center,
      children: words.map((word) {
        if (word.isEmpty) return const SizedBox();
        int mid = (word.length / 2).ceil();
        String boldPart = word.substring(0, mid);
        String restPart = word.substring(mid);

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: boldPart,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              TextSpan(
                text: restPart,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // TAB 5: Quick Floating Splitter & Currency Converter
  Widget _buildQuickSplitterTab() {
    double totalBill = double.tryParse(_amountController.text) ?? 0.0;
    double totalTip = totalBill * (_tipPercentage / 100.0);
    double grandTotal = totalBill + totalTip;
    double perPerson = _peopleCount > 0 ? (grandTotal / _peopleCount) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Split & Tip Floating Calc',
            style: TextStyle(color: Colors.white, fontSize: 18, FontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Quickly calculate restaurant bills, tips, and personal share while keeping other apps open.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Main Result Card
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade900, Colors.orange.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                const Text('Per Person Share', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    '\$${perPerson.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 36, FontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Bill: \$${totalBill.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('Tip (${_tipPercentage.toInt()}%): \$${totalTip.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Inputs
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Bill Amount (\$)',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // Tip Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tip Percentage:', style: TextStyle(color: Colors.white, fontSize: 13)),
              Text('${_tipPercentage.toInt()}%', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _tipPercentage,
            min: 0,
            max: 30,
            divisions: 6,
            activeColor: Colors.orange,
            onChanged: (val) {
              setState(() {
                _tipPercentage = val;
              });
            },
          ),
          const SizedBox(height: 12),

          // Split Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Split Among People:', style: TextStyle(color: Colors.white, fontSize: 13)),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_peopleCount > 1) setState(() => _peopleCount--);
                    },
                    icon: const Icon(Icons.remove_circle, color: Colors.orange),
                  ),
                  Text('$_peopleCount', style: const TextStyle(color: Colors.white, fontSize: 16, FontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      setState(() => _peopleCount++);
                    },
                    icon: const Icon(Icons.add_circle, color: Colors.orange),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.amber),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String desc, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// SIMULATED FLOATING SYSTEM OVERLAY HUD BUBBLE WIDGET
class DynamicOverlayBubble extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onClose;
  final VoidCallback onQuickSanitize;
  final VoidCallback onQuickClipboard;
  final VoidCallback onQuickBionic;

  const DynamicOverlayBubble({
    Key? key,
    required this.isExpanded,
    required this.onClose,
    required this.onQuickSanitize,
    required this.onQuickClipboard,
    required this.onQuickBionic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.indigo],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: const Icon(Icons.widgets, color: Colors.white, size: 26),
      );
    }

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.shade400, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 15,
            spreadRadius: 4,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.bolt, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text('OmniDock Quick', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, color: Colors.grey, size: 16),
              ),
            ],
          ),
          const Divider(color: Colors.white70),
          _buildQuickHudItem(Icons.cleaning_services, 'Sanitize Link', Colors.teal, onQuickSanitize),
          _buildQuickHudItem(Icons.content_paste, 'Smart Vault', Colors.amber, onQuickClipboard),
          _buildQuickHudItem(Icons.visibility, 'Bionic Reader', Colors.purple, onQuickBionic),
        ],
      ),
    );
  }

  Widget _buildQuickHudItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}