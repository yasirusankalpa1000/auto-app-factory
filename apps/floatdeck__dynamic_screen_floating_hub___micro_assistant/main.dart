import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class SnippetItem {
  final String id;
  String text;
  final String category;
  final DateTime createdAt;

  SnippetItem({
    required this.id,
    required this.text,
    required this.category,
    required this.createdAt,
  });
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({super.key});

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentIndex = 0;

  // Floating Overlay States
  bool _isFloatingEnabled = true;
  bool _isNotificationBarEnabled = true;
  bool _isReadingTintActive = false;
  bool _isImpulseGuardActive = true;
  Offset _bubblePosition = const Offset(280, 220);
  bool _isBubbleExpanded = false;

  // Clipboard & Snippets State
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      text: 'https://example.com/item?utm_source=social&utm_medium=click&ref=123',
      category: 'Links',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    SnippetItem(
      id: '2',
      text: 'Meeting Room Passcode: 8849-2021',
      category: 'Code',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  // Sanitizer Inputs
  final TextEditingController _rawTextController = TextEditingController();
  String _cleanedText = '';

  // Decision Spinner
  final List<String> _decisionOptions = ['Do It Now', 'Wait 24 Hours', 'Ask a Friend', 'Skip Completely'];
  String _decisionResult = 'Tap Spin to Decide!';

  @override
  void dispose() {
    _rawTextController.dispose();
    super.dispose();
  }

  void _sanitizeInputText() {
    String text = _rawTextController.text;
    if (text.isEmpty) {
      setState(() => _cleanedText = '');
      return;
    }
    // Remove query params from links
    Uri? uri = Uri.tryParse(text);
    if (uri != null && uri.hasQuery) {
      text = '${uri.scheme}://${uri.host}${uri.path}';
    }
    // Clean multiple spaces and trim
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    setState(() {
      _cleanedText = text;
    });
  }

  void _addSnippet(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text.trim(),
          category: category,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _spinDecision() {
    final random = Random();
    final selected = _decisionOptions[random.nextInt(_decisionOptions.length)];
    setState(() {
      _decisionResult = 'Result: $selected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.teal),
            SizedBox(width: 10),
            Text(
              'FloatDeck Copilot',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFloatingEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isFloatingEnabled ? Colors.tealAccent : Colors.grey,
            ),
            tooltip: 'Toggle Floating Assistant',
            onPressed: () {
              setState(() {
                _isFloatingEnabled = !_isFloatingEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFloatingEnabled
                        ? 'Floating Screen Overlay Enabled'
                        : 'Floating Screen Overlay Paused',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildLiveOverlayCanvas(),
          _buildSnippetShelfTab(),
          _buildSanitizerTab(),
          _buildImpulseAndDecisionTab(),
          _buildSystemPermissionsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Overlay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Shelf',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Scrub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'System',
          ),
        ],
      ),
    );
  }

  // TAB 1: Live Interactive Overlay Simulator Canvas
  Widget _buildLiveOverlayCanvas() {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationSimBanner(),
                const SizedBox(height: 16),
                const Text(
                  'Live Screen Overlay Canvas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Drag the FloatDeck bubble anywhere over your phone screen layout below. Tap it to expand micro-tools directly while using other apps.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                // Phone Screen Preview Container
                Container(
                  height: 380,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _isReadingTintActive
                        ? const Color(0xFF33291A)
                        : const Color(0xFF020617),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isReadingTintActive
                          ? Colors.amber.withOpacity(0.5)
                          : Colors.teal.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Simulated Phone Background Apps UI
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '9:41 AM',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.wifi, size: 16, color: Colors.white70),
                                    SizedBox(width: 6),
                                    Icon(Icons.battery_full, size: 16, color: Colors.white70),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.shopping_bag, color: Colors.orangeAccent),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Browsing Store App... Flash Sale \$49.99',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.chat_bubble, color: Colors.blueAccent),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Chat Message: "Send me the product link!"',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (_isReadingTintActive)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                color: Colors.amber.withOpacity(0.2),
                                child: const Text(
                                  'Reading Focus Light Mode Active',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Floating Draggable Overlay Bubble inside Simulator
                      if (_isFloatingEnabled)
                        Positioned(
                          left: _bubblePosition.dx,
                          top: _bubblePosition.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                double newX = _bubblePosition.dx + details.delta.dx;
                                double newY = _bubblePosition.dy + details.delta.dy;
                                // Keep within boundaries
                                newX = newX.clamp(10.0, 260.0);
                                newY = newY.clamp(10.0, 300.0);
                                _bubblePosition = Offset(newX, newY);
                              });
                            },
                            onTap: () {
                              setState(() {
                                _isBubbleExpanded = !_isBubbleExpanded;
                              });
                            },
                            child: Material(
                              elevation: 8,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.teal, Colors.blueAccent],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.tealAccent.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: Icon(
                                  _isBubbleExpanded ? Icons.close : Icons.layers,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Expanded Dynamic Floating Menu Card
                      if (_isFloatingEnabled && _isBubbleExpanded)
                        Positioned(
                          left: min(_bubblePosition.dx, 120.0),
                          top: min(_bubblePosition.dy + 50, 160.0),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xFF1E293B),
                            child: Container(
                              width: 220,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.tealAccent, width: 1.5),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Float Tools',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.tealAccent,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => setState(() => _isBubbleExpanded = false),
                                        child: const Icon(Icons.close, size: 16, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(color: Colors.white70),
                                  ListTile(
                                    dense: true,
                                    padding: EdgeInsets.zero,
                                    leading: const Icon(Icons.cleaning_services, size: 18, color: Colors.cyanAccent),
                                    title: const Text('Scrub Clipboard', style: TextStyle(fontSize: 12, color: Colors.white)),
                                    onTap: () {
                                      _addSnippet('Scrubbed Link from Floating Assist', 'Quick');
                                      setState(() => _isBubbleExpanded = false);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Clipboard Scrubbed & Saved!'), duration: Duration(seconds: 1)),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    dense: true,
                                    padding: EdgeInsets.zero,
                                    leading: Icon(
                                      Icons.lightbulb,
                                      size: 18,
                                      color: _isReadingTintActive ? Colors.amber : Colors.grey,
                                    ),
                                    title: Text(
                                      _isReadingTintActive ? 'Disable Light Filter' : 'Reading Filter',
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isReadingTintActive = !_isReadingTintActive;
                                        _isBubbleExpanded = false;
                                      });
                                    },
                                  ),
                                  ListTile(
                                    dense: true,
                                    padding: EdgeInsets.zero,
                                    leading: const Icon(Icons.psychology, size: 18, color: Colors.orangeAccent),
                                    title: const Text('Impulse Check', style: TextStyle(fontSize: 12, color: Colors.white)),
                                    onTap: () {
                                      setState(() => _isBubbleExpanded = false);
                                      _showImpulseDialog(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Feature Status Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAxisAlignment.center,
                  children: [
                    FilterChip(
                      selected: _isFloatingEnabled,
                      label: const Text('Floating Overlay On'),
                      onSelected: (v) => setState(() => _isFloatingEnabled = v),
                      selectedColor: Colors.teal.withOpacity(0.3),
                      checkmarkColor: Colors.tealAccent,
                    ),
                    FilterChip(
                      selected: _isReadingTintActive,
                      label: const Text('Warm Tint Filter'),
                      onSelected: (v) => setState(() => _isReadingTintActive = v),
                      selectedColor: Colors.amber.withOpacity(0.3),
                      checkmarkColor: Colors.amberAccent,
                    ),
                    FilterChip(
                      selected: _isImpulseGuardActive,
                      label: const Text('Impulse Guard Active'),
                      onSelected: (v) => setState(() => _isImpulseGuardActive = v),
                      selectedColor: Colors.orange.withOpacity(0.3),
                      checkmarkColor: Colors.orangeAccent,
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

  // Floating Persistent Notification Simulation Banner
  Widget _buildNotificationSimBanner() {
    if (!_isNotificationBarEnabled) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.teal.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'FloatDeck Active Notification Bar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                Text(
                  'Tap options anytime directly from system shade',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _sanitizeInputText();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quick Action Triggered!'), duration: Duration(seconds: 1)),
              );
            },
            child: const Text('Quick Clip', style: TextStyle(color: Colors.tealAccent, fontSize: 12)),
          )
        ],
      ),
    );
  }

  // TAB 2: Multi-Clip Temporary Snippet Shelf
  Widget _buildSnippetShelfTab() {
    final TextEditingController newSnippetController = TextEditingController();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Multi-Clip Snippet Shelf',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Collect temporary text snippets, codes, or URLs you frequently copy back and forth across messaging & browser apps.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            // Quick Add Input Box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newSnippetController,
                    decoration: const InputDecoration(
                      hintText: 'Type or paste quick snippet...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onPressed: () {
                    if (newSnippetController.text.isNotEmpty) {
                      _addSnippet(newSnippetController.text, 'Quick');
                      newSnippetController.clear();
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_snippets.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text('No saved snippets yet on your shelf.', style: TextStyle(color: Colors.grey)),
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
                    color: const Color(0xFF1E293B),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        item.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: Text(
                        'Category: ${item.category} • ${item.createdAt.minute}m ago',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied snippet to phone clipboard!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() {
                                _snippets.removeAt(index);
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
      ),
    );
  }

  // TAB 3: Clipboard Sanitizer & Scrubbing Lab
  Widget _buildSanitizerTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link & Text Scrubbing Lab',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Strip annoying tracking parameters (UTM tags, ref IDs) from URLs and scrub excess linebreaks/spaces before sharing.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rawTextController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Paste raw link or messy text here...',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _sanitizeInputText(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: _sanitizeInputText,
                  icon: const Icon(Icons.cleaning_services, color: Colors.white),
                  label: const Text('Strip Tracking & Clean', style: TextStyle(color: Colors.white)),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _cleanedText = _rawTextController.text.toUpperCase();
                    });
                  },
                  icon: const Icon(Icons.text_fields, color: Colors.tealAccent),
                  label: const Text('UPPERCASE', style: TextStyle(color: Colors.tealAccent)),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _cleanedText = _rawTextController.text.toLowerCase();
                    });
                  },
                  icon: const Icon(Icons.text_fields, color: Colors.tealAccent),
                  label: const Text('lowercase', style: TextStyle(color: Colors.tealAccent)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Scrubbed Output:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.5)),
              ),
              child: Text(
                _cleanedText.isEmpty ? 'Your scrubbed clean text will appear here...' : _cleanedText,
                style: TextStyle(
                  color: _cleanedText.isEmpty ? Colors.grey : Colors.tealAccent,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_cleanedText.isNotEmpty)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  _addSnippet(_cleanedText, 'Cleaned Link');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved scrubbed text to shelf!'), duration: Duration(seconds: 1)),
                  );
                },
                icon: const Icon(Icons.bookmark, color: Colors.white),
                label: const Text('Save to Shelf Deck', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Impulse Guard & Micro Decision Evaluator
  Widget _buildImpulseAndDecisionTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impulse & Micro-Decision Helper',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Avoid impulse online purchases or micro-choice paralysis when stuck deciding daily tasks.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            // Impulse Purchase Guard Banner Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade900.withOpacity(0.6), Colors.deepOrange.shade800.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orangeAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.psychology, color: Colors.orangeAccent),
                      SizedBox(width: 8),
                      Text(
                        'Impulse Purchase Guard',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thinking of buying something online right now? Run a quick 10-second reflection check before tapping buy.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                    onPressed: () => _showImpulseDialog(context),
                    child: const Text('Run 10s Impulse Check', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Micro-Decision Wheel Simulator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.tune, color: Colors.tealAccent),
                      SizedBox(width: 8),
                      Text(
                        'Micro-Decision Selector',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Stuck on what to do next? Spin for an instant objective recommendation.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.tealAccent),
                      ),
                      child: Text(
                        _decisionResult,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: _spinDecision,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Spin Random Decision', style: TextStyle(color: Colors.white)),
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

  // TAB 5: System Permissions & Dynamic Floating Controls
  Widget _buildSystemPermissionsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Settings & Overlay Permissions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Configure system permissions required for the dynamic floating copilot and active notification hub.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF1E293B),
              child: SwitchListTile(
                secondary: const Icon(Icons.layers, color: Colors.tealAccent),
                title: const Text('Display Over Other Apps', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Allows the floating bubble to stay accessible over messaging & shopping apps', style: TextStyle(color: Colors.grey, fontSize: 11)),
                value: _isFloatingEnabled,
                onChanged: (val) {
                  setState(() => _isFloatingEnabled = val);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFF1E293B),
              child: SwitchListTile(
                secondary: const Icon(Icons.notifications_active, color: Colors.tealAccent),
                title: const Text('Persistent Notification Tray', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Keep instant clip & reader actions pinned in your system notification bar', style: TextStyle(color: Colors.grey, fontSize: 11)),
                value: _isNotificationBarEnabled,
                onChanged: (val) {
                  setState(() => _isNotificationBarEnabled = val);
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFF1E293B),
              child: SwitchListTile(
                secondary: const Icon(Icons.psychology, color: Colors.orangeAccent),
                title: const Text('Impulse Guard Delay Overlay', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Triggers a 10-second mindfulness pause when switching to shopping apps', style: TextStyle(color: Colors.grey, fontSize: 11)),
                value: _isImpulseGuardActive,
                onChanged: (val) {
                  setState(() => _isImpulseGuardActive = val);
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info, color: Colors.tealAccent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'FloatDeck runs lightweight in the background without battery drain, keeping your daily phone workflows organized.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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

  // Impulse Guard Modal Dialog
  void _showImpulseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: const [
            Icon(Icons.psychology, color: Colors.orangeAccent),
            SizedBox(width: 8),
            Text('Impulse Check', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Ask yourself before proceeding:', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 12),
            Text('1. Is this purchase planned or spontaneous?', style: TextStyle(color: Colors.white, fontSize: 13)),
            SizedBox(height: 6),
            Text('2. Will I still care about this in 3 days?', style: TextStyle(color: Colors.white, fontSize: 13)),
            SizedBox(height: 6),
            Text('3. Can I save this snippet to my FloatDeck shelf for later?', style: TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Great choice! Saved item for later consideration.'), duration: Duration(seconds: 2)),
              );
            },
            child: const Text('Save for Later', style: TextStyle(color: Colors.tealAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Proceed Anyway', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}