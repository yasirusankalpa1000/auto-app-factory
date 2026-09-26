import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayDeckApp());
}

class OverlayDeckApp extends StatelessWidget {
  const OverlayDeckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDeckScreen(),
    );
  }
}

class MainDeckScreen extends StatefulWidget {
  const MainDeckScreen({Key? key}) : super(key: key);

  @override
  State<MainDeckScreen> createState() => _MainDeckScreenState();
}

class _MainDeckScreenState extends State<MainDeckScreen> {
  int _currentTab = 0;
  bool _isOverlayActive = true;
  bool _permDrawOverlay = true;
  bool _permNotification = true;
  bool _permBatteryOpt = false;

  // Floating Bubble Settings
  Color _bubbleColor = Colors.indigo;
  double _bubbleSize = 56.0;
  Offset _bubblePosition = const Offset(260, 220);
  bool _isHudExpanded = false;

  // Decision Engine State
  final List<String> _decisionChoices = [
    'Ramen / Noodles',
    'Burger & Fries',
    'Rice & Curry',
    'Fresh Salad',
    'Pizza Slice'
  ];
  final TextEditingController _choiceController = TextEditingController();
  bool _isSpinning = false;
  String _selectedDecision = 'Tap SPIN to Decide!';
  final List<String> _decisionHistory = [];

  // Quick Stash Items
  final List<Map<String, String>> _stashList = [
    {'title': 'WiFi Password', 'content': 'SecurePass#2025', 'tag': 'Security'},
    {'title': 'Delivery Note', 'content': 'Gate Code: #4821', 'tag': 'Address'},
    {'title': 'Promo Code', 'content': 'DISCOUNT50NOW', 'tag': 'Codes'},
  ];
  final TextEditingController _stashTitleController = TextEditingController();
  final TextEditingController _stashContentController = TextEditingController();

  // Floating Micro-Calc / Tip Tool State
  double _billAmount = 45.0;
  double _tipPercentage = 15.0;
  int _splitPeople = 2;

