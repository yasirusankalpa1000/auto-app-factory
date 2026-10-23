import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const OverlayDeskApp());
}

class OverlayDeskApp extends StatelessWidget {
  const OverlayDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayDesk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFA8C2E0),
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
  int _currentTabIndex = 0;

  // Floating Overlay Bubble Position
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;
  bool _isBubbleExpanded = false;
  bool _showFloatingNotification = false;
  String _notificationTitle = 'Dynamic Alert Preview';
  String _notificationBody = 'Your live interactive context reminder is active!';

  // Clipboard Vault State
  final List<String> _clipboardSlots = [
    'Meeting link: https://meet.example.com/xyz-abc',
    'Customer Address: 42 Palm Grove, Colombo 03',
    'Account ID: #ACC-98234-X',
  ];
  final TextEditingController _clipInputController = TextEditingController();

  // Text Cleaner & Formatter State
  final TextEditingController _textFormatterController = TextEditingController();
  String _formattedResult = '';

  // Aspect Ratio State
  final TextEditingController _widthController = TextEditingController(text: '1920');
  final TextEditingController _heightController = TextEditingController(text: '1080');
  String _aspectRatioResult = '16:9';

  // Discount Matrix State
  final TextEditingController _originalPriceController = TextEditingController(text: '100');
  final TextEditingController _discountPercentController = TextEditingController(text: '20');
  double _finalPrice = 80.0;
  double _savedAmount = 20.0;

  @override
  void dispose() {
    _clipInputController.dispose();
    _textFormatterController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _originalPriceController.dispose();
    _discountPercentController.dispose();
    super.dispose();
  }

  void _triggerNotification(String title, String body) {
    setState(() {
      _notificationTitle = title;
      _notificationBody = body;
      _showFloatingNotification = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showFloatingNotification = false;
        });
      }
    });
  }

  void _calculateAspectRatio() {
    final double? w = double.tryParse(_widthController.text);
    final double? h = double.tryParse(_heightController.text);
    if (w != null && h != null && h > 0) {
      final double gcdVal = _gcd(w, h);
      final int numW = (w / gcdVal).round();
      final int numH = (h / gcdVal).round();
      setState(() {
        _aspectRatioResult = '$numW:$numH (${(w / h).toStringAsFixed(2)})';
      });
    }
  }

  double _gcd(double a, double b) {
    if (b < 0.001) return a;
    return _gcd(b, a % b);
  }

  void _calculateDiscount() {
    final double? price = double.tryParse(_originalPriceController.text);
    final double? discount = double.tryParse(_discountPercentController.text);
    if (price != null && discount != null) {
      final double saved = price * (discount / 100.0);
      setState(() {
        _savedAmount = saved;
        _finalPrice = price - saved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OverlayDesk Studio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: 'Simulate Alert Banner',
            onPressed: () {
              _triggerNotification(
                'Floating Overlay Alert',
                'OverlayDesk is maintaining active background context!',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab View
            IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildClipboardVaultTab(),
                _buildTextStudioTab(),
                _buildQuickToolsTab(),
                _buildNotificationDesignerTab(),
              ],
            ),

            // Simulated Floating Banner Notification Overlay
            if (_showFloatingNotification)
              Positioned(
                top: 10,
                left: 15,
                right: 15,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white70, width: 1),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.bolt, color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _notificationTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _notificationBody,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _showFloatingNotification = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Draggable Floating Smart Context Bubble (In-App Overlay Simulation)
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX = (_bubbleX + details.delta.dx).clamp(0.0, screenSize.width - 60.0);
                    _bubbleY = (_bubbleY + details.delta.dy).clamp(0.0, screenSize.height - 180.0);
                  });
                },
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isBubbleExpanded = !_isBubbleExpanded;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 8,
                              offset: Offset(2, 4),
                            )
                          ],
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
                        child: Icon(
                          _isBubbleExpanded ? Icons.close : Icons.layers,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (_isBubbleExpanded) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: 180,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Floating Context Hub',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.indigo,
                              ),
                            ),
                            const Divider(),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              onPressed: () {
                                if (_clipboardSlots.isNotEmpty) {
                                  Clipboard.setData(ClipboardData(text: _clipboardSlots.first));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Copied top slot to system clipboard!')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy, size: 14),
                              label: const Text('Quick Copy Slot #1', style: TextStyle(fontSize: 11)),
                            ),
                            const SizedBox(height: 6),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              onPressed: () {
                                _triggerNotification(
                                  'Bubble Quick Note',
                                  'Overlay persistent workspace active!',
                                );
                              },
                              icon: const Icon(Icons.bolt, size: 14),
                              label: const Text('Quick Dynamic Alert', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
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
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.content_copy),
            label: 'Clip Vault',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Text Studio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Quick Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alert Designer',
          ),
        ],
      ),
    );
  }

  // TAB 1: Smart Multi-Slot Clipboard Vault
  Widget _buildClipboardVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Smart Multi-Slot Clipboard Vault', Icons.content_copy),
          const SizedBox(height: 8),
          const Text(
            'Keep frequently used snippets, links, and chat details ready to copy instantly without switching apps.',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _clipInputController,
                      decoration: const InputDecoration(
                        hintText: 'Enter text/link to store in vault...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onPressed: () {
                      if (_clipInputController.text.trim().isNotEmpty) {
                        setState(() {
                          _clipboardSlots.insert(0, _clipInputController.text.trim());
                          _clipInputController.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added snippet to Vault!')),
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Active Vault Slots',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (_clipboardSlots.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Vault is empty. Add snippets above!'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardSlots.length,
              itemBuilder: (context, index) {
                final item = _clipboardSlots[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(
                      item,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.indigo),
                          tooltip: 'Copy to Clipboard',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: item));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied slot content!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Remove',
                          onPressed: () {
                            setState(() {
                              _clipboardSlots.removeAt(index);
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

  // TAB 2: Text Cleaner & Social Formatter
  Widget _buildTextStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Text Cleaner & Formatter Studio', Icons.cleaning_services),
          const SizedBox(height: 8),
          const Text(
            'Format text snippets, clean up extra spacing, remove line breaks, or format bullet lists for messaging.',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textFormatterController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Paste messy raw text, chat logs, or item lists here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.space_bar, size: 16),
                label: const Text('Clean Extra Spaces'),
                onPressed: () {
                  final text = _textFormatterController.text;
                  final cleaned = text.replaceAll(RegExp(r'\s+'), ' ').trim();
                  setState(() {
                    _formattedResult = cleaned;
                  });
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.format_list_bulleted, size: 16),
                label: const Text('Format Bullets'),
                onPressed: () {
                  final text = _textFormatterController.text;
                  final lines = text.split('\n').where((l) => l.trim().isNotEmpty);
                  final bulleted = lines.map((l) => '• ${l.trim()}').join('\n');
                  setState(() {
                    _formattedResult = bulleted;
                  });
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('UPPERCASE'),
                onPressed: () {
                  setState(() {
                    _formattedResult = _textFormatterController.text.toUpperCase();
                  });
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.title, size: 16),
                label: const Text('Title Case'),
                onPressed: () {
                  final words = _textFormatterController.text.split(' ');
                  final titleCased = words.map((w) {
                    if (w.isEmpty) return '';
                    return w[0].toUpperCase() + w.substring(1).toLowerCase();
                  }).join(' ');
                  setState(() {
                    _formattedResult = titleCased;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_formattedResult.isNotEmpty) ...[
            const Text(
              'Formatted Result:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: SelectableText(
                _formattedResult,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _formattedResult));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied formatted text!')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Formatted Text'),
            ),
          ],
        ],
      ),
    );
  }

  // TAB 3: Quick Helper Tools (Aspect Ratio & Discount Matrix)
  Widget _buildQuickToolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Aspect Ratio Calculator', Icons.aspect_ratio),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Width (px)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateAspectRatio(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (px)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateAspectRatio(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.indigo.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Calculated Ratio:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _aspectRatioResult,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Discount & Savings Matrix', Icons.monetization_on),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _originalPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Original Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateDiscount(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _discountPercentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateDiscount(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.green.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('You Save:'),
                      Text(
                        '\$${_savedAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Final Pay Price:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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

  // TAB 4: Floating Alert & Notification Designer
  Widget _buildNotificationDesignerTab() {
    final TextEditingController titleCtrl =
        TextEditingController(text: 'Custom Active Reminder');
    final TextEditingController bodyCtrl =
        TextEditingController(text: 'Your current dynamic task is running in focus mode!');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Interactive Alert Studio', Icons.notifications),
          const SizedBox(height: 8),
          const Text(
            'Simulate and design dynamic persistent notification popups and floating context alerts for daily reminders.',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Alert Header Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bodyCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Alert Details Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: () {
              _triggerNotification(
                titleCtrl.text.isEmpty ? 'Notification' : titleCtrl.text,
                bodyCtrl.text.isEmpty ? 'Alert details' : bodyCtrl.text,
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Test Live Dynamic Floating Alert'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Preset Context Alerts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ActionChip(
                avatar: const Icon(Icons.timer, size: 16),
                label: const Text('Focus Break Alert'),
                onPressed: () {
                  _triggerNotification(
                    'Time for a Micro-Break!',
                    'You have been working for 45 minutes straight.',
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.shopping_bag, size: 16),
                label: const Text('Shopping List Stash'),
                onPressed: () {
                  _triggerNotification(
                    'Shopping Stash Active',
                    '3 items remaining in your floating clip vault.',
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.chat, size: 16),
                label: const Text('Quick Reply Ready'),
                onPressed: () {
                  _triggerNotification(
                    'Quick Chat Snippet',
                    'Formatted message ready to paste in WhatsApp.',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}