import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const FloatMateApp());
}

class FloatMateApp extends StatelessWidget {
  const FloatMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12151E),
        primaryColor: Colors.tealAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.deepPurpleAccent,
          surface: Color(0xFF1E2230),
        ),
        cardColor: const Color(0xFF1E2230),
      ),
      home: const FloatMateHomeScreen(),
    );
  }
}

class FloatMateHomeScreen extends StatefulWidget {
  const FloatMateHomeScreen({super.key});

  @override
  State<FloatMateHomeScreen> createState() => _FloatMateHomeScreenState();
}

class _FloatMateHomeScreenState extends State<FloatMateHomeScreen> {
  int _currentTab = 0;
  
  // Floating overlay state
  Offset _bubblePosition = const Offset(20, 180);
  bool _isBubbleActive = true;
  int _interactionCount = 28;
  int _timeSavedMinutes = 45;

  // Context Stash items
  final List<Map<String, String>> _stashList = [
    {
      'title': 'Amazon Deal Price',
      'content': 'Wireless Headphones deal price: \$49.99 (Save 30%)',
      'tag': 'Shopping',
      'time': '10 mins ago'
    },
    {
      'title': 'Delivery Tracking Code',
      'content': 'DHL-TRK-9821402941 - Estimated Arrival: Tomorrow 3 PM',
      'tag': 'Code',
      'time': '1 hr ago'
    },
    {
      'title': 'Meeting Quick Link',
      'content': 'https://meet.example.com/daily-sync-room-882',
      'tag': 'Link',
      'time': '3 hrs ago'
    },
  ];

  // Micro Decision options
  final List<String> _decisionChoices = [
    'Order Healthy Salad',
    'Quick 15 Min Power Walk',
    'Clear Inbox Clutter',
    'Read 5 Pages',
    'Grab Green Tea'
  ];
  String _selectedDecision = 'Tap spin to choose micro-task!';
  bool _isSpinning = false;

  // Text Transformer text controller
  final TextEditingController _textTransformController = TextEditingController(
    text: 'Check out this cool offer: \$129.99 at   https://example.com/sale?ref=123  #cool #shopping',
  );
  String _transformedResult = '';

  // Floating Notification Engine state
  String _customNotificationTitle = 'Active Order Stashed';
  String _customNotificationBody = 'Item price locked at \$19.99';

  @override
  void initState() {
    super.initState();
    _applyTextTransform('Clean Spaces');
  }

  void _applyTextTransform(String mode) {
    String input = _textTransformController.text;
    setState(() {
      if (mode == 'Clean Spaces') {
        _transformedResult = input.replaceAll(RegExp(r'\s+'), ' ').trim();
      } else if (mode == 'UPPERCASE') {
        _transformedResult = input.toUpperCase();
      } else if (mode == 'Extract Dollar Prices') {
        final matches = RegExp(r'\$\d+(\.\d{1,2})?').allMatches(input);
        final prices = matches.map((m) => m.group(0)).join(', ');
        _transformedResult = prices.isEmpty ? 'No dollar values found.' : 'Extracted Prices: $prices';
      } else if (mode == 'Extract URLs') {
        final matches = RegExp(r'https?://[^\s]+').allMatches(input);
        final urls = matches.map((m) => m.group(0)).join('\n');
        _transformedResult = urls.isEmpty ? 'No URLs found.' : urls;
      }
      _interactionCount++;
    });
  }

  void _spinDecisionWheel() {
    if (_decisionChoices.isEmpty) return;
    setState(() {
      _isSpinning = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      setState(() {
        _selectedDecision = _decisionChoices[random.nextInt(_decisionChoices.length)];
        _isSpinning = false;
        _interactionCount++;
        _timeSavedMinutes += 2;
      });
    });
  }