  void _spinDecision() {
    if (_decisionChoices.isEmpty || _isSpinning) return;
    setState(() {
      _isSpinning = true;
      _selectedDecision = 'Deciding...';
    });

    int counter = 0;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      counter++;
      final random = Random();
      final randomIndex = random.nextInt(_decisionChoices.length);
      setState(() {
        _selectedDecision = _decisionChoices[randomIndex];
      });

      if (counter >= 18) {
        timer.cancel();
        setState(() {
          _isSpinning = false;
          _decisionHistory.insert(0, '${_decisionChoices[randomIndex]} (${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')})');
        });
      }
    });
  }

  void _addChoice() {
    if (_choiceController.text.trim().isNotEmpty) {
      setState(() {
        _decisionChoices.add(_choiceController.text.trim());
        _choiceController.clear();
      });
    }
  }

  void _addStashItem() {
    if (_stashTitleController.text.trim().isNotEmpty &&
        _stashContentController.text.trim().isNotEmpty) {
      setState(() {
        _stashList.insert(0, {
          'title': _stashTitleController.text.trim(),
          'content': _stashContentController.text.trim(),
          'tag': 'Quick Stash',
        });
        _stashTitleController.clear();
        _stashContentController.clear();
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.indigoAccent),
            SizedBox(width: 10),
            Text(
              'OverlayDeck',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Text(
                  _isOverlayActive ? 'FLOAT ON' : 'OFF',
                  style: TextStyle(
                    color: _isOverlayActive ? Colors.greenAccent : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _isOverlayActive,
                  activeColor: Colors.indigoAccent,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayActive = val;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildFloatingCanvasTab(),
                  _buildDecisionEngineTab(),
                  _buildQuickStashTab(),
                  _buildDockStudioTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.indigo.shade700,
        onDestinationSelected: (idx) {
          setState(() {
            _currentTab = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.touch_app),
            label: 'Float HUD',
          ),
          NavigationDestination(
            icon: Icon(Icons.shuffle),
            label: 'Decisions',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2),
            label: 'Quick Stash',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Dock Studio',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white70),
        ),
        child: Row(
          children: [
            Icon(
              _isOverlayActive ? Icons.check_circle : Icons.warning_amber,
              color: _isOverlayActive ? Colors.greenAccent : Colors.amber,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isOverlayActive
                    ? 'Active Overlay Engine Ready | Tap & Drag Floating Bubble'
                    : 'Floating Assistant Paused | Enable top switch',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'v2.4 Live',
                style: TextStyle(fontSize: 10, color: Colors.indigoAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: LIVE INTERACTIVE OVERLAY CANVAS ---
  Widget _buildFloatingCanvasTab() {
    final calculatedTip = (_billAmount * _tipPercentage) / 100;
    final totalPerPerson = (_billAmount + calculatedTip) / max(1, _splitPeople);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Live Screen Floating Canvas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Simulated interactive overlay preview. Drag floating bubble anywhere!',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 12),

          // Simulated Mobile Device Frame
          Container(
            height: 380,
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.indigo.shade800, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // Simulated Background Mobile Wall
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone_android, size: 48, color: Colors.white70),
                          SizedBox(height: 8),
                          Text(
                            'Active App Running Behind Overlay',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(Browser, Social Feed, Games, etc.)',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Draggable Floating Overlay Widget
                  if (_isOverlayActive)
                    Positioned(
                      left: _bubblePosition.dx,
                      top: _bubblePosition.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            double newX = _bubblePosition.dx + details.delta.dx;
                            double newY = _bubblePosition.dy + details.delta.dy;
                            newX = newX.clamp(10.0, 280.0);
                            newY = newY.clamp(10.0, 310.0);
                            _bubblePosition = Offset(newX, newY);
                          });
                        },
                        onTap: () {
                          setState(() {
                            _isHudExpanded = !_isHudExpanded;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: _bubbleSize,
                          height: _bubbleSize,
                          decoration: BoxDecoration(
                            color: _bubbleColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _bubbleColor.withOpacity(0.6),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _isHudExpanded ? Icons.close : Icons.widgets,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Expanded Mini Floating HUD Panel
                  if (_isOverlayActive && _isHudExpanded)
                    Positioned(
                      left: min(_bubblePosition.dx, 120.0),
                      top: min(_bubblePosition.dy + 60, 160.0),
                      child: Container(
                        width: 210,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.indigo.shade400),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Quick Floating HUD',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigoAccent),
                                ),
                                Icon(Icons.bolt, size: 14, color: Colors.amber),
                              ],
                            ),
                            const Divider(color: Colors.white70, height: 12),
                            Text(
                              'Stash: ${_stashList.isNotEmpty ? _stashList.first['content'] : 'Empty'}',
                              style: const TextStyle(fontSize: 11, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 28),
                                    ),
                                    onPressed: _spinDecision,
                                    child: const Text('Spin Pick', style: TextStyle(fontSize: 10)),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade700,
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 28),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Quick Stash Copied to Floating Clipboard!'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: const Text('Copy Stash', style: TextStyle(fontSize: 10)),
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
            ),
          ),

          const SizedBox(height: 16),

          // Instant Floating Tip & Bill Splitter Widget Card
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calculate, color: Colors.tealAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Floating Live Micro Calculator & Splitter',
                        style: TextStyle(fontSize: 15, FontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bill Amount', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            Slider(
                              value: _billAmount,
                              min: 5.0,
                              max: 200.0,
                              divisions: 39,
                              activeColor: Colors.tealAccent,
                              label: '\$${_billAmount.toStringAsFixed(0)}',
                              onChanged: (v) {
                                setState(() {
                                  _billAmount = v;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${_billAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tip: ${_tipPercentage.toInt()}%', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                            Slider(
                              value: _tipPercentage,
                              min: 0.0,
                              max: 30.0,
                              divisions: 6,
                              activeColor: Colors.amber,
                              onChanged: (v) {
                                setState(() {
                                  _tipPercentage = v;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Split: $_splitPeople',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        onPressed: () {
                          if (_splitPeople > 1) {
                            setState(() {
                              _splitPeople--;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        onPressed: () {
                          setState(() {
                            _splitPeople++;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Per Person:', style: TextStyle(fontSize: 13, color: Colors.white70)),
                      Text(
                        '\$${totalPerPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
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

  // --- TAB 2: MICRO-DECISION ENGINE ---
  Widget _buildDecisionEngineTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Micro-Decision Engine',
                    style: TextStyle(fontSize: 18, FontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Eliminate micro daily decision fatigue instantly',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.indigoAccent),
                onPressed: () {
                  setState(() {
                    _selectedDecision = 'Tap SPIN to Decide!';
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 16),

          // Spin Outcome Hero Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isSpinning
                    ? [Colors.purple.shade900, Colors.indigo.shade900]
                    : [Colors.indigo.shade900, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.indigoAccent.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 36),
                const SizedBox(height: 12),
                Text(
                  _selectedDecision,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _isSpinning ? Colors.amberAccent : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSpinning ? null : _spinDecision,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    _isSpinning ? 'SPINNING...' : 'SPIN DECISION',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Preset Templates Quick Selector
          const Text('Preset Decision Lists:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              ActionChip(
                avatar: const Icon(Icons.restaurant, size: 16),
                label: const Text('Lunch Ideas'),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  setState(() {
                    _decisionChoices.clear();
                    _decisionChoices.addAll(['Ramen', 'Pizza', 'Burger', 'Rice Bowl', 'Salad']);
                    _selectedDecision = 'Lunch Ideas Loaded!';
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.payments, size: 16),
                label: const Text('Who Pays Bill?'),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  setState(() {
                    _decisionChoices.clear();
                    _decisionChoices.addAll(['Person A', 'Person B', 'Split 50/50', 'Winner of RPS']);
                    _selectedDecision = 'Who Pays Loaded!';
                  });
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.task, size: 16),
                label: const Text('Next Micro-Task'),
                backgroundColor: const Color(0xFF1E293B),
                onPressed: () {
                  setState(() {
                    _decisionChoices.clear();
                    _decisionChoices.addAll(['Clear Inbox', 'Water Plants', '10 Min Walk', 'Code Review']);
                    _selectedDecision = 'Micro-Task Loaded!';
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Current Options List & Custom Add Entry
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Wheel Choices', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _choiceController,
                          decoration: const InputDecoration(
                            hintText: 'Add custom choice...',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.indigoAccent, size: 32),
                        onPressed: _addChoice,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: _decisionChoices.map((choice) {
                      return Chip(
                        label: Text(choice, style: const TextStyle(fontSize: 12)),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          setState(() {
                            _decisionChoices.remove(choice);
                          });
                        },
                        backgroundColor: const Color(0xFF0F172A),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Decision History Log
          if (_decisionHistory.isNotEmpty) ...[
            const Text('Today\'s Decision History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: min(_decisionHistory.length, 4),
              itemBuilder: (ctx, idx) {
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 18, color: Colors.indigoAccent),
                  title: Text(_decisionHistory[idx], style: const TextStyle(fontSize: 13)),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // --- TAB 3: QUICK STASH MATRIX ---
  Widget _buildQuickStashTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Quick Clipboard & Micro Stash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Temporary codes & texts floating ready', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => _showAddStashDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Item', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stash Grid
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stashList.length,
            itemBuilder: (context, index) {
              final item = _stashList[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade800,
                    child: const Icon(Icons.inventory_2, color: Colors.indigoAccent, size: 20),
                  ),
                  title: Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(
                    item['content'] ?? '',
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 13),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.white70),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied "${item['content']}" to Clipboard!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _stashList.removeAt(index);
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

  void _showAddStashDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Quick Stash Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _stashTitleController,
              decoration: const InputDecoration(
                labelText: 'Label (e.g. WiFi Pass)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stashContentController,
              decoration: const InputDecoration(
                labelText: 'Content to Copy',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: _addStashItem,
            child: const Text('Save Stash'),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: DOCK STUDIO & PERMISSIONS ---
  Widget _buildDockStudioTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Floating Dock Studio & Permissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Customize floating triggers & system overlay access', style: TextStyle(fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 16),

          // Floating Bubble Color Customizer
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Floating Bubble Theme Color', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildColorPickerCircle(Colors.indigo),
                      _buildColorPickerCircle(Colors.teal),
                      _buildColorPickerCircle(Colors.amber),
                      _buildColorPickerCircle(Colors.deepOrange),
                      _buildColorPickerCircle(Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Bubble Size: ', style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: Slider(
                          value: _bubbleSize,
                          min: 44.0,
                          max: 72.0,
                          activeColor: _bubbleColor,
                          onChanged: (v) {
                            setState(() {
                              _bubbleSize = v;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // System Permissions Setup Box
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.security, color: Colors.indigoAccent),
                      SizedBox(width: 8),
                      Text('System Service Permissions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Display Over Other Apps', style: TextStyle(fontSize: 13)),
                    subtitle: const Text('Required to draw floating HUD over games & browser', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    value: _permDrawOverlay,
                    activeColor: Colors.indigoAccent,
                    onChanged: (val) {
                      setState(() {
                        _permDrawOverlay = val;
                      });
                    },
                  ),
                  const Divider(color: Colors.white70),
                  SwitchListTile(
                    title: const Text('Persistent Notification Tray Dock', style: TextStyle(fontSize: 13)),
                    subtitle: const Text('Keep instant stash available in top notification bar', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    value: _permNotification,
                    activeColor: Colors.indigoAccent,
                    onChanged: (val) {
                      setState(() {
                        _permNotification = val;
                      });
                    },
                  ),
                  const Divider(color: Colors.white70),
                  SwitchListTile(
                    title: const Text('Bypass Battery Saver Optimization', style: TextStyle(fontSize: 13)),
                    subtitle: const Text('Prevents OS from closing the floating decision engine', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    value: _permBatteryOpt,
                    activeColor: Colors.indigoAccent,
                    onChanged: (val) {
                      setState(() {
                        _permBatteryOpt = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPickerCircle(Color color) {
    final isSelected = _bubbleColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleColor = color;
        });
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withOpacity(0.8),
                blurRadius: 8,
              )
          ],
        ),
        child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
      ),
    );
  }
}