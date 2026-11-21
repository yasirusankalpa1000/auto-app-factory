import 'package:flutter/material.dart';

void main() {
  runApp(const BubbleDockApp());
}

class BubbleDockApp extends StatelessWidget {
  const BubbleDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BubbleDock Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.teal,
          surface: Color(0xFF1E293B),
        ),
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

  // Global App States
  bool _overlayPermission = true;
  bool _notificationPermission = true;
  bool _autoClipboard = true;
  bool _isBubbleVisible = true;

  // Floating Bubble Simulated Coordinates
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;
  String _activeWidgetTool = 'Clipboard';

  // Notes List
  final List<Map<String, String>> _notes = [
    {
      'title': 'Wi-Fi Password Home',
      'content': 'SkyNet_5G_Secure#99',
      'tag': 'Important',
      'color': 'teal'
    },
    {
      'title': 'Grocery List',
      'content': 'Almond Milk, Organic Eggs, Oats',
      'tag': 'Personal',
      'color': 'amber'
    },
  ];

  // Clipboard Text
  String _clipboardText =
      "Contact support@bubbledock.io or visit https://bubbledock.io for live updates. Total bill estimate was \$45.50 for order #8821.";

  // Speed Math State
  double _billAmount = 85.0;
  double _tipPercentage = 15.0;
  int _peopleCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildFloatingHubTab(),
                _buildClipboardTab(),
                _buildSpeedMathTab(),
                _buildFloatingNotesTab(),
              ],
            ),
            if (_isBubbleVisible) _buildDraggableFloatingBubble(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Speed Math',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin),
            label: 'Notes HUD',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Hub & System Overlay Controls
  Widget _buildFloatingHubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildPermissionStatusCard(),
          const SizedBox(height: 16),
          _buildFloatingBubbleControls(),
          const SizedBox(height: 16),
          _buildQuickActionGrid(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF115E59)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'BubbleDock Assistant',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Always-on floating utility bubble for instant text cleaning, calculations, and floating notes without app switching.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.security, color: Colors.tealAccent),
              SizedBox(width: 8),
              Text(
                'System Overlay & Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _overlayPermission,
            activeColor: Colors.tealAccent,
            title: const Text('Display Over Other Apps',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text(
                'Allows floating bubble preview over system apps',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            onChanged: (val) => setState(() => _overlayPermission = val),
          ),
          const Divider(color: Colors.white70),
          SwitchListTile(
            value: _notificationPermission,
            activeColor: Colors.tealAccent,
            title: const Text('Floating System Notifications',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Quick actions menu inside notification shade',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            onChanged: (val) => setState(() => _notificationPermission = val),
          ),
          const Divider(color: Colors.white70),
          SwitchListTile(
            value: _autoClipboard,
            activeColor: Colors.tealAccent,
            title: const Text('Auto-Listen Clipboard Text',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Detect links, emails & prices automatically',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            onChanged: (val) => setState(() => _autoClipboard = val),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBubbleControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Floating Bubble HUD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Switch(
                value: _isBubbleVisible,
                activeColor: Colors.tealAccent,
                onChanged: (val) => setState(() => _isBubbleVisible = val),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Drag the floating bubble around the screen area to position your instant workspace tool.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildToolChip('Clipboard'),
              _buildToolChip('Calculator'),
              _buildToolChip('Sticky Note'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolChip(String label) {
    bool isSelected = _activeWidgetTool == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.teal,
      backgroundColor: const Color(0xFF0F172A),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _activeWidgetTool = label;
          });
        }
      },
    );
  }

  Widget _buildQuickActionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instant Screen Utilities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                icon: Icons.cleaning_services,
                title: 'Clean Text',
                subtitle: 'Strip formatting',
                color: Colors.teal,
                onTap: () {
                  setState(() {
                    _clipboardText = _clipboardText.trim().replaceAll(RegExp(r'\s+'), ' ');
                  });
                  _showToast('Text formatting cleaned!');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                icon: Icons.attach_money,
                title: 'Extract Prices',
                subtitle: 'Find amounts',
                color: Colors.green,
                onTap: () {
                  RegExp regExp = RegExp(r'\$\d+(?:\.\d+)?');
                  Iterable<Match> matches = regExp.allMatches(_clipboardText);
                  List<String> prices = matches.map((m) => m.group(0)!).toList();
                  _showToast(prices.isEmpty ? 'No prices found' : 'Found: ${prices.join(', ')}');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart Clipboard & Text Processor
  Widget _buildClipboardTab() {
    int wordCount = _clipboardText.trim().isEmpty
        ? 0
        : _clipboardText.trim().split(RegExp(r'\s+')).length;
    int charCount = _clipboardText.length;
    int lineCount =
        _clipboardText.isEmpty ? 0 : '\n'.allMatches(_clipboardText).length + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Smart Clipboard Suite',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Paste, clean, format, or extract dynamic info live.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Real-time Text Stats Bar
          Row(
            children: [
              _buildStatChip('Words', '$wordCount'),
              const SizedBox(width: 8),
              _buildStatChip('Chars', '$charCount'),
              const SizedBox(width: 8),
              _buildStatChip('Lines', '$lineCount'),
            ],
          ),
          const SizedBox(height: 16),

          // Main Text Box
          TextField(
            maxLines: 6,
            controller: TextEditingController(text: _clipboardText)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: _clipboardText.length),
              ),
            onChanged: (val) {
              _clipboardText = val;
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Type or paste clipboard content here...',
              fillColor: Color(0xFF1E293B),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.white70),
              ),
            ),
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 16),

          // Smart Action Tools
          const Text(
            'Text Formatters & Extractors',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildToolButton(
                icon: Icons.title,
                label: 'UPPERCASE',
                onTap: () {
                  setState(() {
                    _clipboardText = _clipboardText.toUpperCase();
                  });
                },
              ),
              _buildToolButton(
                icon: Icons.text_fields,
                label: 'lowercase',
                onTap: () {
                  setState(() {
                    _clipboardText = _clipboardText.toLowerCase();
                  });
                },
              ),
              _buildToolButton(
                icon: Icons.email,
                label: 'Extract Emails',
                onTap: () {
                  RegExp regExp = RegExp(
                      r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*");
                  Iterable<Match> matches = regExp.allMatches(_clipboardText);
                  List<String> emails = matches.map((m) => m.group(0)!).toList();
                  _showToast(emails.isEmpty ? 'No emails found' : 'Emails: ${emails.join(', ')}');
                },
              ),
              _buildToolButton(
                icon: Icons.link,
                label: 'Extract URLs',
                onTap: () {
                  RegExp regExp = RegExp(
                      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
                  Iterable<Match> matches = regExp.allMatches(_clipboardText);
                  List<String> urls = matches.map((m) => m.group(0)!).toList();
                  _showToast(urls.isEmpty ? 'No URLs found' : 'URLs: ${urls.join(', ')}');
                },
              ),
              _buildToolButton(
                icon: Icons.content_copy,
                label: 'Copy Clean Text',
                onTap: () {
                  _showToast('Copied to system clipboard!');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white70),
        ),
        child: Column(
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
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.tealAccent),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E293B),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // TAB 3: Floating Speed Math & Splitter Overlay
  Widget _buildSpeedMathTab() {
    double totalTip = _billAmount * (_tipPercentage / 100);
    double grandTotal = _billAmount + totalTip;
    double perPerson = _peopleCount > 0 ? grandTotal / _peopleCount : grandTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Speed Math & Splitter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Instantly calculate bills, tips, and group splits on the fly.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Display Result Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Text(
                  'Per Person Share',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  child: Text(
                    '\$${perPerson.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Total Bill',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('\$${_billAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Tip Amount',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('\$${totalTip.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Grand Total',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text('\$${grandTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Bill Input Slider
          Text('Base Bill Amount: \$${_billAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Slider(
            value: _billAmount,
            min: 5,
            max: 500,
            divisions: 99,
            activeColor: Colors.tealAccent,
            inactiveColor: Colors.white70,
            onChanged: (val) => setState(() => _billAmount = val),
          ),
          const SizedBox(height: 12),

          // Tip Percentage Slider
          Text('Tip Percentage: ${_tipPercentage.toInt()}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Slider(
            value: _tipPercentage,
            min: 0,
            max: 30,
            divisions: 30,
            activeColor: Colors.amber,
            inactiveColor: Colors.white70,
            onChanged: (val) => setState(() => _tipPercentage = val),
          ),
          const SizedBox(height: 12),

          // People Splitter Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Split Between People:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_peopleCount > 1) {
                        setState(() => _peopleCount--);
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.tealAccent),
                  ),
                  Text(
                    '$_peopleCount',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _peopleCount++);
                    },
                    icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 4: Floating Sticky Notes Overlay
  Widget _buildFloatingNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Floating Sticky HUD',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pin notes directly onto your floating dock.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                onPressed: _addNewNoteDialog,
                icon: const Icon(Icons.add_circle, color: Colors.tealAccent, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              final note = _notes[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: note['color'] == 'teal'
                        ? Colors.teal.withOpacity(0.5)
                        : Colors.amber.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            note['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: note['color'] == 'teal'
                                ? Colors.teal.withOpacity(0.2)
                                : Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            note['tag'] ?? 'Note',
                            style: TextStyle(
                              fontSize: 10,
                              color: note['color'] == 'teal'
                                  ? Colors.tealAccent
                                  : Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note['content'] ?? '',
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            _showToast('Copied note content to clipboard!');
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.copy, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('Copy',
                                  style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _notes.removeAt(index);
                            });
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.delete, size: 14, color: Colors.redAccent),
                              SizedBox(width: 4),
                              Text('Delete',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.redAccent)),
                            ],
                          ),
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

  // Draggable Dynamic Floating Bubble Overlay Simulator
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubbleX,
      top: _bubbleY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubbleX += details.delta.dx;
            _bubbleY += details.delta.dy;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.teal, Color(0xFF0F766E)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bubble_chart, color: Colors.tealAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                '$_activeWidgetTool Active',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add Note Dialog
  void _addNewNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Sticky Pin Note', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _notes.add({
                    'title': titleController.text,
                    'content': contentController.text,
                    'tag': 'Quick Note',
                    'color': 'teal',
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Pin Note', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}