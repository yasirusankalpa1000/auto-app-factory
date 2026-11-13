import 'package:flutter/material.dart';

void main() {
  runApp(const ContextBarApp());
}

class ContextBarApp extends StatelessWidget {
  const ContextBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextBar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Offset _bubblePosition = const Offset(20, 150);
  bool _isBubbleExpanded = false;
  bool _overlayPermissionEnabled = true;
  bool _floatingNotificationActive = true;

  // Splitter state
  double _billAmount = 45.0;
  int _peopleCount = 3;
  double _tipPercentage = 15.0;

  // Comparison state
  double _dealAPrice = 12.0;
  double _dealAQty = 250.0;
  double _dealBPrice = 18.0;
  double _dealBQty = 400.0;

  // Scratchpad snippets
  final List<String> _snippets = [
    'Delivery Code: #9482-B',
    'WiFi Password: CoffeeShopGuest2025',
    'Meeting Room 4B - 3:30 PM',
  ];
  final TextEditingController _snippetController = TextEditingController();

  // Decision maker
  final List<String> _decisions = [];
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  String _decisionResult = '';

  @override
  void dispose() {
    _snippetController.dispose();
    _optionAController.dispose();
    _optionBController.dispose();
    super.dispose();
  }

  double get _calculatedTip => (_billAmount * _tipPercentage) / 100;
  double get _totalBill => _billAmount + _calculatedTip;
  double get _perPerson => _peopleCount > 0 ? _totalBill / _peopleCount : 0;

  double get _dealAUnitPrice => _dealAQty > 0 ? _dealAPrice / _dealAQty : 0;
  double get _dealBUnitPrice => _dealBQty > 0 ? _dealBPrice / _dealBQty : 0;

