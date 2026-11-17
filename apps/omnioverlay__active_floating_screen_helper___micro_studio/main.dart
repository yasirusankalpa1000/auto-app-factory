import 'package:flutter/material.dart';

void main() {
  runApp(const OmniOverlayApp());
}

class OmniOverlayApp extends StatelessWidget {
  const OmniOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniOverlay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
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

  // Floating Overlay Control States
  bool _isOverlayEnabled = true;
  bool _isNotificationTickerActive = true;
  bool _isDisplayAboveAppsPermitted = true;
  bool _isAccessibilityPermitted = false;
  String _selectedFloatingTool = 'Quick Scratchpad';

  // Text Sanitizer States
  final TextEditingController _rawTextController = TextEditingController();
  String _sanitizedResult = '';
  int _charCount = 0;
  int _wordCount = 0;

  // Micro-Decision States
  final TextEditingController _decisionInputController = TextEditingController();
  final List<String> _decisionOptions = ['Pizza', 'Tacos', 'Sushi', 'Burger', 'Salad'];
  String _selectedDecision = 'Tap Spin to Decide!';
  bool _isSpinning = false;

  // Utility Splitter States
  final TextEditingController _billAmountController = TextEditingController();
  double _tipPercentage = 15.0;
  int _splitPeople = 2;
  double _perPersonTotal = 0.0;

  // Scratchpad Notes
  final TextEditingController _scratchNoteController = TextEditingController();
  final List<String> _savedScratchNotes = [
    'Order code: #9842',
    'Meeting link snippet saved',
  ];

  @override
  void initState() {
    super.initState();
    _calculateSplit();
  }

  void _calculateSplit() {
    final double bill = double.tryParse(_billAmountController.text) ?? 50.0;
    final double totalTip = bill * (_tipPercentage / 100.0);
    final double grandTotal = bill + totalTip;
    setState(() {
      _perPersonTotal = grandTotal / (_splitPeople > 0 ? _splitPeople : 1);
    });
  }

