import 'package:flutter/material.dart';

void main() {
  runApp(const PulseBoardApp());
}

class PulseBoardApp extends StatelessWidget {
  const PulseBoardApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'PulseBoard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const PulseBoardHomeScreen(),
    );
  }
}

class PulseBoardHomeScreen extends StatefulWidget {
  const PulseBoardHomeScreen({super.key});

  @override
  State<PulseBoardHomeScreen> meCreateState() => _PulseBoardHomeScreenState();
}

class _PulseBoardHomeScreenState extends State<PulseBoardHomeScreen> {
  int _activeTabIndex = 0;

  // Global Overlay Simulation State
  bool _isFloatingBubbleEnabled = true;
  bool _hasOverlayPermission = true;
  bool _hasNotificationPermission = true;
  bool _isOverlayDrawerOpen = false;

  // Calculator State
  double _monthlyIncome = 2400.0;
  double _workingHoursPerWeek = 40.0;
  double _itemPrice = 120.0;
  double _discountPercent = 15.0;

  // Text Sanitizer & Tone State
  final TextEditingController _linkController = TextEditingController(
    text: 'https://store.example.com/item/8923?utm_source=social&utm_medium=click&affiliate=9931',
  );
  String _cleanedLink = '';
  final TextEditingController _draftController = TextEditingController(
    text: 'i am late for the meeting today because traffic was very heavy sorry',
  );
  String _selectedTone = 'Professional';
  String _formattedToneOutput = '';

  // Quick Currency Splitter State
  double _billTotal = 85.0;
  int _peopleCount = 3;
  double _tipPercentage = 10.0;

  // Clip Vault Items
  final List<Map<String, String>> _vaultItems = [
    {'title': 'Cleaned Link', 'content': 'https://store.example.com/item/8923', 'tag': 'Link'},
    {'title': 'Client Reply', 'content': 'Dear team, I apologize for the delay due to unexpected traffic.', 'tag': 'Message'},
  ];

  @override
  void initState() {
    super.initState();
    _cleanCurrentLink();
    _generateToneText();
  }

  @override
  void dispose() {
    _linkController.dispose();
    _draftController.dispose();
    super.dispose();
  }

  void _cleanCurrentLink() {
    final rawText = _linkController.text.trim();
    if (rawText.contains('?')) {
      setState(() {
        _cleanedLink = rawText.split('?').first;
      });
    } else {
      setState(() {
        _cleanedLink = rawText;
      });
    }
  }