  void _addStashItem(String title, String content, String tag) {
    if (content.trim().isEmpty) return;
    setState(() {
      _stashList.insert(0, {
        'title': title.isEmpty ? 'Quick Clip' : title,
        'content': content,
        'tag': tag,
        'time': 'Just now',
      });
      _interactionCount++;
    });
  }

  void _showFloatingMenuModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2230),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.touch_app, color: Colors.tealAccent),
                      const SizedBox(width: 10),
                      const Text(
                        'Floating Overlay Controller',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.bolt, color: Colors.white),
                    ),
                    title: const Text('Quick Stash Instant Clip'),
                    subtitle: const Text('Save dollar prices or snippets instantly'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddStashDialog();
                    },
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.casino, color: Colors.white),
                    ),
                    title: const Text('Decision Resolver'),
                    subtitle: const Text('Solve daily fatigue micro-choices'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentTab = 2);
                    },
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.cleaning_services, color: Colors.black),
                    ),
                    title: const Text('Text Sanitizer & URL Extractor'),
                    subtitle: const Text('Format messy clips in 1 click'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _currentTab = 1);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddStashDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = 'Note';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2230),
          title: const Text('Add to Context Stash', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title (e.g. Price Offer, Code)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content or Snippet (\$29.99, URL, Note)',
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
              onPressed: () {
                _addStashItem(
                  titleController.text,
                  contentController.text,
                  selectedTag,
                );
                Navigator.pop(context);
              },
              child: const Text('Save Stash', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          IndexedStack(
            index: _currentTab,
            children: [
              _buildFloatingHubTab(),
              _buildTextStudioTab(),
              _buildDecisionStudioTab(),
              _buildNotificationSandboxTab(),
            ],
          ),

          // Interactive Draggable Floating Bubble Overlay
          if (_isBubbleActive)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: _showFloatingMenuModal,
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.tealAccent, Colors.deepPurpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.widgets,
                        color: Colors.black87,
                        size: 30,
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${_stashList.length}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF181B26),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Text Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Float Alerts',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Hub & Active Stash
  Widget _buildFloatingHubTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.tealAccent,
                  radius: 20,
                  child: Icon(Icons.bolt, color: Colors.black),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FloatMate Studio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        softWrap: true,
                      ),
                      Text(
                        'Interactive Screen Assistant',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isBubbleActive,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() {
                      _isBubbleActive = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live Floating Overlay Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF252A3C), Color(0xFF1E2230)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.touch_app, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Floating Bubble Assistant Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Drag Any Direction',
                          style: TextStyle(
                              color: Colors.tealAccent, fontSize: 10),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem('Interactions', '$_interactionCount'),
                      Container(width: 1, height: 30, color: Colors.white70),
                      _buildMetricItem('Time Saved', '$_timeSavedMinutes mins'),
                      Container(width: 1, height: 30, color: Colors.white70),
                      _buildMetricItem('Stashed Clips', '${_stashList.length}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions Wrap
            const Text(
              'Quick Screen Helpers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAxisAlignment.start,
              children: [
                _buildActionButton(
                  icon: Icons.add_link,
                  label: 'Stash Clip',
                  color: Colors.teal,
                  onTap: _showAddStashDialog,
                ),
                _buildActionButton(
                  icon: Icons.cleaning_services,
                  label: 'Clean Text',
                  color: Colors.deepPurple,
                  onTap: () => setState(() => _currentTab = 1),
                ),
                _buildActionButton(
                  icon: Icons.casino,
                  label: 'Spin Decision',
                  color: Colors.amber,
                  textColor: Colors.black,
                  onTap: () => setState(() => _currentTab = 2),
                ),
                _buildActionButton(
                  icon: Icons.notifications_active,
                  label: 'Floating Alert',
                  color: Colors.blueAccent,
                  onTap: () => setState(() => _currentTab = 3),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Context Stash List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Context Vault (Active Clips)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.tealAccent),
                  onPressed: _showAddStashDialog,
                )
              ],
            ),
            const SizedBox(height: 8),

            // Stash List Items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stashList.length,
              itemBuilder: (context, index) {
                final item = _stashList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.tealAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.content_paste,
                            color: Colors.tealAccent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  item['time'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['content'] ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _stashList.removeAt(index);
                          });
                        },
                      )
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

  // TAB 2: Text Transformer & Sanitizer Studio
  Widget _buildTextStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Text Sanitizer Studio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Paste messy copied links, dollar amounts, or text to clean instantly.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 16),

            // Input TextField
            TextField(
              controller: _textTransformController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Input Text / Snippet',
                labelStyle: TextStyle(color: Colors.tealAccent),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF1E2230),
              ),
            ),
            const SizedBox(height: 12),

            // Transformation Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.start,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.cleaning_services, size: 16),
                  label: const Text('Clean Extra Spaces'),
                  backgroundColor: Colors.teal.withOpacity(0.3),
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () => _applyTextTransform('Clean Spaces'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.attach_money, size: 16),
                  label: const Text('Extract Dollar Prices'),
                  backgroundColor: Colors.deepPurple.withOpacity(0.3),
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () => _applyTextTransform('Extract Dollar Prices'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.link, size: 16),
                  label: const Text('Extract URLs'),
                  backgroundColor: Colors.indigo.withOpacity(0.3),
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () => _applyTextTransform('Extract URLs'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.text_fields, size: 16),
                  label: const Text('UPPERCASE'),
                  backgroundColor: Colors.amber.withOpacity(0.3),
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () => _applyTextTransform('UPPERCASE'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Transformed Output Container
            const Text(
              'Sanitized Result:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
              ),
              child: SelectableText(
                _transformedResult.isEmpty
                    ? 'Result will appear here...'
                    : _transformedResult,
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Send to Stash
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.save_alt, color: Colors.black),
                label: const Text(
                  'Stash Transformed Result',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_transformedResult.isNotEmpty) {
                    _addStashItem('Cleaned Clip', _transformedResult, 'Cleaned');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved to Context Stash!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Micro Decision Resolver
  Widget _buildDecisionStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro Decision Resolver',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Overcome everyday decision fatigue in 1 tap.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 20),

            // Decision Result Display
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isSpinning
                      ? [Colors.deepPurple, Colors.teal]
                      : [const Color(0xFF1E2230), const Color(0xFF252A3C)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.casino, size: 48, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text(
                    _isSpinning ? 'Resolving decision...' : _selectedDecision,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.black),
                    label: const Text(
                      'SPIN CHOICE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _spinDecisionWheel,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Choice Item List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Decision Pool',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_decisionChoices.length} Options',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _decisionChoices.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.tealAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _decisionChoices[index],
                          style: const TextStyle(color: Colors.white),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.grey, size: 18),
                        onPressed: () {
                          setState(() {
                            _decisionChoices.removeAt(index);
                          });
                        },
                      )
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

  // TAB 4: Floating Notification Sandbox
  Widget _buildNotificationSandboxTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Alert Configurator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Configure sticky screen status notifications & dynamic float badges.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              softWrap: true,
            ),
            const SizedBox(height: 16),

            // Live Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active,
                          color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      const Text(
                        'Sticky Overlay Notification Preview',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252A3C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 16,
                          child: Icon(Icons.star, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _customNotificationTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                              ),
                              Text(
                                _customNotificationBody,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title Field
            TextField(
              onChanged: (val) {
                setState(() {
                  _customNotificationTitle = val;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Alert Header Title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF1E2230),
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle Field
            TextField(
              onChanged: (val) {
                setState(() {
                  _customNotificationBody = val;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Alert Details (e.g. Price alert \$25)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF1E2230),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Trigger Simulated Floating Alert',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blueAccent,
                      content: Row(
                        children: [
                          const Icon(Icons.notifications, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '$_customNotificationTitle: $_customNotificationBody',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Dashboard Stats
  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  // Helper Widget for Quick Action Wrap Buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}