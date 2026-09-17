import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatefulWidget {
  const FloatDeckApp({Key? key}) : super(key: key);

  @override
  State<FloatDeckApp> createState() => _FloatDeckAppState();
}

class _FloatDeckAppState extends State<FloatDeckApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0FF12151E),
      ),
      home: MainDeckScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ClipboardItem {
  final String id;
  final String text;
  final DateTime timestamp;
  bool isPinned;
  final String category;

  ClipboardItem({
    required this.id,
    required this.text,
    required this.timestamp,
    this.isPinned = false,
    this.category = 'General',
  });
}

class FloatingPinNote {
  final String title;
  final String content;
  final Color badgeColor;

  FloatingPinNote({
    required this.title,
    required this.content,
    required this.badgeColor,
  });
}

class MainDeckScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainDeckScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _selectedTabIndex = 0;
  bool _overlayPermissionGranted = true;
  bool _floatingBubbleActive = true;
  bool _floatingNotificationsEnabled = true;

  // Floating Bubble Position
  Offset _bubblePosition = const Offset(20, 200);
  bool _isBubbleExpanded = false;

  // Data Store
  final List<ClipboardItem> _clipboardStack = [
    ClipboardItem(
      id: '1',
      text: 'Order Tracking #98421049 - Arriving Thursday via Express Mail',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isPinned: true,
      category: 'Codes',
    ),
    ClipboardItem(
      id: '2',
      text: 'Support Email: help@serviceportal.org | Direct Line: +1 800 555 0199',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isPinned: false,
      category: 'Contact',
    ),
    ClipboardItem(
      id: '3',
      text: 'WiFi Key: TechStudio_5G_Pass789#',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isPinned: true,
      category: 'Passwords',
    ),
  ];

  final List<FloatingPinNote> _floatingPins = [
    FloatingPinNote(
      title: 'Grocery Split',
      content: 'John owes \$24.50 | Sarah owes \$18.00',
      badgeColor: Colors.teal,
    ),
    FloatingPinNote(
      title: 'Zoom Meeting',
      content: 'ID: 849 204 1109 | Passcode: 2024',
      badgeColor: Colors.deepPurple,
    ),
  ];

  // Quick Extractor Controllers
  final TextEditingController _extractorController = TextEditingController();
  String _extractedNumbers = '';
  String _extractedEmails = '';
  String _extractedUrls = '';

  // Calculator State
  String _calcDisplay = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;

  // Ambient Sound Player Simulation
  bool _isRainPlaying = false;
  bool _isCafePlaying = false;
  bool _isWhiteNoisePlaying = false;

  @override
  void dispose() {
    _extractorController.dispose();
    super.dispose();
  }

  void _addClipboardSnippet(String text, String category) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardStack.insert(
        0,
        ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text.trim(),
          timestamp: DateTime.now(),
          category: category,
        ),
      );
    });
    _showFloatingNotification('Snippet saved to FloatDeck clipboard!');
  }

  void _showFloatingNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.indigo,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runTextExtractor(String input) {
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final phoneRegex = RegExp(r'(\+\d{1,3}[\s-]?)?\(?\d{3}\)?[\s-]?\d{3}[\s-]?\d{4}');
    final urlRegex = RegExp(r'https?://[^\s]+');

    final emails = emailRegex.allMatches(input).map((m) => m.group(0)).join(', ');
    final phones = phoneRegex.allMatches(input).map((m) => m.group(0)).join(', ');
    final urls = urlRegex.allMatches(input).map((m) => m.group(0)).join(', ');

    setState(() {
      _extractedEmails = emails.isNotEmpty ? emails : 'No email found';
      _extractedNumbers = phones.isNotEmpty ? phones : 'No phone numbers found';
      _extractedUrls = urls.isNotEmpty ? urls : 'No links found';
    });
  }

  void _onCalcNumPress(String val) {
    setState(() {
      if (_calcDisplay == '0' || _shouldResetDisplay) {
        _calcDisplay = val;
        _shouldResetDisplay = false;
      } else {
        _calcDisplay += val;
      }
    });
  }

  void _onCalcOpPress(String op) {
    setState(() {
      _firstOperand = double.tryParse(_calcDisplay) ?? 0;
      _operator = op;
      _shouldResetDisplay = true;
    });
  }

  void _onCalcEqual() {
    final secondOperand = double.tryParse(_calcDisplay) ?? 0;
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case '×':
        result = _firstOperand * secondOperand;
        break;
      case '÷':
        result = secondOperand != 0 ? _firstOperand / secondOperand : 0;
        break;
    }
    setState(() {
      _calcDisplay = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
      _operator = '';
    });
  }

  void _onCalcClear() {
    setState(() {
      _calcDisplay = '0';
      _firstOperand = 0;
      _operator = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Column Layout
            Column(
              children: [
                _buildTopBar(),
                _buildSystemPermissionBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      _buildMultiClipboardTab(),
                      _buildFloatingToolsTab(),
                      _buildTextCleanerExtractorTab(),
                      _buildAmbientSoundTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Simulated Floating Screen Bubble (Draggable Widget Overlay)
            if (_floatingBubbleActive)
              Positioned(
                left: _bubblePosition.dx,
                top: _bubblePosition.dy,
                child: GestureDetecorBubble(
                  isExpanded: _isBubbleExpanded,
                  onTap: () {
                    setState(() {
                      _isBubbleExpanded = !_isBubbleExpanded;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _bubblePosition.dx + details.delta.dx;
                      double newY = _bubblePosition.dy + details.delta.dy;

                      // Clamp inside screen bounds safely
                      newX = newX.clamp(10.0, screenSize.width - 70.0);
                      newY = newY.clamp(60.0, screenSize.height - 120.0);

                      _bubblePosition = Offset(newX, newY);
                    });
                  },
                  onQuickAction: (action) {
                    setState(() {
                      _isBubbleExpanded = false;
                    });
                    _showFloatingNotification('Activated Floating Overlay: $action');
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: widget.isDarkMode ? Colors.white70 : Colors.grey.shade300,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) => setState(() => _selectedTabIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: widget.isDarkMode ? Colors.grey : Colors.black87,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: 'Multi-Copy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Overlay Deck',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cleaning_services),
              label: 'Extractor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volume_up),
              label: 'Ambient Sound',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0FF1A1E2C) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FloatDeck',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _floatingBubbleActive
                      ? '● Screen Bubble Active'
                      : '○ Overlay Standby Mode',
                  style: TextStyle(
                    fontSize: 11,
                    color: _floatingBubbleActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'Add Quick Snippet',
            icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 28),
            onPressed: () => _showAddSnippetDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemPermissionBanner() {
    if (_overlayPermissionGranted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        color: Colors.teal.withOpacity(0.12),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.teal, size: 16),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Display over other apps enabled (System Active)',
                style: TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.w600),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _floatingBubbleActive = !_floatingBubbleActive;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  _floatingBubbleActive ? 'Hide Bubble' : 'Show Bubble',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  // TAB 1: Multi-Clipboard Stack
  Widget _buildMultiClipboardTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Multi-Clipboard History Stack',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.delete_sweep, size: 16),
                    label: const Text('Clear All', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      setState(() {
                        _clipboardStack.clear();
                      });
                      _showFloatingNotification('Clipboard stack cleared');
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Copy snippets across any app without losing prior copied text. Pin important credentials or trackings.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            softWrap: true,
          ),
          const SizedBox(height: 16),
          if (_clipboardStack.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.content_paste_off, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text(
                      'Clipboard Stack Empty',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap "+" above to save custom texts or copy items',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardStack.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _clipboardStack[index];
                return Card(
                  elevation: item.isPinned ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: item.isPinned ? Colors.indigo : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                item.isPinned ? Icons.star : Icons.star_border,
                                color: item.isPinned ? Colors.amber : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  item.isPinned = !item.isPinned;
                                });
                              },
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                              onPressed: () {
                                setState(() {
                                  _clipboardStack.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          item.text,
                          style: const TextStyle(fontSize: 13, height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(Icons.copy, size: 14),
                              label: const Text('Copy', style: TextStyle(fontSize: 11)),
                              onPressed: () {
                                _showFloatingNotification('Copied to system buffer!');
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

  // TAB 2: Overlay Deck & Micro Widgets
  Widget _buildFloatingToolsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Micro-Assistant Deck',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Quick micro-calculators and on-screen sticky pins to reference info while browsing or chatting.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),

          // Calculator Card Widget
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calculate, color: Colors.indigo),
                      const SizedBox(width: 8),
                      const Text(
                        'Floating Screen Calculator',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cleaning_services, size: 18),
                        onPressed: _onCalcClear,
                        tooltip: 'Clear',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.black87 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerRight,
                    child: Text(
                      _calcDisplay,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calculator Buttons Layout
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.3,
                    children: [
                      _calcBtn('7', () => _onCalcNumPress('7')),
                      _calcBtn('8', () => _onCalcNumPress('8')),
                      _calcBtn('9', () => _onCalcNumPress('9')),
                      _calcBtn('÷', () => _onCalcOpPress('÷'), color: Colors.indigo.shade300),
                      _calcBtn('4', () => _onCalcNumPress('4')),
                      _calcBtn('5', () => _onCalcNumPress('5')),
                      _calcBtn('6', () => _onCalcNumPress('6')),
                      _calcBtn('×', () => _onCalcOpPress('×'), color: Colors.indigo.shade300),
                      _calcBtn('1', () => _onCalcNumPress('1')),
                      _calcBtn('2', () => _onCalcNumPress('2')),
                      _calcBtn('3', () => _onCalcNumPress('3')),
                      _calcBtn('-', () => _onCalcOpPress('-'), color: Colors.indigo.shade300),
                      _calcBtn('0', () => _onCalcNumPress('0')),
                      _calcBtn('.', () => _onCalcNumPress('.')),
                      _calcBtn('=', _onCalcEqual, color: Colors.indigo),
                      _calcBtn('+', () => _onCalcOpPress('+'), color: Colors.indigo.shade300),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Active Floating Notes / Sticky Pins Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'On-Screen Sticky Pins',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.indigo),
                onPressed: _showCreatePinDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _floatingPins.length,
            itemBuilder: (context, idx) {
              final pin = _floatingPins[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: pin.badgeColor.withOpacity(0.2),
                    child: Icon(Icons.push_pin, color: pin.badgeColor, size: 18),
                  ),
                  title: Text(
                    pin.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    softWrap: true,
                  ),
                  subtitle: Text(
                    pin.content,
                    style: const TextStyle(fontSize: 12),
                    softWrap: true,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _floatingPins.removeAt(idx);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _calcBtn(String label, VoidCallback onPressed, {Color? color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? (widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
        foregroundColor: color != null ? Colors.white : (widget.isDarkMode ? Colors.white : Colors.black),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  // TAB 3: Text Formatter & Extractor
  Widget _buildTextCleanerExtractorTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Text Extractor & Cleaner',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Paste long messages to strip formatting or automatically extract phone numbers, emails, and links.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _extractorController,
            maxLines: 4,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Paste messy raw text here...',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              _runTextExtractor(val);
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Extract Entities'),
                onPressed: () => _runTextExtractor(_extractorController.text),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text('Strip Spaces'),
                onPressed: () {
                  final cleaned = _extractorController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                  _extractorController.text = cleaned;
                  _runTextExtractor(cleaned);
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.text_fields, size: 16),
                label: const Text('UPPERCASE'),
                onPressed: () {
                  _extractorController.text = _extractorController.text.toUpperCase();
                  _runTextExtractor(_extractorController.text);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Extracted Data Results',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildExtractedCard('Phone Numbers', _extractedNumbers, Icons.phone),
          const SizedBox(height: 8),
          _buildExtractedCard('Emails Found', _extractedEmails, Icons.email),
          const SizedBox(height: 8),
          _buildExtractedCard('Web Links', _extractedUrls, Icons.link),
        ],
      ),
    );
  }

  Widget _buildExtractedCard(String label, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.indigo, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    value.isEmpty ? 'None detected' : value,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (value.isNotEmpty && !value.startsWith('No '))
              IconButton(
                icon: const Icon(Icons.copy, size: 16, color: Colors.indigo),
                onPressed: () {
                  _showFloatingNotification('Copied $label to clipboard!');
                },
              ),
          ],
        ),
      ),
    );
  }

  // TAB 4: Ambient Audio Deck (Keep users engaged in active session)
  Widget _buildAmbientSoundTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Focus Ambient Audio Deck',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Play ambient sound layers while multitasking to boost efficiency and concentration.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          _buildAudioTile(
            title: 'Soft Rain Vibe',
            subtitle: 'Calming rain background layer',
            icon: Icons.water_drop,
            isPlaying: _isRainPlaying,
            onToggle: () {
              setState(() {
                _isRainPlaying = !_isRainPlaying;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildAudioTile(
            title: 'Urban Cafe Ambience',
            subtitle: 'Subtle coffee shop chatter & background',
            icon: Icons.local_cafe,
            isPlaying: _isCafePlaying,
            onToggle: () {
              setState(() {
                _isCafePlaying = !_isCafePlaying;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildAudioTile(
            title: 'Deep White Noise',
            subtitle: 'Blocks out household background distractions',
            icon: Icons.graphic_eq,
            isPlaying: _isWhiteNoisePlaying,
            onToggle: () {
              setState(() {
                _isWhiteNoisePlaying = !_isWhiteNoisePlaying;
              });
            },
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.indigo.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.indigo, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'FloatDeck Active Session',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Floating overlays run continuously in background mode.',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPlaying,
    required VoidCallback onToggle,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPlaying ? Colors.indigo : Colors.grey.shade300,
          foregroundColor: isPlaying ? Colors.white : Colors.black,
          child: Icon(icon, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: isPlaying ? Colors.indigo : Colors.grey,
            size: 32,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  void _showAddSnippetDialog() {
    final textController = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Quick Snippet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter text, account #, address...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Category'),
                  items: ['General', 'Codes', 'Passwords', 'Contact', 'Bank Details']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) category = val;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  _addClipboardSnippet(textController.text, category);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Snippet'),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePinDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Sticky Pin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Content / Note',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _floatingPins.add(
                      FloatingPinNote(
                        title: titleController.text,
                        content: contentController.text,
                        badgeColor: Colors.orange,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  _showFloatingNotification('Sticky pin added!');
                }
              },
              child: const Text('Pin on Screen'),
            ),
          ],
        );
      },
    );
  }
}

// Draggable Floating Screen Bubble Simulator Widget
class GestureDetecorBubble extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(DragUpdateDetails) onPanUpdate;
  final Function(String) onQuickAction;

  const GestureDetecorBubble({
    Key? key,
    required this.isExpanded,
    required this.onTap,
    required this.onPanUpdate,
    required this.onQuickAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.indigo.shade600,
          borderRadius: BorderRadius.circular(isExpanded ? 16 : 30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isExpanded
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.layers, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'FloatDeck Quick Actions',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: onTap,
                        child: const Icon(Icons.close, color: Colors.white70, size: 16),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  InkWell(
                    onTap: () => onQuickAction('Multi-Copy Stack Opened'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.content_paste, color: Colors.white, size: 14),
                          SizedBox(width: 8),
                          Text('Paste Last Snippet', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => onQuickAction('Quick Screen Calculator'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calculate, color: Colors.white, size: 14),
                          SizedBox(width: 8),
                          Text('Mini Calculator', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => onQuickAction('Sticky Pin Reader'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.push_pin, color: Colors.white, size: 14),
                          SizedBox(width: 8),
                          Text('View Sticky Pins', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.layers, color: Colors.white, size: 22),
                  SizedBox(width: 4),
                  Icon(Icons.drag_indicator, color: Colors.white70, size: 16),
                ],
              ),
      ),
    );
  }
}