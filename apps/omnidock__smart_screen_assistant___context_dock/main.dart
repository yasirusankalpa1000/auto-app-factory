import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniDock Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF10141D),
        cardColor: const Color(0xFF1A212D),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: Color(0xFF1A212D),
        ),
      ),
      home: const MainDockScreen(),
    );
  }
}

class SnippetItem {
  String id;
  String title;
  String content;
  String category;

  SnippetItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });
}

class ComparisonOption {
  String name;
  double price;
  double rating;
  double deliveryCost;

  ComparisonOption({
    required this.name,
    required this.price,
    required this.rating,
    required this.deliveryCost,
  });

  double get totalCost => price + deliveryCost;

  double get score {
    if (totalCost == 0) return 0;
    return ((rating / totalCost) * 1000).clamp(0, 100);
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({Key? key}) : super(key: key);

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentTabIndex = 0;
  bool _floatingOverlayActive = true;
  bool _floatingNotificationEnabled = true;

  // Snippets State
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Commercial Bank Account',
      content: 'Commercial Bank | Acc: 8009123456 | Branch: Colombo | Name: J. Doe',
      category: 'Finance',
    ),
    SnippetItem(
      id: '2',
      title: 'Delivery Address',
      content: 'No 45/2, Temple Road, Nugegoda, Western Province, Sri Lanka.',
      category: 'Personal',
    ),
    SnippetItem(
      id: '3',
      title: 'WhatsApp Business Intro',
      content: 'Hello! Thank you for contacting us. How can we assist your order today?',
      category: 'Work',
    ),
  ];

  // Comparison State
  final List<ComparisonOption> _comparisonList = [
    ComparisonOption(
      name: 'Option A (Local Store)',
      price: 3500.0,
      rating: 4.5,
      deliveryCost: 250.0,
    ),
    ComparisonOption(
      name: 'Option B (Online App)',
      price: 3100.0,
      rating: 4.1,
      deliveryCost: 450.0,
    ),
  ];

  // Text Transformer State
  final TextEditingController _rawTextController = TextEditingController();
  String _transformedText = '';

  @override
  void dispose() {
    _rawTextController.dispose();
    super.dispose();
  }

  void _addSnippet(String title, String content, String category) {
    setState(() {
      _snippets.add(
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          category: category,
        ),
      );
    });
  }

  void _addComparisonOption(String name, double price, double rating, double delivery) {
    setState(() {
      _comparisonList.add(
        ComparisonOption(
          name: name,
          price: price,
          rating: rating,
          deliveryCost: delivery,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161C26),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.layers, color: Colors.teal),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'OmniDock Assistant',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Chip(
              backgroundColor: _floatingOverlayActive ? Colors.teal : Colors.grey,
              avatar: Icon(
                _floatingOverlayActive ? Icons.check_circle : Icons.pause_circle,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                _floatingOverlayActive ? 'Dock Active' : 'Dock Paused',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopDockStatusBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTabIndex,
                    children: [
                      _buildSnippetVaultTab(),
                      _buildComparisonTab(),
                      _buildTextLabTab(),
                      _buildDockSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
            if (_floatingOverlayActive) _buildSimulatedFloatingWidget(),
          ],
        ),
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
        backgroundColor: const Color(0xFF161C26),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Text Lab',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'HUD Dock',
          ),
        ],
      ),
    );
  }

  Widget _buildTopDockStatusBanner() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1F2836),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Quick Tip: OmniDock stays running floating over WhatsApp, Shopping & Web apps.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _floatingOverlayActive = !_floatingOverlayActive;
                });
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                _floatingOverlayActive ? 'Disable' : 'Enable Floating HUD',
                style: const TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: SNIPPET VAULT
  Widget _buildSnippetVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Quick Snippet Vault',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddSnippetDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep high-frequency text ready for 1-tap copying & instant floating usage.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('All', true),
              _buildCategoryChip('Finance', false),
              _buildCategoryChip('Personal', false),
              _buildCategoryChip('Work', false),
            ],
          ),
          const SizedBox(height: 16),
          if (_snippets.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: const [
                    Icon(Icons.style, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No quick snippets saved yet.', style: TextStyle(color: Colors.grey)),
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
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121722),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SelectableText(
                            item.content,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                              onPressed: () {
                                setState(() {
                                  _snippets.removeAt(index);
                                });
                              },
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied "${item.title}" to clipboard!'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.teal,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('1-Tap Copy'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF283547),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
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
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Chip(
      backgroundColor: isSelected ? Colors.teal : const Color(0xFF202A38),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // TAB 2: DEAL & CHOICE COMPARISON MATRIX
  Widget _buildComparisonTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Deal & Choice Matrix',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddComparisonDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Option'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Compare shopping prices, delivery fees & ratings instantly while browsing apps.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          if (_comparisonList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: const [
                    Icon(Icons.scale, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No options added for comparison yet.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comparisonList.length,
              itemBuilder: (context, index) {
                final option = _comparisonList[index];
                final isBestScore = index == 0 && _comparisonList.length > 1;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isBestScore
                        ? const BorderSide(color: Colors.amber, width: 2)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                option.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isBestScore)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'BEST VALUE',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                'Price',
                                'LKR ${option.price.toStringAsFixed(2)}',
                                Icons.monetization_on,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMetricTile(
                                'Delivery',
                                'LKR ${option.deliveryCost.toStringAsFixed(2)}',
                                Icons.local_shipping,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMetricTile(
                                'Rating',
                                '${option.rating} / 5.0',
                                Icons.star,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121722),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Cost: LKR ${option.totalCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Value Score: ',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    option.score.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _comparisonList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete, size: 16, color: Colors.grey),
                            label: const Text('Remove', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ),
                        )
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

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF141A24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // TAB 3: SMART TEXT LAB
  Widget _buildTextLabTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Text Lab & Cleaner',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Clean tracking URLs, reformat phone numbers, or split quick bills directly.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _rawTextController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Paste raw messy text, phone numbers (+94 77 123 4567), or URLs here...',
              hintStyle: TextStyle(color: Colors.grey),
              fillColor: Color(0xFF1A212D),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => _transformPhoneNumbers(),
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Format Phone Numbers'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF283547)),
              ),
              ElevatedButton.icon(
                onPressed: () => _cleanTrackingLinks(),
                icon: const Icon(Icons.link_off, size: 16),
                label: const Text('Strip URL Tracking'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF283547)),
              ),
              ElevatedButton.icon(
                onPressed: () => _uppercaseTransform(),
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('ALL CAPS'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF283547)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_transformedText.isNotEmpty) ...[
            const Text(
              'Transformed Result:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF121722),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal.withOpacity(0.4)),
              ),
              child: SelectableText(
                _transformedText,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Result copied to clipboard!'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy Output'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _transformPhoneNumbers() {
    String text = _rawTextController.text;
    String cleaned = text.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '+94${cleaned.substring(1)}';
    }
    setState(() {
      _transformedText = cleaned.isEmpty ? 'No digits found to format.' : cleaned;
    });
  }

  void _cleanTrackingLinks() {
    String text = _rawTextController.text;
    if (text.contains('?')) {
      text = text.split('?').first;
    }
    setState(() {
      _transformedText = text.trim().isEmpty ? 'Enter valid URL.' : text.trim();
    });
  }

  void _uppercaseTransform() {
    setState(() {
      _transformedText = _rawTextController.text.toUpperCase();
    });
  }

  // TAB 4: FLOATING SYSTEM DOCK SETTINGS
  Widget _buildDockSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating HUD & Permissions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure floating overlay triggers and ambient sticky notification controls.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.teal,
                  title: const Text('Display Above Other Apps', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Allows OmniDock bubble to float over WhatsApp, Chrome & Daraz', style: TextStyle(fontSize: 12)),
                  value: _floatingOverlayActive,
                  onChanged: (val) {
                    setState(() {
                      _floatingOverlayActive = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  activeColor: Colors.teal,
                  title: const Text('Sticky Floating Notification Bar', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Quick paste & deal helper directly in system shade', style: TextStyle(fontSize: 12)),
                  value: _floatingNotificationEnabled,
                  onChanged: (val) {
                    setState(() {
                      _floatingNotificationEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D2635),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.shield, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Zero Data Upload Policy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'OmniDock operates 100% locally on your phone memory. Your copied clipboard data, addresses, and account numbers are never transmitted outside your device.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SIMULATED FLOATING SCREEN WIDGET OVERLAY
  Widget _buildSimulatedFloatingWidget() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.smart_button, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              const Text(
                'OmniDock HUD',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Floating Dock Launcher Triggered!'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.open_in_full, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DIALOG FOR ADDING SNIPPETS
  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Personal';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1F2836),
              title: const Text('Add Quick Snippet Card', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Card Title (e.g. My Bank Acc)',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Snippet Content / Text',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      dropdownColor: const Color(0xFF1F2836),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Personal', 'Finance', 'Work', 'Social']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            category = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      _addSnippet(titleController.text, contentController.text, category);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Card', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // DIALOG FOR ADDING COMPARISON OPTIONS
  void _showAddComparisonDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final ratingController = TextEditingController();
    final deliveryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2836),
          title: const Text('Add Shopping Deal / Option', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Option Name (e.g. Daraz Seller A)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Price (LKR)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: deliveryController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Delivery Cost (LKR)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ratingController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Rating (1 to 5)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                final name = nameController.text.isEmpty ? 'New Option' : nameController.text;
                final price = double.tryParse(priceController.text) ?? 0.0;
                final delivery = double.tryParse(deliveryController.text) ?? 0.0;
                final rating = double.tryParse(ratingController.text) ?? 4.0;

                _addComparisonOption(name, price, rating, delivery);
                Navigator.pop(context);
              },
              child: const Text('Calculate & Add', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}