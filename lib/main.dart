import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SnapContextApp());
}

class SnapContextApp extends StatelessWidget {
  const SnapContextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapContext Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String title;
  final String content;
  final String category;
  bool isPinned;

  ClipItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Floating Overlay Bubble State
  bool _isOverlayEnabled = true;
  bool _isNotificationAllowed = true;
  bool _showFloatingDock = false;
  Offset _bubblePosition = const Offset(20, 200);
  bool _showSimulatedNotification = false;
  String _notificationMessage = '';

  // Text Tool State
  final TextEditingController _textToolController = TextEditingController();
  String _processedResult = '';

  // Quick Reply State
  String _selectedCategory = 'Banking';
  String _selectedTone = 'Professional';
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  String _generatedReply = '';

  // Clip Vault State
  final TextEditingController _searchController = TextEditingController();
  String _selectedClipFilter = 'All';
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      title: 'Commercial Bank Acc',
      content: 'Bank: Commercial Bank\nAcc No: 8001234567\nName: A. B. Perera\nBranch: Colombo Fort',
      category: 'Banking',
      isPinned: true,
    ),
    ClipItem(
      id: '2',
      title: 'Home Address Drop',
      content: 'No. 45, Temple Road, Nugegoda. Near Supermarket.',
      category: 'Delivery',
      isPinned: true,
    ),
    ClipItem(
      id: '3',
      title: 'Standard Work Out Office Reply',
      content: 'I am currently away from my desk. For urgent matters, please call my phone directly.',
      category: 'Work',
      isPinned: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupDefaultQuickReplyFields();
  }

  void _setupDefaultQuickReplyFields() {
    if (_selectedCategory == 'Banking') {
      _field1Controller.text = 'Bank of Ceylon';
      _field2Controller.text = '78901234';
      _field3Controller.text = 'K. L. Jayasinghe';
    } else if (_selectedCategory == 'Polite Decline') {
      _field1Controller.text = 'Meeting Request';
      _field2Controller.text = 'Prior commitments';
      _field3Controller.text = 'Next Monday';
    } else if (_selectedCategory == 'Price Quote') {
      _field1Controller.text = 'Premium Widget Set';
      _field2Controller.text = '\$45.00';
      _field3Controller.text = 'Free Delivery Included';
    }
    _generateQuickReply();
  }

  void _triggerSimulatedNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _showSimulatedNotification = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showSimulatedNotification = false;
        });
      }
    });
  }

  void _copyToClipboard(String text, String label) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    _triggerSimulatedNotification('Copied $label to clipboard!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied successfully!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Text Processing Helpers ---
  void _extractPhoneNumbers() {
    final String raw = _textToolController.text;
    final RegExp phoneRegex = RegExp(r'(\+?\d{10,13}|0\d{9})');
    final Iterable<RegExpMatch> matches = phoneRegex.allMatches(raw);
    final List<String> found = matches.map((m) => m.group(0)! .replaceAll(' ', '')).toList();

    if (found.isEmpty) {
      setState(() {
        _processedResult = 'No valid phone numbers detected in input.';
      });
    } else {
      setState(() {
        _processedResult = 'Extracted Phone Numbers:\n' + found.join('\n');
      });
    }
  }

  void _cleanAndFormatLinks() {
    final String raw = _textToolController.text;
    final RegExp urlRegex = RegExp(r'https?://[^\s]+');
    final Iterable<RegExpMatch> matches = urlRegex.allMatches(raw);

    if (matches.isEmpty) {
      setState(() {
        _processedResult = 'No URLs found. Cleaned Text:\n' + raw.replaceAll(RegExp(r'\s+'), ' ').trim();
      });
      return;
    }

    List<String> cleanedUrls = [];
    for (var m in matches) {
      String url = m.group(0)!;
      if (url.contains('?')) {
        url = url.split('?').first; // Strip tracking UTM parameters
      }
      cleanedUrls.add(url);
    }

    setState(() {
      _processedResult = 'Cleaned Direct Links (Tracking Stripped):\n' + cleanedUrls.join('\n');
    });
  }

  void _maskSensitiveData() {
    final String raw = _textToolController.text;
    if (raw.isEmpty) return;

    // Masks numbers longer than 4 digits
    String masked = raw.replaceAllMapped(RegExp(r'\d{5,16}'), (match) {
      String str = match.group(0)!;
      int keep = 3;
      if (str.length <= keep) return str;
      return str.substring(0, keep) + '•' * (str.length - keep);
    });

    setState(() {
      _processedResult = masked;
    });
  }

  void _changeCase(String type) {
    final String raw = _textToolController.text;
    if (raw.isEmpty) return;

    if (type == 'upper') {
      setState(() {
        _processedResult = raw.toUpperCase();
      });
    } else if (type == 'lower') {
      setState(() {
        _processedResult = raw.toLowerCase();
      });
    } else if (type == 'title') {
      List<String> words = raw.split(' ');
      String title = words.map((w) {
        if (w.isEmpty) return '';
        return w[0].toUpperCase() + w.substring(1).toLowerCase();
      }).join(' ');
      setState(() {
        _processedResult = title;
      });
    }
  }

  // --- Quick Reply Builder ---
  void _generateQuickReply() {
    final f1 = _field1Controller.text.trim();
    final f2 = _field2Controller.text.trim();
    final f3 = _field3Controller.text.trim();

    String result = '';

    if (_selectedCategory == 'Banking') {
      if (_selectedTone == 'Professional') {
        result = 'Dear Sir/Madam,\nHere are my bank transfer details:\n• Bank: $f1\n• Account Number: $f2\n• Account Holder: $f3\nPlease share the receipt once completed. Thank you!';
      } else if (_selectedTone == 'Casual') {
        result = 'Hey! You can transfer to my $f1 account:\nNo: $f2\nName: $f3\nLet me know once done!';
      } else {
        result = 'Bank Details:\n$f1 | Acc: $f2 | Name: $f3';
      }
    } else if (_selectedCategory == 'Polite Decline') {
      if (_selectedTone == 'Professional') {
        result = 'Thank you for reaching out regarding $f1. Regrettably, due to $f2, I am unable to proceed at this time. Perhaps we can re-evaluate around $f3. Best regards.';
      } else if (_selectedTone == 'Casual') {
        result = 'Thanks for thinking of me for $f1! Unfortunately, I am tied up with $f2 right now. Let\'s reconnect around $f3!';
      } else {
        result = 'Cannot commit to $f1 right now due to $f2. Will check back on $f3.';
      }
    } else if (_selectedCategory == 'Price Quote') {
      if (_selectedTone == 'Professional') {
        result = 'Hello,\nHere is the pricing detail for $f1:\n• Amount: $f2\n• Note: $f3\nPlease confirm if you would like to proceed with this order.';
      } else if (_selectedTone == 'Casual') {
        result = 'Hi there! The $f1 is priced at $f2 ($f3). Let me know if you want me to reserve this for you!';
      } else {
        result = 'Item: $f1 | Price: $f2 | Details: $f3';
      }
    }

    setState(() {
      _generatedReply = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'SnapContext Hub',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.layers : Icons.layers_clear,
              color: _isOverlayEnabled ? Colors.indigo : Colors.grey,
            ),
            tooltip: 'Toggle Floating Bubble',
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              _triggerSimulatedNotification(
                _isOverlayEnabled ? 'Floating Dock Activated' : 'Floating Dock Disabled',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              _triggerSimulatedNotification('SnapContext background monitoring active');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildTextStudioTab(),
                _buildQuickReplyTab(),
                _buildClipVaultTab(),
                _buildFloatingConfigTab(),
              ],
            ),
          ),

          // Floating Notification Overlay Banner Simulation
          if (_showSimulatedNotification)
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.greenAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _notificationMessage,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                        onPressed: () {
                          setState(() {
                            _showSimulatedNotification = false;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),

          // Interactive Draggable Floating Bubble Simulator
          if (_isOverlayEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Keep within boundaries
                    newX = newX.clamp(0.0, screenSize.width - 60);
                    newY = newY.clamp(0.0, screenSize.height - 150);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                onTap: () {
                  setState(() {
                    _showFloatingDock = !_showFloatingDock;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.smart_button,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Drag Me',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Floating Mini Dock Quick Action Popup
          if (_isOverlayEnabled && _showFloatingDock)
            Positioned(
              left: (_bubblePosition.dx > screenSize.width / 2) ? null : 20,
              right: (_bubblePosition.dx > screenSize.width / 2) ? 20 : null,
              top: _bubblePosition.dy + 65,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quick Context Actions',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.indigo),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showFloatingDock = false;
                              });
                            },
                            child: const Icon(Icons.close, size: 16, color: Colors.grey),
                          )
                        ],
                      ),
                      const Divider(),
                      _buildFloatingDockItem(
                        icon: Icons.paste,
                        label: 'Paste & Format Phone',
                        onTap: () async {
                          ClipboardData? data = await Clipboard.getData('text/plain');
                          if (data?.text != null) {
                            _textToolController.text = data!.text!;
                            _extractPhoneNumbers();
                            setState(() {
                              _currentIndex = 0;
                              _showFloatingDock = false;
                            });
                          }
                        },
                      ),
                      _buildFloatingDockItem(
                        icon: Icons.account_balance,
                        label: 'Copy Bank Details',
                        onTap: () {
                          if (_clips.isNotEmpty) {
                            _copyToClipboard(_clips[0].content, _clips[0].title);
                          }
                          setState(() {
                            _showFloatingDock = false;
                          });
                        },
                      ),
                      _buildFloatingDockItem(
                        icon: Icons.cleaning_services,
                        label: 'Strip Links & UTM',
                        onTap: () async {
                          ClipboardData? data = await Clipboard.getData('text/plain');
                          if (data?.text != null) {
                            _textToolController.text = data!.text!;
                            _cleanAndFormatLinks();
                            setState(() {
                              _currentIndex = 0;
                              _showFloatingDock = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: 'Text Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Quick Replies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_overscan),
            label: 'Overlay Dock',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingDockItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.indigo),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: Smart Text Studio ---
  Widget _buildTextStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Context Text Lab',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste raw text, extract dialable phone numbers, strip tracking parameters, or mask private data.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _textToolController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Paste copied text, messaged links, addresses, or phone numbers here...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            ClipboardData? data = await Clipboard.getData('text/plain');
                            if (data != null && data.text != null) {
                              setState(() {
                                _textToolController.text = data.text!;
                              });
                            }
                          },
                          icon: const Icon(Icons.paste, size: 16),
                          label: const Text('Paste Clip'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _textToolController.clear();
                            _processedResult = '';
                          });
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Quick Transformation Tools',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: _extractPhoneNumbers,
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Extract Phone Numbers'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: _cleanAndFormatLinks,
                icon: const Icon(Icons.link_off, size: 16),
                label: const Text('Strip Link Tracking'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: _maskSensitiveData,
                icon: const Icon(Icons.security, size: 16),
                label: const Text('Mask Private Numbers'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade900, foregroundColor: Colors.white),
              ),
              OutlinedButton(
                onPressed: () => _changeCase('upper'),
                child: const Text('UPPERCASE'),
              ),
              OutlinedButton(
                onPressed: () => _changeCase('lower'),
                child: const Text('lowercase'),
              ),
              OutlinedButton(
                onPressed: () => _changeCase('title'),
                child: const Text('Title Case'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_processedResult.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Processed Output',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(_processedResult, 'Transformed Text'),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy Output'),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
              ),
              child: SelectableText(
                _processedResult,
                style: const TextStyle(fontSize: 14, height: 1.4, fontFamily: 'monospace'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 2: Quick Reply Studio ---
  Widget _buildQuickReplyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Context Quick Reply Studio',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Generate perfectly formatted messages with dynamic fields and tone adjustments instantly.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Category Chips
          const Text('Select Category:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['Banking', 'Polite Decline', 'Price Quote'].map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: Colors.indigo.withOpacity(0.2),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = cat;
                      _setupDefaultQuickReplyFields();
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Tone Selector
          const Text('Select Tone:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: ['Professional', 'Casual', 'Direct'].map((tone) {
              final isSelected = _selectedTone == tone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSelected,
                selectedColor: Colors.teal.withOpacity(0.2),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTone = tone;
                      _generateQuickReply();
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Dynamic Inputs
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _field1Controller,
                    decoration: InputDecoration(
                      labelText: _selectedCategory == 'Banking'
                          ? 'Bank Name'
                          : (_selectedCategory == 'Polite Decline' ? 'Request Title' : 'Item Description'),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _generateQuickReply(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _field2Controller,
                    decoration: InputDecoration(
                      labelText: _selectedCategory == 'Banking'
                          ? 'Account Number'
                          : (_selectedCategory == 'Polite Decline' ? 'Reason for Decline' : 'Price (\$)'),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _generateQuickReply(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _field3Controller,
                    decoration: InputDecoration(
                      labelText: _selectedCategory == 'Banking'
                          ? 'Account Holder Name'
                          : (_selectedCategory == 'Polite Decline' ? 'Alternative Date' : 'Delivery/Extra Notes'),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _generateQuickReply(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preview Card
          Card(
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Generated Response Preview',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.indigo),
                        onPressed: () => _copyToClipboard(_generatedReply, 'Quick Reply'),
                        tooltip: 'Copy Message',
                      )
                    ],
                  ),
                  const Divider(),
                  Text(
                    _generatedReply,
                    style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- TAB 3: Multi-Clip Vault ---
  Widget _buildClipVaultTab() {
    final filteredClips = _clips.where((clip) {
      final matchesFilter = _selectedClipFilter == 'All' || clip.category == _selectedClipFilter;
      final matchesSearch = clip.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          clip.content.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clip Vault & Presets',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 28),
                onPressed: _showAddClipDialog,
              )
            ],
          ),
          const Text(
            'Keep frequently used accounts, directions, and snippets ready to paste anywhere.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search vault clips...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (val) {
              setState(() {});
            },
          ),
          const SizedBox(height: 10),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Banking', 'Delivery', 'Work'].map((cat) {
                final isSelected = _selectedClipFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedClipFilter = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          if (filteredClips.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text('No clips found in this category.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredClips.length,
              itemBuilder: (context, index) {
                final clip = filteredClips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            clip.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                        if (clip.isPinned) const Icon(Icons.push_pin, size: 16, color: Colors.amber),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        clip.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: Colors.indigo),
                          onPressed: () => _copyToClipboard(clip.content, clip.title),
                        ),
                        IconButton(
                          icon: Icon(
                            clip.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              clip.isPinned = !clip.isPinned;
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

  void _showAddClipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Banking';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add New Preset Clip'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Clip Title (e.g., Office Address)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content Snippet',
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
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  setState(() {
                    _clips.add(
                      ClipItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        content: contentController.text,
                        category: category,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                  _triggerSimulatedNotification('New clip added to vault');
                }
              },
              child: const Text('Save Clip'),
            )
          ],
        );
      },
    );
  }

  // --- TAB 4: Overlay & Permission Simulator ---
  Widget _buildFloatingConfigTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Overlay Controls',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure background overlay permissions and simulation behaviors.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Floating Dock Head', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Simulates "Display Over Other Apps" active overlay.'),
                    value: _isOverlayEnabled,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _isOverlayEnabled = val;
                      });
                      _triggerSimulatedNotification(
                        val ? 'Overlay Dock Enabled' : 'Overlay Dock Disabled',
                      );
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Clipboard Banner Monitoring', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Triggers quick floating banner when new copy action occurs.'),
                    value: _isNotificationAllowed,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationAllowed = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Test Context Engine',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simulate Floating Banner Notification',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Test how notifications and instant clip transformations respond in real-time context.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _triggerSimulatedNotification('New Phone Number Detected on Clipboard: +94771234567');
                        },
                        icon: const Icon(Icons.phone_android, size: 16),
                        label: const Text('Simulate Phone Clip'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _triggerSimulatedNotification('Raw Bank Details Cleaned Automatically!');
                        },
                        icon: const Icon(Icons.account_balance_wallet, size: 16),
                        label: const Text('Simulate Bank Clip'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // User Engagement & Time Saved Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Daily Efficiency Metrics',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('18 mins', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Time Saved Today', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('24 Clips', style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Cleaned & Formatted', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
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
}