  void _addSnippet() {
    if (_snippetController.text.trim().isNotEmpty) {
      setState(() {
        _snippets.insert(0, _snippetController.text.trim());
        _snippetController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Snippet saved to quick stack!')),
      );
    }
  }

  void _deleteSnippet(int index) {
    setState(() {
      _snippets.removeAt(index);
    });
  }

  void _makeDecision() {
    final optA = _optionAController.text.trim();
    final optB = _optionBController.text.trim();
    if (optA.isNotEmpty && optB.isNotEmpty) {
      final choices = [optA, optB];
      choices.shuffle();
      setState(() {
        _decisionResult = choices.first;
        _decisions.insert(0, 'Picked: "${choices.first}" over "${choices.last}"');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      _buildQuickToolsTab(),
                      _buildScratchpadTab(),
                      _buildOverlayDashboardTab(),
                      _buildDecisionRadarTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Floating Mock Notification Bar
            if (_floatingNotificationActive)
              Positioned(
                top: 8,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.widgets, color: Colors.amber, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'ContextBar Dock Active • Live Micro Assistant Ready',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _floatingNotificationActive = false;
                          });
                        },
                        child: const Icon(Icons.close, color: Colors.white70, size: 18),
                      ),
                    ],
                  ),
                ),
              ),

            // Draggable Floating Bubble Assistant Simulation
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetect(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    newX = newX.clamp(10.0, media.width - 70.0);
                    newY = newY.clamp(40.0, media.height - 150.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'floating_bubble',
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        setState(() {
                          _isBubbleExpanded = !_isBubbleExpanded;
                        });
                      },
                      child: Icon(
                        _isBubbleExpanded ? Icons.close : Icons.auto_awesome,
                        color: Colors.white,
                      ),
                    ),
                    if (_isBubbleExpanded)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        width: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Floating Quick Dock',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const Divider(color: Colors.white70),
                            Text(
                              'Tip/Person: \$${_perPerson.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Saved Snippets: ${_snippets.length}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                ActionChip(
                                  label: const Text('Copied OTP', style: TextStyle(fontSize: 10)),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Quick OTP copied to clipboard!')),
                                    );
                                  },
                                ),
                                ActionChip(
                                  label: const Text('Reset', style: TextStyle(fontSize: 10)),
                                  onPressed: () {
                                    setState(() {
                                      _billAmount = 0.0;
                                    });
                                  },
                                ),
                              ],
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
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate, color: Colors.tealAccent),
            label: 'Quick Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy_outlined),
            selectedIcon: Icon(Icons.content_copy, color: Colors.tealAccent),
            label: 'Scratchpad',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers, color: Colors.tealAccent),
            label: 'Overlay Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows_outlined),
            selectedIcon: Icon(Icons.compare_arrows, color: Colors.tealAccent),
            label: 'Decision Radar',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1E293B),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.dashboard, color: Colors.tealAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'ContextBar Utility Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Always-Ready Micro Tools & Instant Overlay',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _floatingNotificationActive ? Icons.notifications_active : Icons.notifications_off,
              color: _floatingNotificationActive ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _floatingNotificationActive = !_floatingNotificationActive;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickToolsTab() {
    final isDealABetter = _dealAUnitPrice > 0 && (_dealAUnitPrice <= _dealBUnitPrice || _dealBUnitPrice == 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Quick Split & Tip
          _buildCardHeader('Instant Bill & Tip Splitter', Icons.monetization_on, Colors.tealAccent),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Base Bill Amount:', style: TextStyle(color: Colors.white70)),
                    Text(
                      '\$${_billAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Slider(
                  value: _billAmount,
                  min: 0,
                  max: 300,
                  divisions: 300,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    setState(() {
                      _billAmount = val;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tip Percentage: ${_tipPercentage.round()}%', style: const TextStyle(color: Colors.white70)),
                    Text('Split Among: $_peopleCount People', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _tipPercentage,
                        min: 0,
                        max: 35,
                        divisions: 35,
                        activeColor: Colors.indigoAccent,
                        onChanged: (val) {
                          setState(() {
                            _tipPercentage = val;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                      onPressed: () {
                        if (_peopleCount > 1) {
                          setState(() {
                            _peopleCount--;
                          });
                        }
                      },
                    ),
                    Text('$_peopleCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                      onPressed: () {
                        setState(() {
                          _peopleCount++;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildValueBadge('Total Bill', '\$${_totalBill.toStringAsFixed(2)}', Colors.white),
                    _buildValueBadge('Tip Amount', '\$${_calculatedTip.toStringAsFixed(2)}', Colors.amber),
                    _buildValueBadge('Per Person', '\$${_perPerson.toStringAsFixed(2)}', Colors.tealAccent),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: Deal & Price Unit Comparator
          _buildCardHeader('Unit Deal Comparator (Value Finder)', Icons.scale, Colors.amber),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Option A', style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Price (\$)',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _dealAPrice = double.tryParse(val) ?? 0.0;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Qty / Grams / Units',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _dealAQty = double.tryParse(val) ?? 0.0;
                              });
                            },
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Cost/Unit: \$${_dealAUnitPrice.toStringAsFixed(4)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Option B', style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Price (\$)',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _dealBPrice = double.tryParse(val) ?? 0.0;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Qty / Grams / Units',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _dealBQty = double.tryParse(val) ?? 0.0;
                              });
                            },
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Cost/Unit: \$${_dealBUnitPrice.toStringAsFixed(4)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDealABetter ? Colors.teal.withOpacity(0.25) : Colors.indigo.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDealABetter ? Colors.teal : Colors.indigoAccent,
                    ),
                  ),
                  child: Text(
                    isDealABetter
                        ? 'VERDICT: Option A offers better value per unit!'
                        : 'VERDICT: Option B offers better value per unit!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScratchpadTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Instant Text Scratchpad', Icons.content_copy, Colors.tealAccent),
          const SizedBox(height: 8),
          const Text(
            'Keep temporary tracking numbers, OTPs, or directions without cluttering your permanent notes app.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _snippetController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Paste temporary snippet here...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _addSnippet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _snippets.isEmpty
                ? const Center(
                    child: Text(
                      'No active snippets in stack.\nAdd quick notes to dock them floatingly!',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _snippets.length,
                    itemBuilder: (context, index) {
                      final item = _snippets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white70),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.pin_end, color: Colors.amber, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.tealAccent, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Copied: "$item"')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                              onPressed: () => _deleteSnippet(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Display Overlay & Permission Companion', Icons.layers, Colors.tealAccent),
          const SizedBox(height: 8),
          const Text(
            'Control floating dock behavior, instant top-bar widgets, and system overlay readiness.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.teal,
                  title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Simulates persistent floating bubble access across system UI', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  value: _overlayPermissionEnabled,
                  onChanged: (val) {
                    setState(() {
                      _overlayPermissionEnabled = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70),
                SwitchListTile(
                  activeColor: Colors.teal,
                  title: const Text('Top Bar Notification Dock', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Shows live context notification bar on screen top', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  value: _floatingNotificationActive,
                  onChanged: (val) {
                    setState(() {
                      _floatingNotificationActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildCardHeader('Active Floating Dock Features', Icons.widgets, Colors.amber),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureBadge('Draggable Bubble', Icons.drag_indicator, Colors.teal),
              _buildFeatureBadge('Quick Tip Calc', Icons.calculate, Colors.indigo),
              _buildFeatureBadge('OTP Auto Copier', Icons.phonelink_ring, Colors.amber),
              _buildFeatureBadge('Zero Overflow UI', Icons.screen_search_desktop, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionRadarTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('A/B Micro-Decision Radar', Icons.compare_arrows, Colors.amber),
          const SizedBox(height: 8),
          const Text(
            'Can\'t decide between two daily options? Type them down and let ContextBar decide instantly!',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _optionAController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Option A (e.g. Eat Salad)',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _optionBController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Option B (e.g. Eat Burger)',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _makeDecision,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Make Fast Decision'),
            ),
          ),
          if (_decisionResult.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.tealAccent),
              ),
              child: Column(
                children: [
                  const Text('RECOMMENDED CHOICE', style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    _decisionResult,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Text('Recent Decisions Log', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: _decisions.isEmpty
                ? const Center(
                    child: Text('No decision log yet.', style: TextStyle(color: Colors.white70)),
                  )
                : ListView.builder(
                    itemCount: _decisions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.check_circle_outline, color: Colors.tealAccent, size: 18),
                        title: Text(_decisions[index], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildValueBadge(String label, String value, Color valColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: valColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFeatureBadge(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}