  void _sanitizeText(String mode) {
    String text = _rawTextController.text;
    if (text.isEmpty) {
      setState(() {
        _sanitizedResult = 'Please enter or paste some text first!';
      });
      return;
    }

    if (mode == 'clean') {
      text = text.replaceAll(RegExp(r'[^\w\s\.\,\!\?\-]'), '');
      text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    } else if (mode == 'bullets') {
      List<String> lines = text.split('\n');
      final sb = StringBuffer();
      for (var line in lines) {
        if (line.trim().isNotEmpty) {
          sb.writeln('• ${line.trim()}');
        }
      }
      text = sb.toString();
    } else if (mode == 'uppercase') {
      text = text.toUpperCase();
    } else if (mode == 'lowercase') {
      text = text.toLowerCase();
    } else if (mode == 'strip_urls') {
      text = text.replaceAll(RegExp(r'https?://\S+'), '[LINK REMOVED]');
    }

    setState(() {
      _sanitizedResult = text;
      _charCount = text.length;
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _spinDecision() async {
    if (_decisionOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = 'Spinning options...';
    });
    await Future.delayed(const Duration(milliseconds: 900));
    final randomIndex = (DateTime.now().millisecondsSinceEpoch) % _decisionOptions.length;
    setState(() {
      _selectedDecision = _decisionOptions[randomIndex];
      _isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 2,
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.teal),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'OmniOverlay Studio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isOverlayEnabled ? Colors.teal : Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _isOverlayEnabled ? 'ACTIVE' : 'OFF',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildOverlayStudioTab(),
                _buildTextSanitizerTab(),
                _buildDecisionHelperTab(),
                _buildQuickUtilityTab(),
              ],
            ),
            if (_isOverlayEnabled) _buildInteractiveFloatingHUD(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Overlay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Sanitizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Utilities',
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFloatingHUD() {
    return Positioned(
      top: 15,
      right: 15,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        color: Colors.indigo,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.teal, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt, color: Colors.amber, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Float: $_selectedFloatingTool',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Floating Widget: $_selectedFloatingTool opened!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.play_arrow, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.teal),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Floating Notification & Overlay Control',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Switch(
                        value: _isOverlayEnabled,
                        onChanged: (val) => setState(() => _isOverlayEnabled = val),
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Keep essential micro-tools floating above all your favorite social, news, and messaging apps.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Divider(height: 24, color: Colors.blueGrey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Persistent Notification Ticker', style: TextStyle(fontSize: 14)),
                      Switch(
                        value: _isNotificationTickerActive,
                        onChanged: (val) => setState(() => _isNotificationTickerActive = val),
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Quick Floating Tool Preset',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Quick Scratchpad',
              'Instant Sanitizer',
              'Micro Decision Wheel',
              'Bill & Tip Splitter'
            ].map((tool) {
              final isSelected = _selectedFloatingTool == tool;
              return ChoiceChip(
                label: Text(tool),
                selected: isSelected,
                selectedColor: Colors.teal,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedFloatingTool = tool);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Permission Dashboard',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.layers, color: Colors.blue),
                    title: const Text('Display Over Other Apps'),
                    subtitle: const Text('Allows floating quick action bar'),
                    trailing: Icon(
                      _isDisplayAboveAppsPermitted ? Icons.check_circle : Icons.error,
                      color: _isDisplayAboveAppsPermitted ? Colors.green : Colors.orange,
                    ),
                    onTap: () {
                      setState(() {
                        _isDisplayAboveAppsPermitted = !_isDisplayAboveAppsPermitted;
                      });
                    },
                  ),
                  const Divider(height: 1, color: Colors.blueGrey),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.security, color: Colors.purple),
                    title: const Text('Notification Listener Permission'),
                    subtitle: const Text('Enables interactive action bar notifications'),
                    trailing: Icon(
                      _isAccessibilityPermitted ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _isAccessibilityPermitted ? Colors.green : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        _isAccessibilityPermitted = !_isAccessibilityPermitted;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextSanitizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Text Sanitizer & Formatter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Clean copied text, strip emojis/URLs, or auto-format before sharing.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rawTextController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Paste messy raw text here...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => _sanitizeText('clean'),
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text('Strip Emojis & Symbols'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              ElevatedButton.icon(
                onPressed: () => _sanitizeText('bullets'),
                icon: const Icon(Icons.format_list_bulleted, size: 16),
                label: const Text('Auto-Bullet Lines'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              ),
              ElevatedButton.icon(
                onPressed: () => _sanitizeText('strip_urls'),
                icon: const Icon(Icons.link_off, size: 16),
                label: const Text('Remove Web Links'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
              ElevatedButton.icon(
                onPressed: () => _sanitizeText('uppercase'),
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('UPPERCASE'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_sanitizedResult.isNotEmpty) ...[
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sanitized Output',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.content_copy, size: 18, color: Colors.amber),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sanitized text copied to clipboard!')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, size: 18, color: Colors.white),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sharing sanitized text...')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _sanitizedResult,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const Divider(height: 16, color: Colors.blueGrey),
                    Row(
                      children: [
                        Chip(
                          label: Text('Chars: $_charCount'),
                          backgroundColor: const Color(0xFF0F172A),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text('Words: $_wordCount'),
                          backgroundColor: const Color(0xFF0F172A),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDecisionHelperTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Studio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Can\'t decide what to eat, watch, or do? Let the overlay pick instant micro-choices!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.touch_app, size: 48, color: Colors.amber),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _selectedDecision,
                      key: ValueKey<String>(_selectedDecision),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isSpinning ? Colors.grey : Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isSpinning ? null : _spinDecision,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Spin & Decide Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _decisionInputController,
                  decoration: const InputDecoration(
                    hintText: 'Add new choice (e.g., Movie)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.teal, size: 36),
                onPressed: () {
                  final text = _decisionInputController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(text);
                      _decisionInputController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Active Choices Pool:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((option) {
              return Chip(
                label: Text(option),
                backgroundColor: const Color(0xFF1E293B),
                onDeleted: _decisionOptions.length > 2
                    ? () {
                        setState(() {
                          _decisionOptions.remove(option);
                        });
                      }
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickUtilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Bill & Tip Splitter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _billAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Bill Amount (\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on, color: Colors.teal),
                    ),
                    onChanged: (val) => _calculateSplit(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Tip: ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: _tipPercentage,
                          min: 0,
                          max: 30,
                          divisions: 6,
                          activeColor: Colors.teal,
                          label: '${_tipPercentage.round()}%',
                          onChanged: (val) {
                            setState(() => _tipPercentage = val);
                            _calculateSplit();
                          },
                        ),
                      ),
                      Text('${_tipPercentage.round()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Split between: ', style: TextStyle(fontSize: 14)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: _splitPeople > 1
                            ? () {
                                setState(() => _splitPeople--);
                                _calculateSplit();
                              }
                            : null,
                      ),
                      Text('$_splitPeople people', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                        onPressed: () {
                          setState(() => _splitPeople++);
                          _calculateSplit();
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Colors.blueGrey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Each Person Pays:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_perPersonTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Floating Scratchpad Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.teal),
                onPressed: () {
                  _showAddNoteDialog();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedScratchNotes.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.edit_note, color: Colors.teal),
                  title: Text(
                    _savedScratchNotes[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                    onPressed: () {
                      setState(() {
                        _savedScratchNotes.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Add Scratch Note'),
          content: TextField(
            controller: _scratchNoteController,
            decoration: const InputDecoration(
              hintText: 'Enter quick temporary note...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_scratchNoteController.text.trim().isNotEmpty) {
                  setState(() {
                    _savedScratchNotes.add(_scratchNoteController.text.trim());
                    _scratchNoteController.clear();
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Save Note'),
            ),
          ],
        );
      },
    );
  }
}