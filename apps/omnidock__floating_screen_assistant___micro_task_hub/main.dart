import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OmniDock Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global State for App Features
  double _hourlyWage = 25.0;
  double _savedImpulseMoney = 145.0;
  int _timeSavedMinutes = 42;

  final List<Map<String, String>> _clipboardItems = [
    {
      'title': 'Delivery Address',
      'content': '742 Evergreen Terrace, Suite 4B, Springfield',
      'tag': 'Address',
      'time': '10 mins ago'
    },
    {
      'title': 'Meeting Zoom Code',
      'content': 'https://zoom.us/j/9876543210?pwd=omni',
      'tag': 'Links',
      'time': '1 hr ago'
    },
    {
      'title': 'Discount Coupon',
      'content': 'SAVE50NOW',
      'tag': 'Codes',
      'time': '3 hrs ago'
    },
  ];

  void _addClipboardItem(String title, String content, String tag) {
    setState(() {
      _clipboardItems.insert(0, {
        'title': title,
        'content': content,
        'tag': tag,
        'time': 'Just now',
      });
    });
  }

  void _deleteClipboardItem(int index) {
    setState(() {
      _clipboardItems.removeAt(index);
    });
  }

  void _recordSavedImpulse(double amount) {
    setState(() {
      _savedImpulseMoney += amount;
      _timeSavedMinutes += 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FloatingDockStudioPage(
        savedMoney: _savedImpulseMoney,
        timeSaved: _timeSavedMinutes,
      ),
      ImpulseRadarPage(
        hourlyWage: _hourlyWage,
        onWageChanged: (newWage) => setState(() => _hourlyWage = newWage),
        onImpulseSaved: _recordSavedImpulse,
      ),
      ClipboardVaultPage(
        items: _clipboardItems,
        onAddItem: _addClipboardItem,
        onDeleteItem: _deleteClipboardItem,
      ),
      OverlayPermissionPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white70, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1A1A24),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Floating Dock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Value Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              label: 'Micro Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.security),
              label: 'Permissions',
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: FLOATING DOCK STUDIO & LIVE PREVIEW
// -----------------------------------------------------------------------------
class FloatingDockStudioPage extends StatefulWidget {
  final double savedMoney;
  final int timeSaved;

  const FloatingDockStudioPage({
    Key? key,
    required this.savedMoney,
    required this.timeSaved,
  }) : super(key: key);

  @override
  State<FloatingDockStudioPage> createState() => _FloatingDockStudioPageState();
}

class _FloatingDockStudioPageState extends State<FloatingDockStudioPage> {
  bool _isOverlayActive = true;
  bool _showQuickCalc = true;
  bool _showMicroNotes = true;
  bool _showValueRadar = true;
  bool _showSmartPaste = true;

  double _bubbleX = 260.0;
  double _bubbleY = 180.0;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Summary Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'OmniDock Live Status',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Switch(
                      value: _isOverlayActive,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) {
                        setState(() {
                          _isOverlayActive = val;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              val
                                  ? 'Floating Overlay Service Started'
                                  : 'Floating Overlay Suspended',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Impulse Money Saved',
                        '\$${widget.savedMoney.toStringAsFixed(0)}',
                        Icons.savings,
                        Colors.tealAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricTile(
                        'App Switch Time Saved',
                        '${widget.timeSaved} mins',
                        Icons.bolt,
                        Colors.amberAccent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Interactive Phone Screen Preview',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Drag the floating bubble around the virtual phone screen to test system responsiveness.',
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Simulated Phone Screen
          Center(
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurpleAccent, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    // Simulated background apps
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Any Active App (Shopping / Browser / Chat)',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List.generate(
                                6,
                                (i) => Container(
                                  width: 60,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Floating Interactive Dock Bubble
                    if (_isOverlayActive)
                      Positioned(
                        left: _bubbleX,
                        top: _bubbleY,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _bubbleX += details.delta.dx;
                              _bubbleY += details.delta.dy;
                              // Bound position within phone frame
                              _bubbleX = _bubbleX.clamp(10.0, 260.0);
                              _bubbleY = _bubbleY.clamp(10.0, 220.0);
                            });
                          },
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(_isExpanded ? 16 : 30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black87,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: _isExpanded
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.stars, color: Colors.amberAccent, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            'OmniDock',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(color: Colors.white70, height: 12),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (_showValueRadar)
                                            _buildMiniIconButton(Icons.monetization_on, 'Radar'),
                                          if (_showSmartPaste)
                                            _buildMiniIconButton(Icons.content_paste, 'Paste'),
                                          if (_showQuickCalc)
                                            _buildMiniIconButton(Icons.calculate, 'Calc'),
                                          if (_showMicroNotes)
                                            _buildMiniIconButton(Icons.edit_note, 'Notes'),
                                        ],
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                                      SizedBox(width: 4),
                                      Text(
                                        'Dock',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Customize Floating Dock Tools',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          // Customization Options
          _buildToggleTile(
            'Work-Hours Value Radar',
            'Convert prices on screen to working hours instantly',
            Icons.schedule,
            _showValueRadar,
            (v) => setState(() => _showValueRadar = v),
          ),
          _buildToggleTile(
            'Smart Micro-Clipboard',
            '1-Tap floating access to copied snippets & codes',
            Icons.content_copy,
            _showSmartPaste,
            (v) => setState(() => _showSmartPaste = v),
          ),
          _buildToggleTile(
            'Quick Floating Calculator',
            'Floating mini-math bubble without leaving current app',
            Icons.calculate,
            _showQuickCalc,
            (v) => setState(() => _showQuickCalc = v),
          ),
          _buildToggleTile(
            'Instant Temporary Notes',
            'Save scratchpad text that auto-deletes in 24 hrs',
            Icons.edit_note,
            _showMicroNotes,
            (v) => setState(() => _showMicroNotes = v),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMiniIconButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white70,
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.white70),
          )
        ],
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      color: const Color(0xFF1E1E2A),
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.withOpacity(0.3),
          child: Icon(icon, color: Colors.deepPurpleAccent),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: Switch(
          value: value,
          activeColor: Colors.deepPurpleAccent,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: IMPULSE BUY & WORK-HOUR VALUE RADAR
// -----------------------------------------------------------------------------
class ImpulseRadarPage extends StatefulWidget {
  final double hourlyWage;
  final Function(double) onWageChanged;
  final Function(double) onImpulseSaved;

  const ImpulseRadarPage({
    Key? key,
    required this.hourlyWage,
    required this.onWageChanged,
    required this.onImpulseSaved,
  }) : super(key: key);

  @override
  State<ImpulseRadarPage> createState() => _ImpulseRadarPageState();
}

class _ImpulseRadarPageState extends State<ImpulseRadarPage> {
  final TextEditingController _priceController = TextEditingController(text: '85');
  final TextEditingController _wageController = TextEditingController();

  double _calculatedHours = 0.0;
  bool _showFrictionQuiz = false;
  int _regretScore = 0;

  @override
  void initState() {
    super.initState();
    _wageController.text = widget.hourlyWage.toStringAsFixed(0);
    _calculateWorkHours();
  }

  void _calculateWorkHours() {
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final double wage = double.tryParse(_wageController.text) ?? 1.0;
    setState(() {
      _calculatedHours = wage > 0 ? price / wage : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.monetization_on, color: Colors.tealAccent, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Work-Hours Value Radar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Stop impulse buys instantly! See how many hours of life you must trade for any purchase.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Inputs Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _wageController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Your Hourly Wage (\$)  ',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          prefixIcon: Icon(Icons.work, color: Colors.tealAccent),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          final newW = double.tryParse(val) ?? 15.0;
                          widget.onWageChanged(newW);
                          _calculateWorkHours();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Item Price (\$) ',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          prefixIcon: Icon(Icons.shopping_cart, color: Colors.amberAccent),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => _calculateWorkHours(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Calculation Result Badge
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'REAL COST IN LIFE WORKING HOURS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${_calculatedHours.toStringAsFixed(1)} Hours',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Equivalent to working approx ${(_calculatedHours / 8).toStringAsFixed(1)} full work shifts!',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Impulse Friction Checklist
          const Text(
            'Impulse Decision Friction Gate',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            color: const Color(0xFF1E1E2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Regret Quiz:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  _buildFrictionCheck('Will you still use this item in 30 days?', 1),
                  _buildFrictionCheck('Are you buying because of stress or boredom?', 2),
                  _buildFrictionCheck('Can you wait 24 hours before pressing buy?', 3),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.shield, color: Colors.white),
                      label: const Text(
                        'I decided NOT to buy! Save Money',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        final price = double.tryParse(_priceController.text) ?? 0.0;
                        if (price > 0) {
                          widget.onImpulseSaved(price);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.teal,
                              content: Text(
                                'Awesome! You saved \$${price.toStringAsFixed(2)} and kept your life hours!',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFrictionCheck(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: MICRO-CLIPBOARD VAULT
// -----------------------------------------------------------------------------
class ClipboardVaultPage extends StatefulWidget {
  final List<Map<String, String>> items;
  final Function(String, String, String) onAddItem;
  final Function(int) onDeleteItem;

  const ClipboardVaultPage({
    Key? key,
    required this.items,
    required this.onAddItem,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  State<ClipboardVaultPage> createState() => _ClipboardVaultPageState();
}

class _ClipboardVaultPageState extends State<ClipboardVaultPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedTag = 'Address';

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Save Quick Micro-Snippet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Snippet Title (e.g., Home Address)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Content / Text / Link / Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['Address', 'Links', 'Codes', 'Notes'].map((tag) {
                  final isSel = _selectedTag == tag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSel,
                    selectedColor: Colors.deepPurpleAccent,
                    onSelected: (val) {
                      if (val) setState(() => _selectedTag = tag);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty) {
                      widget.onAddItem(
                        _titleController.text,
                        _contentController.text,
                        _selectedTag,
                      );
                      _titleController.clear();
                      _contentController.clear();
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save to Micro-Vault', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Micro-Clipboard Vault',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Instant 1-tap copy snippets available over any screen',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('New', style: TextStyle(color: Colors.white)),
                onPressed: _showAddModal,
              )
            ],
          ),
          const SizedBox(height: 16),

          if (widget.items.isEmpty)
            Container(
              height: 200,
              center: const Center(
                child: Text('No saved snippets yet. Tap + New to add!', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Card(
                  color: const Color(0xFF1E1E2A),
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white70),
                  ),
                  child: ListTile,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['tag'] ?? 'General',
                          style: const TextStyle(fontSize: 10, color: Colors.deepPurpleAccent),
                        ),
                      )
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        item['content'] ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['time'] ?? '',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied "${item['title']}" to clipboard!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () => widget.onDeleteItem(index),
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
}

// Extension placeholder helper for Center layout safety inside ListView
extension ContainerExtension on Container {
  Widget center({required Widget child}) {
    return Center(child: child);
  }
}

// -----------------------------------------------------------------------------
// TAB 4: OVERLAY PERMISSION & DOCK SETUP
// -----------------------------------------------------------------------------
class OverlayPermissionPage extends StatefulWidget {
  const OverlayPermissionPage({Key? key}) : super(key: key);

  @override
  State<OverlayPermissionPage> createState() => _OverlayPermissionPageState();
}

class _OverlayPermissionPageState extends State<OverlayPermissionPage> {
  bool _overlayPermissionGranted = true;
  bool _notificationPermissionGranted = true;
  bool _autoStartGranted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.security, color: Colors.deepPurpleAccent, size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'System Permissions & Setup',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'To keep the dynamic dynamic floating bubble available over other apps, enable permissions below.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Permission Cards
          _buildPermissionCard(
            title: 'Display Over Other Apps',
            description: 'Required to show floating dock bubble on top of web browsers & shopping apps.',
            icon: Icons.layers,
            isEnabled: _overlayPermissionGranted,
            onToggle: (val) => setState(() => _overlayPermissionGranted = val),
          ),
          const SizedBox(height: 10),
          _buildPermissionCard(
            title: 'Floating Notification Access',
            description: 'Allows instant snippet copying from Android status notification drawer.',
            icon: Icons.notifications_active,
            isEnabled: _notificationPermissionGranted,
            onToggle: (val) => setState(() => _notificationPermissionGranted = val),
          ),
          const SizedBox(height: 10),
          _buildPermissionCard(
            title: 'Background Auto-Start',
            description: 'Keeps OmniDock ready automatically whenever phone reboots.',
            icon: Icons.power_settings_new,
            isEnabled: _autoStartGranted,
            onToggle: (val) => setState(() => _autoStartGranted = val),
          ),
          const SizedBox(height: 20),

          // Utility Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amberAccent, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Why Users Keep OmniDock Active Daily',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Zero friction: Copy prices and calculate life hours in 2 seconds.\n'
                  '• Prevents regret: Save hundreds of dollars from impulse online purchases.\n'
                  '• Always accessible: Floating dock stays quietly on screen side.',
                  style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPermissionCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled ? Colors.deepPurpleAccent.withOpacity(0.5) : Colors.white70,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isEnabled ? Colors.deepPurple : Colors.grey.shade800,
            child: Icon(icon, color: isEnabled ? Colors.white : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            activeColor: Colors.deepPurpleAccent,
            onChanged: onToggle,
          )
        ],
      ),
    );
  }
}