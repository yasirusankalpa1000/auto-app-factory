import 'package:flutter/material.dart';

void main() {
  runApp(const ContextHUDApp());
}

class ContextHUDApp extends StatelessWidget {
  const ContextHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHUDContainer(),
    );
  }
}

class ClipItem {
  final String id;
  final String content;
  final String category; // 'Price', 'Link', 'Note', 'Code'
  final DateTime timestamp;
  bool isFavorite;

  ClipItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
    this.isFavorite = false,
  });
}

class MainHUDContainer extends StatefulWidget {
  const MainHUDContainer({super.key});

  @override
  State<MainHUDContainer> createState() => _MainHUDContainerState();
}

class _MainHUDContainerState extends State<MainHUDContainer> {
  int _currentIndex = 0;
  bool _isOverlayEnabled = true;
  bool _isNotificationHUDActive = true;

  // Floating Bubble Customizer State
  double _bubbleX = 140.0;
  double _bubbleY = 180.0;
  double _bubbleSize = 56.0;
  Color _bubbleColor = Colors.teal;

  // Clipboard Data
  final List<ClipItem> _stashList = [
    ClipItem(
      id: '1',
      content: 'Discount Promo Code: SAVE502025',
      category: 'Code',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isFavorite: true,
    ),
    ClipItem(
      id: '2',
      content: 'Target Price Match Item: \$49.99',
      category: 'Price',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ClipItem(
      id: '3',
      content: 'https://flutter.dev/docs/release/notes',
      category: 'Link',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ClipItem(
      id: '4',
      content: 'Meeting room access code: #8849',
      category: 'Note',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isFavorite: true,
    ),
  ];

  // Micro Decision Engine State
  double _itemPrice = 75.0;
  double _utilityScore = 7.0; // 1 - 10
  double _emotionalScore = 8.0; // 1 - 10
  double _frequencyScore = 5.0; // Days per week

  // Quick Mini Calc State
  String _calcInput = '';
  String _calcResult = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _bubbleColor.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _bubbleColor, width: 1.5),
              ),
              child: Icon(Icons.widgets, color: _bubbleColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ContextHUD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Universal Floating Companion',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isNotificationHUDActive
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _isNotificationHUDActive ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isNotificationHUDActive = !_isNotificationHUDActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isNotificationHUDActive
                        ? 'Notification Floating HUD Enabled'
                        : 'Notification HUD Paused',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardTab(),
          _buildSmartStashTab(),
          _buildDecisionMatrixTab(),
          _buildHUDSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_go),
            label: 'Smart Stash',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Decision HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Overlay Controls',
          ),
        ],
      ),
    );
  }

  // ================= TAB 1: DASHBOARD =================
  Widget _buildDashboardTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Switcher Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isOverlayEnabled
                      ? [const Color(0xFF1E293B), const Color(0xFF0F766E)]
                      : [const Color(0xFF1E293B), const Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isOverlayEnabled ? Colors.teal : Colors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isOverlayEnabled
                                  ? Icons.sensors
                                  : Icons.sensors_off,
                              color: _isOverlayEnabled
                                  ? Colors.tealAccent
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isOverlayEnabled
                                  ? 'Overlay Engine Active'
                                  : 'Overlay Engine Paused',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isOverlayEnabled
                              ? 'Floating bubble standard dynamic HUD ready across apps.'
                              : 'Enable to display quick micro-tools over other apps.',
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOverlayEnabled,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _isOverlayEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Stash Clips',
                    value: '${_stashList.length}',
                    icon: Icons.layers,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Mini Calculator',
                    value: 'Ready',
                    icon: Icons.calculate,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'HUD Preset',
                    value: 'Compact',
                    icon: Icons.widgets,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Interactive Live Floating Canvas Preview
            const Text(
              'Interactive Screen HUD Simulator',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Drag the floating bubble below to test positioning and tap to open quick micro-tools:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white70),
              ),
              child: Stack(
                children: [
                  // Simulated Phone App Background Grid
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(
                              3,
                              (index) => Expanded(
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(10),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                '[ Simulated Active App Surface ]',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Draggable Floating Bubble Simulator
                  if (_isOverlayEnabled)
                    Positioned(
                      left: _bubbleX,
                      top: _bubbleY,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _bubbleX = (_bubbleX + details.delta.dx)
                                .clamp(10.0, 260.0);
                            _bubbleY = (_bubbleY + details.delta.dy)
                                .clamp(10.0, 190.0);
                          });
                        },
                        onTap: () => _showMiniFloatingOverlayDialog(context),
                        child: Container(
                          width: _bubbleSize,
                          height: _bubbleSize,
                          decoration: BoxDecoration(
                            color: _bubbleColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _bubbleColor.withAlpha(150),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bolt,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Calculator Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calculate, color: Colors.tealAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Instant Floating Mini-Calculator',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _calcInput.isEmpty ? 'Type expression...' : _calcInput,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          '=$_calcResult',
                          style: const TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      '7', '8', '9', '+',
                      '4', '5', '6', '-',
                      '1', '2', '3', '*',
                      'C', '0', '=', '/'
                    ].map((btn) {
                      return SizedBox(
                        width: 60,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF334155),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _handleCalcInput(btn),
                          child: Text(
                            btn,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: (btn == 'C')
                                  ? Colors.redAccent
                                  : (btn == '=')
                                      ? Colors.tealAccent
                                      : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _handleCalcInput(String btn) {
    setState(() {
      if (btn == 'C') {
        _calcInput = '';
        _calcResult = '0';
      } else if (btn == '=') {
        try {
          // Simple evaluation parser for mini-calc
          String exp = _calcInput;
          if (exp.contains('+')) {
            var parts = exp.split('+');
            _calcResult =
                (double.parse(parts[0]) + double.parse(parts[1])).toStringAsFixed(2);
          } else if (exp.contains('-')) {
            var parts = exp.split('-');
            _calcResult =
                (double.parse(parts[0]) - double.parse(parts[1])).toStringAsFixed(2);
          } else if (exp.contains('*')) {
            var parts = exp.split('*');
            _calcResult =
                (double.parse(parts[0]) * double.parse(parts[1])).toStringAsFixed(2);
          } else if (exp.contains('/')) {
            var parts = exp.split('/');
            double den = double.parse(parts[1]);
            _calcResult = den != 0
                ? (double.parse(parts[0]) / den).toStringAsFixed(2)
                : 'Error';
          }
        } catch (e) {
          _calcResult = 'Error';
        }
      } else {
        _calcInput += btn;
      }
    });
  }

  // ================= TAB 2: SMART STASH =================
  String _selectedCategoryFilter = 'All';
  final TextEditingController _clipInputController = TextEditingController();

  Widget _buildSmartStashTab() {
    List<ClipItem> filteredList = _stashList.where((item) {
      if (_selectedCategoryFilter == 'All') return true;
      if (_selectedCategoryFilter == 'Favorites') return item.isFavorite;
      return item.category == _selectedCategoryFilter;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Add Clip Input Box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clipInputController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Stash text, price (\$29.99), code, link...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _addNewClip,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'All',
                  'Favorites',
                  'Price',
                  'Link',
                  'Code',
                  'Note'
                ].map((cat) {
                  bool isSelected = _selectedCategoryFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.tealAccent,
                      backgroundColor: const Color(0xFF1E293B),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategoryFilter = cat;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Stash Items List
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.layers_clear, color: Colors.grey.withAlpha(100), size: 48),
                          const SizedBox(height: 12),
                          const Text(
                            'No context items in this category',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: item.isFavorite
                                  ? Colors.amber.withAlpha(100)
                                  : Colors.white70,
                            ),
                          ),
                          child: Row(
                            children: [
                              _getCategoryIcon(item.category),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.content,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.category} • ${_formatTime(item.timestamp)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied: "${item.content}"'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
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

  void _addNewClip() {
    String text = _clipInputController.text.trim();
    if (text.isEmpty) return;

    String cat = 'Note';
    if (text.contains('\$') || RegExp(r'\d+(\.\d{1,2})?').hasMatch(text)) {
      cat = 'Price';
    } else if (text.startsWith('http') || text.contains('.com')) {
      cat = 'Link';
    } else if (RegExp(r'^[A-Z0-9_-]{4,15}\$').hasMatch(text)) {
      cat = 'Code';
    }

    setState(() {
      _stashList.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text,
          category: cat,
          timestamp: DateTime.now(),
        ),
      );
      _clipInputController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved to Smart Stash ($cat)')),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData icon;
    Color color;
    switch (category) {
      case 'Price':
        icon = Icons.monetization_on;
        color = Colors.greenAccent;
        break;
      case 'Link':
        icon = Icons.link;
        color = Colors.blueAccent;
        break;
      case 'Code':
        icon = Icons.qr_code;
        color = Colors.purpleAccent;
        break;
      default:
        icon = Icons.note;
        color = Colors.amberAccent;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // ================= TAB 3: MICRO DECISION HUD =================
  Widget _buildDecisionMatrixTab() {
    // Calculate Buying Sanity Index Score
    // Score Formula = (Utility * 1.2 + Frequency * 1.5) / (ItemPrice / 20 + EmotionalScore * 0.8)
    double rawScore = ((_utilityScore * 1.2) + (_frequencyScore * 1.5)) /
        ((_itemPrice / 25.0) + (_emotionalScore * 0.5));
    double sanityScore = rawScore.clamp(0.0, 10.0);

    String recommendation;
    Color statusColor;
    if (sanityScore >= 6.5) {
      recommendation = 'HIGH VALUE BUY: Highly useful & practical choice!';
      statusColor = Colors.greenAccent;
    } else if (sanityScore >= 4.0) {
      recommendation = 'CONSIDER WAITING 24 HOURS: Moderate impulse risk.';
      statusColor = Colors.amberAccent;
    } else {
      recommendation = 'SKIP PURCHASE: Low long-term utility versus price!';
      statusColor = Colors.redAccent;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro-Decision Evaluator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Instant purchase sanity check before impulse buying online:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Live Decision Gauge Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sanity Index Score',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        '${sanityScore.toStringAsFixed(1)} / 10',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: sanityScore / 10.0,
                    backgroundColor: Colors.white70,
                    color: statusColor,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recommendation,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sliders Controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Item Price:',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '\$${_itemPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _itemPrice,
                    min: 5.0,
                    max: 300.0,
                    divisions: 59,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _itemPrice = val),
                  ),

                  const Divider(color: Colors.white70, height: 24),

                  // Utility Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Practical Utility (1-10):',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '${_utilityScore.toInt()}',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _utilityScore,
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    activeColor: Colors.blueAccent,
                    onChanged: (val) => setState(() => _utilityScore = val),
                  ),

                  const Divider(color: Colors.white70, height: 24),

                  // Usage Frequency Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Estimated Weekly Usage (Days):',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '${_frequencyScore.toInt()} days/wk',
                        style: const TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _frequencyScore,
                    min: 1.0,
                    max: 7.0,
                    divisions: 6,
                    activeColor: Colors.purpleAccent,
                    onChanged: (val) => setState(() => _frequencyScore = val),
                  ),

                  const Divider(color: Colors.white70, height: 24),

                  // Emotional Urge Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Impulse Urge Level (1-10):',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '${_emotionalScore.toInt()}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _emotionalScore,
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    activeColor: Colors.redAccent,
                    onChanged: (val) => setState(() => _emotionalScore = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 4: HUD SETTINGS & CUSTOMIZER =================
  Widget _buildHUDSettingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Overlay Customizer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Personalize floating bubble styling, permissions & quick action shortcuts:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Color Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bubble Theme Color',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Colors.teal,
                      Colors.indigo,
                      Colors.amber,
                      Colors.purple,
                      Colors.deepOrange,
                      Colors.blue,
                    ].map((c) {
                      bool isSelected = _bubbleColor == c;
                      return GestureDetector(
                        onTap: () => setState(() => _bubbleColor = c),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Bubble Size Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Floating Bubble Diameter:',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        '${_bubbleSize.toInt()} px',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _bubbleSize,
                    min: 40.0,
                    max: 72.0,
                    divisions: 8,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _bubbleSize = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // System Permissions Simulation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Required System Permissions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionTile(
                    title: 'Display Over Other Apps',
                    subtitle: 'Allows floating HUD bubble above all mobile apps.',
                    isEnabled: _isOverlayEnabled,
                    onToggle: (val) => setState(() => _isOverlayEnabled = val),
                  ),
                  const Divider(color: Colors.white70),
                  _buildPermissionTile(
                    title: 'Persistent HUD Notification',
                    subtitle: 'Enables quick-access toolbar in notification shade.',
                    isEnabled: _isNotificationHUDActive,
                    onToggle: (val) =>
                        setState(() => _isNotificationHUDActive = val),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                softWrap: true,
              ),
            ],
          ),
        ),
        Switch(
          value: isEnabled,
          activeColor: Colors.tealAccent,
          onChanged: onToggle,
        ),
      ],
    );
  }

  // Mini Overlay Popup Sheet Simulation
  void _showMiniFloatingOverlayDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.tealAccent),
                      SizedBox(width: 8),
                      Text(
                        'Floating ContextHUD Tool',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: Colors.white70),
              const SizedBox(height: 10),
              const Text(
                'Quick Floating Actions:',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.copy,
                    label: 'Quick Copy',
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Latest clip copied to clipboard!')),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.calculate,
                    label: 'Calc HUD',
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.lightbulb,
                    label: 'Decision',
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _currentIndex = 2);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.withAlpha(40),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.teal),
            ),
            child: Icon(icon, color: Colors.tealAccent, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}