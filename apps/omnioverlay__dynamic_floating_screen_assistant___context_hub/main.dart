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

class ClipboardItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;

  ClipboardItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
  });
}

class DecisionOption {
  String name;
  double score;
  DecisionOption({required this.name, required this.score});
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;

  // Floating Overlay State
  bool _isOverlayEnabled = true;
  bool _isNotificationEnabled = true;
  bool _isDimmerActive = false;
  double _dimmerOpacity = 0.3;
  
  // Draggable Floating Bubble Position
  double _bubbleX = 20.0;
  double _bubbleY = 180.0;
  bool _isBubbleExpanded = false;

  // Quick Calc State
  String _calcDisplay = '0';
  String _calcEquation = '';

  // Clipboard Vault State
  final List<ClipboardItem> _clipboardList = [
    ClipboardItem(
      id: '1',
      title: 'WiFi Password Home',
      content: 'SecurePass_2025!\$',
      category: 'Passwords',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ClipboardItem(
      id: '2',
      title: 'Delivery Address',
      content: 'No. 45/2, Green Avenue, Tech City, Sector 4',
      category: 'Addresses',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ClipboardItem(
      id: '3',
      title: 'Meeting Link',
      content: 'https://meet.jit.si/ProductiveTeamSync2025',
      category: 'Links',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Micro-Decision State
  final TextEditingController _decisionTitleController = TextEditingController(text: "Which Laptop to Buy?");
  List<DecisionOption> _decisionOptions = [
    DecisionOption(name: "Option A (Ultra Portable)", score: 7.5),
    DecisionOption(name: "Option B (Gaming & Power)", score: 8.8),
    DecisionOption(name: "Option C (Budget Friendly)", score: 6.2),
  ];
  String _winningDecision = "";

  // Sticky Notification Builder
  final TextEditingController _notifTitleController = TextEditingController();
  final TextEditingController _notifBodyController = TextEditingController();
  final List<Map<String, String>> _activeNotifications = [
    {'title': 'Grocery List Reminder', 'body': 'Milk, Bread, Eggs, Coffee beans'},
    {'title': 'Call Bank Support', 'body': 'Card inquiry reference: #98321'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Screen
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: _buildCurrentTabContent(),
                ),
                _buildBottomNavigationBar(),
              ],
            ),
          ),

          // Screen Dimmer Overlay Simulation
          if (_isDimmerActive)
            IgnorePointer(
              ignoring: true,
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.black.withOpacity(_dimmerOpacity),
              ),
            ),

          // Floating Assistant Drag-and-Drop Head (Interactive Canvas)
          if (_isOverlayEnabled)
            Positioned(
              left: _bubbleX,
              top: _bubbleY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _bubbleX += details.delta.dx;
                    _bubbleY += details.delta.dy;
                    
                    // Clamp bounds
                    if (_bubbleX < 0) _bubbleX = 0;
                    if (_bubbleX > size.width - 60) _bubbleX = size.width - 60;
                    if (_bubbleY < 40) _bubbleY = 40;
                    if (_bubbleY > size.height - 120) _bubbleY = size.height - 120;
                  });
                },
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade600,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isBubbleExpanded ? Icons.close : Icons.widgets,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    if (_isBubbleExpanded) ...[
                      const SizedBox(height: 8),
                      _buildFloatingQuickMenu(),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade500,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.layers, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'OmniOverlay',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Dynamic Assistant & Smart Pocket Canvas',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
                  color: _isOverlayEnabled ? Colors.tealAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isOverlayEnabled = !_isOverlayEnabled;
                  });
                },
                tooltip: 'Toggle Floating Head',
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick Status Badges
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMiniStatusChip(
                  icon: Icons.layers,
                  label: _isOverlayEnabled ? 'Overlay Active' : 'Overlay Disabled',
                  active: _isOverlayEnabled,
                  onTap: () {
                    setState(() {
                      _isOverlayEnabled = !_isOverlayEnabled;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildMiniStatusChip(
                  icon: Icons.notifications_active,
                  label: _isNotificationEnabled ? 'Sticky Alerts On' : 'Alerts Off',
                  active: _isNotificationEnabled,
                  onTap: () {
                    setState(() {
                      _isNotificationEnabled = !_isNotificationEnabled;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _buildMiniStatusChip(
                  icon: Icons.brightness_6,
                  label: _isDimmerActive ? 'Night Dimmer On' : 'Night Dimmer Off',
                  active: _isDimmerActive,
                  onTap: () {
                    setState(() {
                      _isDimmerActive = !_isDimmerActive;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatusChip({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.indigo.withOpacity(0.3) : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.indigoAccent : Colors.grey.shade800,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: active ? Colors.tealAccent : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingQuickMenu() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade400, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Quick Overlay Tools',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
          const Divider(color: Colors.grey, height: 16),
          _buildQuickMenuItem(
            icon: Icons.calculate,
            title: 'Floating Quick Calc',
            onTap: () {
              setState(() {
                _isBubbleExpanded = false;
                _currentTabIndex = 0;
              });
            },
          ),
          _buildQuickMenuItem(
            icon: Icons.copy,
            title: 'Instant Clipboard Stacker',
            onTap: () {
              setState(() {
                _isBubbleExpanded = false;
                _currentTabIndex = 1;
              });
            },
          ),
          _buildQuickMenuItem(
            icon: Icons.psychology,
            title: 'Micro-Decision Solver',
            onTap: () {
              setState(() {
                _isBubbleExpanded = false;
                _currentTabIndex = 2;
              });
            },
          ),
          _buildQuickMenuItem(
            icon: Icons.brightness_6,
            title: _isDimmerActive ? 'Disable Screen Tint' : 'Enable Screen Tint',
            onTap: () {
              setState(() {
                _isDimmerActive = !_isDimmerActive;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.indigoAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildToolsAndCalcTab();
      case 1:
        return _buildClipboardTab();
      case 2:
        return _buildDecisionTab();
      case 3:
        return _buildNotificationBuilderTab();
      default:
        return _buildToolsAndCalcTab();
    }
  }

  // TAB 1: QUICK CALC & SCREEN TINT CONTROL
  Widget _buildToolsAndCalcTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Helper Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, Colors.blue.shade900],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade400),
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app, color: Colors.amberAccent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Multitask Seamlessly',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Drag the floating widget head anywhere on screen for instant overlays while messaging or shopping.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Screen Dimmer Settings Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.brightness_2, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Night Reading Screen Tint',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isDimmerActive,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _isDimmerActive = val;
                        });
                      },
                    ),
                  ],
                ),
                if (_isDimmerActive) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Tint Intensity: ${(_dimmerOpacity * 100).toInt()}%',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Slider(
                    value: _dimmerOpacity,
                    min: 0.1,
                    max: 0.8,
                    activeColor: Colors.indigoAccent,
                    onChanged: (val) {
                      setState(() {
                        _dimmerOpacity = val;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mini Quick Calculator Section
          const Text(
            'Quick Split & Tax Math Overlay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade700),
            ),
            child: Column(
              children: [
                // Display Screen
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _calcEquation,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _calcDisplay,
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Calc Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.3,
                  children: [
                    _buildCalcBtn('C', color: Colors.deepOrange.shade700),
                    _buildCalcBtn('/', color: Colors.indigo.shade600),
                    _buildCalcBtn('*', color: Colors.indigo.shade600),
                    _buildCalcBtn('-', color: Colors.indigo.shade600),
                    _buildCalcBtn('7'),
                    _buildCalcBtn('8'),
                    _buildCalcBtn('9'),
                    _buildCalcBtn('+', color: Colors.indigo.shade600),
                    _buildCalcBtn('4'),
                    _buildCalcBtn('5'),
                    _buildCalcBtn('6'),
                    _buildCalcBtn('='),
                    _buildCalcBtn('1'),
                    _buildCalcBtn('2'),
                    _buildCalcBtn('3'),
                    _buildCalcBtn('0'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcBtn(String label, {Color? color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFF334155),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => _handleCalcInput(label),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleCalcInput(String key) {
    setState(() {
      if (key == 'C') {
        _calcDisplay = '0';
        _calcEquation = '';
      } else if (key == '=') {
        try {
          // Simple calc evaluation logic
          String finalEq = _calcEquation + _calcDisplay;
          _calcEquation = '$finalEq =';
          
          double res = _evaluateSimpleExpression(finalEq);
          _calcDisplay = res.toStringAsFixed(res.truncateToDouble() == res ? 0 : 2);
        } catch (e) {
          _calcDisplay = 'Error';
        }
      } else if (key == '+' || key == '-' || key == '*' || key == '/') {
        _calcEquation = '$_calcDisplay $key ';
        _calcDisplay = '0';
      } else {
        if (_calcDisplay == '0') {
          _calcDisplay = key;
        } else {
          _calcDisplay += key;
        }
      }
    });
  }

  double _evaluateSimpleExpression(String expr) {
    final parts = expr.split(' ');
    if (parts.length < 3) return double.tryParse(_calcDisplay) ?? 0.0;
    
    double num1 = double.tryParse(parts[0]) ?? 0;
    String op = parts[1];
    double num2 = double.tryParse(parts[2]) ?? 0;

    switch (op) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        return num2 != 0 ? num1 / num2 : 0;
      default:
        return 0;
    }
  }

  // TAB 2: SMART CLIPBOARD VAULT
  Widget _buildClipboardTab() {
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
                    'Smart Clipboard Stack',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Access copied snippets across apps instantly',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showAddSnippetDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_clipboardList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: const [
                    Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No saved snippets yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _clipboardList.length,
              itemBuilder: (context, index) {
                final item = _clipboardList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18, color: Colors.indigoAccent),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied "${item.title}" to clipboard!'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _clipboardList.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.content,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showAddSnippetDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Snippet to Vault', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title / Label',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Text Content',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade600),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _clipboardList.insert(
                    0,
                    ClipboardItem(
                      id: DateTime.now().toString(),
                      title: titleCtrl.text,
                      content: contentCtrl.text,
                      category: category,
                      timestamp: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // TAB 3: MICRO-DECISION MATRIX
  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Engine',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Cannot decide on purchases, food, or routes? Rate criteria & calculate.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _decisionTitleController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Dilemma Title',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Options to Compare',
                      style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.indigoAccent),
                      onPressed: () {
                        setState(() {
                          _decisionOptions.add(DecisionOption(
                            name: "Option ${_decisionOptions.length + 1}",
                            score: 5.0,
                          ));
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _decisionOptions.length,
                  itemBuilder: (context, index) {
                    final opt = _decisionOptions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: opt.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (val) {
                                    opt.name = val;
                                  },
                                ),
                              ),
                              Text(
                                opt.score.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _decisionOptions.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          Slider(
                            value: opt.score,
                            min: 1.0,
                            max: 10.0,
                            divisions: 18,
                            activeColor: Colors.indigoAccent,
                            onChanged: (val) {
                              setState(() {
                                opt.score = val;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (_decisionOptions.isNotEmpty) {
                        _decisionOptions.sort((a, b) => b.score.compareTo(a.score));
                        setState(() {
                          _winningDecision = _decisionOptions.first.name;
                        });
                      }
                    },
                    icon: const Icon(Icons.auto_awesome, color: Colors.amberAccent),
                    label: const Text(
                      'Calculate Best Choice',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                if (_winningDecision.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade900.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.tealAccent),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'RECOMMENDED OPTION',
                          style: TextStyle(fontSize: 10, color: Colors.tealAccent, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _winningDecision,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: STICKY NOTIFICATION OVERLAY BUILDER
  Widget _buildNotificationBuilderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sticky System Reminders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Pin micro-memos to your top status drawer so you never forget.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _notifTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Notification Header',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notifBodyController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Quick Message / Code / Number',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (_notifTitleController.text.isNotEmpty) {
                        setState(() {
                          _activeNotifications.insert(0, {
                            'title': _notifTitleController.text,
                            'body': _notifBodyController.text,
                          });
                          _notifTitleController.clear();
                          _notifBodyController.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sticky Notification Pinned!'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.push_pin, color: Colors.white, size: 18),
                    label: const Text(
                      'Pin to Notification Tray',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Active Pinned Sticky Badges',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activeNotifications.length,
            itemBuilder: (context, index) {
              final notif = _activeNotifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade800),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.amber, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notif['body'] ?? '',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _activeNotifications.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(top: BorderSide(color: Colors.grey.shade800, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Clipboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decisions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Sticky Alerts',
          ),
        ],
      ),
    );
  }
}