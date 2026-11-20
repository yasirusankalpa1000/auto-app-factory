import 'package:flutter/material.dart';

void main() {
  runApp(const ContextBubbleApp());
}

class ContextBubbleApp extends StatelessWidget {
  const ContextBubbleApp({super.key});

  @override
  Widget build(BuildContext me) {
    return MaterialApp(
      title: 'ContextBubble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  final String rawContent;
  final String category;
  final DateTime timestamp;
  bool isFavorite;

  SnippetItem({
    required this.id,
    required this.rawContent,
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
  int _currentTabIndex = 0;
  bool _isOverlayEnabled = true;
  bool _isBubbleExpanded = false;
  Offset _bubblePosition = const Offset(20, 200);

  // Sample data to provide immediate value to user
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      rawContent:
          'Hey, the shoes cost \$45.00, shirt is \$22.50, and shipping is \$8.00. Total budget check!',
      category: 'Prices & Math',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    SnippetItem(
      id: '2',
      rawContent:
          'Please send the report to alex.manager@work.com or call +1 555-0199 for urgent queries.',
      category: 'Contacts',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    SnippetItem(
      id: '3',
      rawContent:
          'I am extremely disappointed with the delayed delivery of my recent parcel.',
      category: 'Text Tone',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  final TextEditingController _inputController = TextEditingController();
  String _activeCategoryFilter = 'All';
  String _transformerOutput = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _addNewSnippet(String text) {
    if (text.trim().isEmpty) return;

    String cat = 'General';
    if (text.contains('\$') || RegExp(r'\d+').hasMatch(text)) {
      cat = 'Prices & Math';
    } else if (text.contains('@') || text.contains('+')) {
      cat = 'Contacts';
    } else if (text.startsWith('http')) {
      cat = 'Links';
    }

    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          rawContent: text.trim(),
          category: cat,
          timestamp: DateTime.now(),
        ),
      );
    });
    _inputController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to Context Vault!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Smart Context Tooling Functions
  void _extractAndSumPrices(String text) {
    final RegExp priceRegex = RegExp(r'\$(\d+(?:\.\d{1,2})?)');
    final matches = priceRegex.allMatches(text);
    double total = 0.0;
    List<String> foundPrices = [];

    for (var m in matches) {
      String matchStr = m.group(1) ?? '0';
      double val = double.tryParse(matchStr) ?? 0.0;
      total += val;
      foundPrices.add('\$$matchStr');
    }

    setState(() {
      if (foundPrices.isEmpty) {
        _transformerOutput =
            'No prices with dollar signs (e.g., \$25.50) found in text.';
      } else {
        _transformerOutput =
            'Found Prices: ${foundPrices.join(', ')}\nCalculated Total Sum: \$${total.toStringAsFixed(2)}';
      }
    });
  }

  void _convertCurrency(String text, double rate, String targetSymbol) {
    final RegExp priceRegex = RegExp(r'\$(\d+(?:\.\d{1,2})?)');
    final matches = priceRegex.allMatches(text);

    if (matches.isEmpty) {
      setState(() {
        _transformerOutput =
            'No USD ($XX) values detected to convert. Type something like \$50.';
      });
      return;
    }

    StringBuffer buffer = StringBuffer();
    buffer.writeln('Converted Values (Rate multiplier: $rate):');
    for (var m in matches) {
      double usdVal = double.tryParse(m.group(1) ?? '0') ?? 0.0;
      double converted = usdVal * rate;
      buffer.writeln(
          '\$${usdVal.toStringAsFixed(2)} => $targetSymbol${converted.toStringAsFixed(2)}');
    }

    setState(() {
      _transformerOutput = buffer.toString();
    });
  }

  void _transformTone(String text, String toneType) {
    if (text.isEmpty) {
      setState(() {
        _transformerOutput = 'Please select or enter text first.';
      });
      return;
    }

    setState(() {
      if (toneType == 'Polite') {
        _transformerOutput =
            'Polite Version:\n"Dear Team, could you kindly check into this: $text. Thank you for your assistance!"';
      } else if (toneType == 'Professional') {
        _transformerOutput =
            'Professional Summary:\n"Regarding the matter: \'$text\', please be advised to review the details accordingly."';
      } else if (toneType == 'Casual') {
        _transformerOutput =
            'Casual Chat:\n"Hey! Just checking about this real quick: $text 😊"';
      }
    });
  }

  void _extractContacts(String text) {
    final emailRegex =
        RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final phoneRegex = RegExp(r'\+?\d[\d -]{7,}\d');

    final emails = emailRegex.allMatches(text).map((m) => m.group(0)).toList();
    final phones = phoneRegex.allMatches(text).map((m) => m.group(0)).toList();

    StringBuffer buffer = StringBuffer();
    buffer.writeln('Extracted Contact Details:');
    buffer.writeln(
        'Emails: ${emails.isEmpty ? "None" : emails.join(", ")}');
    buffer.writeln(
        'Phone Numbers: ${phones.isEmpty ? "None" : phones.join(", ")}');

    setState(() {
      _transformerOutput = buffer.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          'ContextBubble Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              const Text(
                'Float Dock',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              Switch(
                value: _isOverlayEnabled,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _isOverlayEnabled = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab Content
            IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildFloatOverlaySimulatorTab(),
                _buildTransformerTab(),
                _buildSnippetVaultTab(),
              ],
            ),

            // Interactive Floating System Overlay Simulator
            if (_isOverlayEnabled) _buildDraggableFloatingBubble(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Screen Overlay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Smart Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Context Vault',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: Floating Overlay Simulator & Phone Screen Preview ---
  Widget _buildFloatOverlaySimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.deepPurple.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.deepPurple.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.security, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Simulated Floating Dock active',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The purple floating bubble widget on screen simulates a persistent Draw-Over-Apps helper. Drag it anywhere or tap it to open instant context actions!',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quick Floating Actions Configuration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.monetization_on, color: Colors.green),
                  title: const Text('Auto-Sum Prices on Copy'),
                  subtitle: const Text('Detect \$ amounts and sum instantly'),
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Colors.deepPurple,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.currency_exchange, color: Colors.orange),
                  title: const Text('Instant Currency Converter'),
                  subtitle: const Text('Convert USD to local target'),
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Colors.deepPurple,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.record_voice_over,
                      color: Colors.blue),
                  title: const Text('Smart Tone Assistant'),
                  subtitle: const Text('Rephrase harsh messages to polite'),
                  trailing: Switch(
                    value: true,
                    onChanged: (v) {},
                    activeColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Live Simulated App Context',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat / Browser Screen Simulation',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '"Hey! Can you total these items for me? Laptop stand is \$35.99, Mouse pad is \$14.50, USB Cable is \$9.99. Thanks!"',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    _extractAndSumPrices(
                        'Laptop stand is \$35.99, Mouse pad is \$14.50, USB Cable is \$9.99');
                    setState(() {
                      _currentTabIndex = 1;
                    });
                  },
                  icon: const Icon(Icons.calculate, color: Colors.white),
                  label: const Text('Process Text in Smart Tools'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: Smart Tools & Instant Transformer ---
  Widget _buildTransformerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Context Transformer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste any text containing prices, emails, or rough messages to instantly convert or calculate.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText:
                  'Type or paste text here (e.g., "\$45.00 and \$12.50" or contact info)',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => _addNewSnippet(_inputController.text),
                icon: const Icon(Icons.add),
                label: const Text('Save Snippet'),
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    _extractAndSumPrices(_inputController.text),
                icon: const Icon(Icons.monetization_on, color: Colors.green),
                label: const Text('Sum \$ Prices'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade900,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    _convertCurrency(_inputController.text, 300.0, 'LKR '),
                icon: const Icon(Icons.currency_exchange, color: Colors.orange),
                label: const Text('Convert USD -> LKR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade50,
                  foregroundColor: Colors.orange.shade900,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _extractContacts(_inputController.text),
                icon: const Icon(Icons.contact_phone, color: Colors.blue),
                label: const Text('Extract Contacts'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Change Message Tone:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.favorite, size: 16, color: Colors.pink),
                label: const Text('Make Polite'),
                onPressed: () =>
                    _transformTone(_inputController.text, 'Polite'),
              ),
              ActionChip(
                avatar: const Icon(Icons.work, size: 16, color: Colors.indigo),
                label: const Text('Make Professional'),
                onPressed: () =>
                    _transformTone(_inputController.text, 'Professional'),
              ),
              ActionChip(
                avatar: const Icon(Icons.chat, size: 16, color: Colors.teal),
                label: const Text('Make Casual'),
                onPressed: () =>
                    _transformTone(_inputController.text, 'Casual'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_transformerOutput.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transformer Output Result',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Result copied to clipboard!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _transformerOutput,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 3: Context Vault ---
  Widget _buildSnippetVaultTab() {
    List<SnippetItem> filteredList = _activeCategoryFilter == 'All'
        ? _snippets
        : _snippets
            .where((s) => s.category == _activeCategoryFilter)
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Context Snippet Vault',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_snippets.length} Saved',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Prices & Math', 'Contacts', 'Text Tone', 'Links']
                  .map((cat) {
                final isSelected = _activeCategoryFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(cat),
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _activeCategoryFilter = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          if (filteredList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  'No snippets in this category yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
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
                                  icon: const Icon(Icons.delete,
                                      color: Colors.grey, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _snippets.removeWhere(
                                          (element) => element.id == item.id);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.rawContent,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.play_arrow, size: 14),
                              label: const Text('Process'),
                              onPressed: () {
                                _inputController.text = item.rawContent;
                                setState(() {
                                  _currentTabIndex = 1;
                                });
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.copy, size: 14),
                              label: const Text('Copy'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied snippet!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
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
    );
  }

  // --- DRAGGABLE FLOATING SYSTEM OVERLAY SIMULATOR ---
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isBubbleExpanded = !_isBubbleExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bubble_chart,
                  color: Colors.amber,
                  size: 28,
                ),
              ),
            ),
            if (_isBubbleExpanded) ...[
              const SizedBox(height: 8),
              Container(
                width: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                    ),
                  ],
                  border: Border.all(color: Colors.deepPurple.shade100),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Float Helper',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.deepPurple,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isBubbleExpanded = false;
                            });
                          },
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                    const Divider(),
                    ListTile(
                      dense: true,
                      padding: EdgeInsets.zero,
                      leading:
                          const Icon(Icons.calculate, color: Colors.green, size: 20),
                      title: const Text('Sum \$ in Chat',
                          style: TextStyle(fontSize: 12)),
                      onTap: () {
                        setState(() {
                          _inputController.text =
                              'Selected chat total: \$15.50 + \$24.00';
                          _currentTabIndex = 1;
                          _isBubbleExpanded = false;
                        });
                        _extractAndSumPrices(_inputController.text);
                      },
                    ),
                    ListTile(
                      dense: true,
                      padding: EdgeInsets.zero,
                      leading:
                          const Icon(Icons.transform, color: Colors.blue, size: 20),
                      title: const Text('Polite Reply',
                          style: TextStyle(fontSize: 12)),
                      onTap: () {
                        setState(() {
                          _inputController.text =
                              'Please finish this project as soon as possible.';
                          _currentTabIndex = 1;
                          _isBubbleExpanded = false;
                        });
                        _transformTone(_inputController.text, 'Polite');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}