  void _generateToneText() {
    final input = _draftController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _formattedToneOutput = '';
      });
      return;
    }

    String result = '';
    if (_selectedTone == 'Professional') {
      result = 'Dear Team,\n\nPlease be informed that: "$input". I appreciate your patience.\n\nBest regards.';
    } else if (_selectedTone == 'Friendly') {
      result = 'Hey there! 😊 Just wanted to let you know: $input. Thanks for understanding!';
    } else if (_selectedTone == 'Urgent') {
      result = '⚡ QUICK UPDATE: $input. Please take note immediately.';
    } else {
      result = '🚀 $input ✨ #Update #QuickNotes';
    }

    setState(() {
      _formattedToneOutput = result;
    });
  }

  void _addCurrentToneToVault() {
    if (_formattedToneOutput.isNotEmpty) {
      setState(() {
        _vaultItems.insert(0, {
          'title': '$_selectedTone Draft',
          'content': _formattedToneOutput,
          'tag': 'Tone',
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to Vault!')),
      );
    }
  }

  // Life Cost Calculations
  double get _hourlyWage {
    final weeklyHours = _workingHoursPerWeek <= 0 ? 40.0 : _workingHoursPerWeek;
    final monthlyHours = weeklyHours * 4.33;
    return _monthlyIncome / (monthlyHours > 0 ? monthlyHours : 1);
  }

  double get _finalItemPrice {
    final discount = _itemPrice * (_discountPercent / 100.0);
    return _itemPrice - discount;
  }

  double get _hoursOfWorkRequired {
    if (_hourlyWage <= 0) return 0.0;
    return _finalItemPrice / _hourlyWage;
  }

  double get _daysOfWorkRequired {
    final dailyHours = _workingHoursPerWeek / 5.0;
    if (dailyHours <= 0) return 0.0;
    return _hoursOfWorkRequired / dailyHours;
  }

  String get _impulseRiskLevel {
    final hours = _hoursOfWorkRequired;
    if (hours > 20) return 'HIGH IMPULSE RISK';
    if (hours > 8) return 'MEDIUM IMPULSE RISK';
    return 'LOW IMPULSE RISK';
  }

  Color get _impulseRiskColor {
    final hours = _hoursOfWorkRequired;
    if (hours > 20) return Colors.red;
    if (hours > 8) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext meContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: const [
            Icon(Icons.bubble_chart, color: Colors.amber),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'PulseBoard Assistant',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFloatingBubbleEnabled ? Icons.layers : Icons.layers_clear,
              color: Colors.amber,
            ),
            tooltip: 'Toggle Overlay Bubble',
            onPressed: () {
              setState(() {
                _isFloatingBubbleEnabled = !_isFloatingBubbleEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFloatingBubbleEnabled
                        ? 'Floating Assistant Enabled!'
                        : 'Floating Assistant Disabled!',
                  ),
                  duration: const Duration(seconds: 1),
                ),
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
              index: _activeTabIndex,
              children: [
                _buildLifeCostTab(),
                _buildSanitizerAndToneTab(),
                _buildSplitAndToolsTab(),
                _buildPermissionsAndSettingsTab(),
              ],
            ),

            // Simulated Floating Drawer Overlay
            if (_isFloatingBubbleEnabled && _isOverlayDrawerOpen)
              Positioned(
                bottom: 80,
                right: 16,
                left: 16,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo[900],
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bolt, color: Colors.amber),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'PulseBoard Heads-Up Assistant',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                              onPressed: () {
                                setState(() {
                                  _isOverlayDrawerOpen = false;
                                });
                              },
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white70),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.work, size: 16, color: Colors.indigo),
                              label: Text('Work Hours: ${_hoursOfWorkRequired.toStringAsFixed(1)}h'),
                              backgroundColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _activeTabIndex = 0;
                                  _isOverlayDrawerOpen = false;
                                });
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.cleaning_services, size: 16, color: Colors.indigo),
                              label: const Text('Clean URL'),
                              backgroundColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _activeTabIndex = 1;
                                  _isOverlayDrawerOpen = false;
                                });
                              },
                            ),
                            ActionChip(
                              avatar: const Icon(Icons.calculate, size: 16, color: Colors.indigo),
                              label: Text('Split: \$${(_billTotal / _peopleCount).toStringAsFixed(1)}/p'),
                              backgroundColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _activeTabIndex = 2;
                                  _isOverlayDrawerOpen = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Simulated Floating Assistant Bubble Button
            if (_isFloatingBubbleEnabled)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  heroTag: 'floatingAssistantBtn',
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  icon: const Icon(Icons.bubble_chart),
                  label: Text(_isOverlayDrawerOpen ? 'Close Bar' : 'Quick Assist'),
                  onPressed: () {
                    setState(() {
                      _isOverlayDrawerOpen = !_isOverlayDrawerOpen;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTabIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _activeTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history),
            label: 'Life Cost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high),
            label: 'Sanitizer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Split Pay',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest),
            label: 'Assistant',
          ),
        ],
      ),
    );
  }

  // TAB 1: VIRAL LIFE COST & DEAL ANALYZER
  Widget _buildLifeCostTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LIFE-COST & IMPULSE ANALYZER',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Is this item really worth your precious life hours?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your current hourly rate is calculated at \$${_hourlyWage.toStringAsFixed(2)}/hr.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Inputs Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Financial Benchmarks',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Monthly Net Income: \$${_monthlyIncome.toStringAsFixed(0)}',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _monthlyIncome,
                    min: 500,
                    max: 10000,
                    divisions: 190,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _monthlyIncome = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Work Hours / Week: ${_workingHoursPerWeek.toStringAsFixed(0)}h',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _workingHoursPerWeek,
                    min: 10,
                    max: 80,
                    divisions: 70,
                    activeColor: Colors.indigo,
                    onChanged: (val) {
                      setState(() {
                        _workingHoursPerWeek = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Target Item Inputs
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2. Target Purchase Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Item Price: \$${_itemPrice.toStringAsFixed(0)}',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _itemPrice,
                    min: 5,
                    max: 2000,
                    divisions: 399,
                    activeColor: Colors.deepPurple,
                    onChanged: (val) {
                      setState(() {
                        _itemPrice = val;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Discount / Coupon: ${_discountPercent.toStringAsFixed(0)}%',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _discountPercent,
                    min: 0,
                    max: 75,
                    divisions: 75,
                    activeColor: Colors.deepPurple,
                    onChanged: (val) {
                      setState(() {
                        _discountPercent = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Result Card (Life-Cost Breakdown)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _impulseRiskColor, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: _impulseRiskColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _impulseRiskLevel,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _impulseRiskColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${_hoursOfWorkRequired.toStringAsFixed(1)} hrs',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Exact Work Hours',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 40, width: 1, color: Colors.grey[300]),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${_daysOfWorkRequired.toStringAsFixed(1)} days',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Full Work Days',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.indigo, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'After a ${_discountPercent.toStringAsFixed(0)}% discount, you pay \$${_finalItemPrice.toStringAsFixed(2)}. You must work ${_hoursOfWorkRequired.toStringAsFixed(1)} hours solely to afford this!',
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // TAB 2: LINK SANITIZER & TONE TRANSFORMER
  Widget _buildSanitizerAndToneTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: URL Tracker Cleaner
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.cleaning_services, color: Colors.indigo),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'URL Tracker & Junk Cleaner',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Strips UTM tags, affiliate tracking, and privacy-invading url queries instantly.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _linkController,
                    onChanged: (_) => _cleanCurrentLink(),
                    decoration: const InputDecoration(
                      labelText: 'Paste Raw Web / Store Link',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cleaned Privacy-Safe URL:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          _cleanedLink.isEmpty ? 'No link provided' : _cleanedLink,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Clean Link'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Clean URL Copied to Clipboard!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section 2: Text Tone Transformer
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.psychology, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'AI Message Tone Transformer',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Reformat messy thoughts into clean, presentable message drafts.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _draftController,
                    maxLines: 3,
                    onChanged: (_) => _generateToneText(),
                    decoration: const InputDecoration(
                      labelText: 'Type Quick Rough Thought',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: ['Professional', 'Friendly', 'Urgent', 'Casual Emoji'].map((tone) {
                      final isSelected = _selectedTone == tone;
                      return ChoiceChip(
                        label: Text(tone),
                        selected: isSelected,
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedTone = tone;
                            });
                            _generateToneText();
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple.shade200),
                    ),
                    child: Text(
                      _formattedToneOutput,
                      softWrap: true,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.bookmark_add, size: 16),
                        label: const Text('Save to Vault'),
                        onPressed: _addCurrentToneToVault,
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy Draft'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Formatted Draft Copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // TAB 3: SPLIT PAY & SAVED VAULT
  Widget _buildSplitAndToolsTab() {
    final perPerson = (_billTotal * (1 + _tipPercentage / 100)) / (_peopleCount > 0 ? _peopleCount : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Split Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.monetization_on, color: Colors.teal),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Quick Bill & Tip Splitter',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total Bill: \$${_billTotal.toStringAsFixed(0)}',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _billTotal,
                    min: 10,
                    max: 500,
                    divisions: 98,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _billTotal = val;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Split Between: $_peopleCount People',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _peopleCount.toDouble(),
                    min: 1,
                    max: 15,
                    divisions: 14,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _peopleCount = val.toInt();
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tip Amount: ${_tipPercentage.toStringAsFixed(0)}%',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _tipPercentage = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Each Person Pays:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${perPerson.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Saved Clip Vault
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Clip Vault',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Chip(
                label: Text('${_vaultItems.length} items'),
                backgroundColor: Colors.indigo[50],
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_vaultItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('No clips saved yet. Add drafts or links above!'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _vaultItems.length,
              itemBuilder: (context, index) {
                final item = _vaultItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo[100],
                      child: Icon(
                        item['tag'] == 'Link' ? Icons.link : Icons.message,
                        color: Colors.indigo,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item['title'] ?? 'Clip',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item['content'] ?? '',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _vaultItems.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // TAB 4: FLOATING ASSISTANT & PERMISSIONS HUB
  Widget _buildPermissionsAndSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo[800],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune, color: Colors.amber, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating Screen Assistant',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Grant permissions to keep PulseBoard available over other apps for rapid micro-calculations.',
                        softWrap: true,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Permission Controls
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Allows floating bubble quick access overlay'),
                  secondary: const Icon(Icons.layers, color: Colors.indigo),
                  value: _hasOverlayPermission,
                  onChanged: (val) {
                    setState(() {
                      _hasOverlayPermission = val;
                      _isFloatingBubbleEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Smart Notification Head'),
                  subtitle: const Text('Receive quick life-cost alerts & copy reminders'),
                  secondary: const Icon(Icons.notifications, color: Colors.indigo),
                  value: _hasNotificationPermission,
                  onChanged: (val) {
                    setState(() {
                      _hasNotificationPermission = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Floating Assistant Button'),
                  subtitle: const Text('Show interactive bubble widget on screen'),
                  secondary: const Icon(Icons.bubble_chart, color: Colors.amber),
                  value: _isFloatingBubbleEnabled,
                  onChanged: (val) {
                    setState(() {
                      _isFloatingBubbleEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tips Card
          Card(
            elevation: 2,
            color: Colors.amber[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '💡 Why Keep Floating Assistant On?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'When browsing shopping apps or social media, tap the floating bubble to instantly calculate how many work hours an item costs or to clean shared links before sending to friends!',
                    softWrap: true,
                    style: TextStyle(fontSize: 12, height: 1.4, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}