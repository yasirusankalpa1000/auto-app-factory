import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHudApp());
}

class SmartHudApp extends StatelessWidget {
  const SmartHudApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartHUD Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E2C),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainHudScreen(),
    );
  }
}

class MainHudScreen extends StatefulWidget {
  const MainHudScreen({Key? key}) : super(key: key);

  @override
  State<MainHudScreen> createState() => _MainHudScreenState();
}

class _MainHudScreenState extends State<MainHudScreen> {
  int _currentIndex = 0;
  
  // Floating HUD Overlay State
  bool _hudOverlayActive = true;
  bool _screenTintActive = false;
  double _tintOpacity = 0.25;
  Color _tintColor = Colors.amber;
  Offset _bubblePosition = const Offset(20, 120);
  
  // Dynamic Sticky Notes State
  final List<String> _stickyNotes = [
    '⚡ Remember to pay electricity bill by 5 PM',
    '🛒 Buy milk, eggs & coffee beans',
    '📞 Call back client regarding proposal',
  ];
  final TextEditingController _noteController = TextEditingController();

  // Smart Reply Generator State
  String _inputMessage = '';
  String _generatedReply = '';
  String _selectedTone = 'Professional';
  final TextEditingController _msgController = TextEditingController();

  // Micro Decision Engine State
  double _necessityScore = 5.0;
  double _affordabilityScore = 5.0;
  double _longTermValueScore = 5.0;
  double _itemPrice = 50.0;
  final TextEditingController _priceController = TextEditingController(text: '50.00');

  // Quick Math / Splitter State
  double _billAmount = 120.0;
  int _peopleCount = 3;
  double _tipPercentage = 10.0;
  final TextEditingController _billController = TextEditingController(text: '120.00');

  @override
  void dispose() {
    _noteController.dispose();
    _msgController.dispose();
    _priceController.dispose();
    _billController.dispose();
    super.dispose();
  }

  void _addStickyNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _stickyNotes.add(_noteController.text.trim());
        _noteController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sticky Note pinned to Floating HUD!')),
      );
    }
  }

  void _generateSmartReply() {
    if (_msgController.text.trim().isEmpty) return;
    final text = _msgController.text.trim();
    setState(() {
      if (_selectedTone == 'Professional') {
        _generatedReply = 'Thank you for reaching out. Regarding "$text", I will review the details and get back to you shortly.';
      } else if (_selectedTone == 'Polite Decline') {
        _generatedReply = 'I appreciate you bringing "$text" to my attention, but unfortunately I won\'t be able to commit to this right now.';
      } else if (_selectedTone == 'Casual / Friendly') {
        _generatedReply = 'Hey! Got it regarding "$text". Sounds awesome, let\'s catch up soon!';
      } else {
        _generatedReply = 'Understood regarding "$text". Let\'s finalize this as soon as possible.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Screen Tint Simulation Overlay
          if (_screenTintActive)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: _tintColor.withOpacity(_tintOpacity),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                // Top Floating Status Banner
                _buildSystemNotificationBanner(),

                // Main Navigation Screen Content
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      _buildFloatingHudStudioTab(),
                      _buildSmartReplyTab(),
                      _buildMicroDecisionTab(),
                      _buildQuickUtilityTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Dynamic Bubble Widget
          if (_hudOverlayActive)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetectingWidget(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                child: _buildDraggableFloatingBubble(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Smart Reply',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision Wheel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Split & Math',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemNotificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _hudOverlayActive ? Colors.teal.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            _hudOverlayActive ? Icons.sensors : Icons.sensors_off,
            color: _hudOverlayActive ? Colors.tealAccent : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _hudOverlayActive
                  ? 'SmartHUD Floating Assistant: ACTIVE on Top'
                  : 'SmartHUD Assistant: PAUSED',
              style: TextStyle(
                color: _hudOverlayActive ? Colors.tealAccent : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Switch(
            value: _hudOverlayActive,
            activeColor: Colors.tealAccent,
            onChanged: (val) {
              setState(() {
                _hudOverlayActive = val;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildDraggableFloatingBubble() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurple,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.tealAccent, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.tealAccent, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SmartHUD Active',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${_stickyNotes.length} pinned items',
                  style: const TextStyle(fontSize: 9, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _showQuickHudModal(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.open_in_full, size: 14, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showQuickHudModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '⚡ Dynamic Floating Notes Feed',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      )
                    ],
                  ),
                  const Divider(),
                  if (_stickyNotes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No notes currently pinned to HUD.'),
                    )
                  else
                    ..._stickyNotes.map(
                      (note) => ListTile(
                        leading: const Icon(Icons.push_pin, color: Colors.amber),
                        title: Text(note, style: const TextStyle(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _stickyNotes.remove(note);
                            });
                            Navigator.pop(ctx);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // TAB 1: Floating HUD & Notes Studio
  Widget _buildFloatingHudStudioTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating HUD & Sticky Studio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Keep important reminders permanently accessible over your apps.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Card 1: Add New Sticky Note
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.edit_note, color: Colors.tealAccent),
                        SizedBox(width: 8),
                        Text(
                          'Pin Note to Screen HUD',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: 'Enter dynamic task or reminder...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _addStickyNote,
                        icon: const Icon(Icons.push_pin),
                        label: const Text('Pin to Overlay HUD'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: Screen Tint Helper (Eye Protector / Focus Tint)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              'Screen Comfort Tint HUD',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Switch(
                          value: _screenTintActive,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setState(() {
                              _screenTintActive = val;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_screenTintActive) ...[
                      const SizedBox(height: 12),
                      const Text('Tint Opacity Intensity', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Slider(
                        value: _tintOpacity,
                        min: 0.1,
                        max: 0.6,
                        activeColor: Colors.amber,
                        onChanged: (val) => setState(() => _tintOpacity = val),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Warm Amber'),
                            selected: _tintColor == Colors.amber,
                            onSelected: (_) => setState(() => _tintColor = Colors.amber),
                          ),
                          ChoiceChip(
                            label: const Text('Soft Red'),
                            selected: _tintColor == Colors.red,
                            onSelected: (_) => setState(() => _tintColor = Colors.red),
                          ),
                          ChoiceChip(
                            label: const Text('Cool Teal'),
                            selected: _tintColor == Colors.teal,
                            onSelected: (_) => setState(() => _tintColor = Colors.teal),
                          ),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Pinned Notes List Display
            const Text(
              'Active Pinned Notes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            const SizedBox(height: 10),
            if (_stickyNotes.isEmpty)
              const Text('No sticky notes pinned yet.', style: TextStyle(color: Colors.grey))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stickyNotes.length,
                itemBuilder: (ctx, idx) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.withOpacity(0.2),
                        child: Text('${idx + 1}', style: const TextStyle(color: Colors.tealAccent)),
                      ),
                      title: Text(
                        _stickyNotes[idx],
                        style: const TextStyle(fontSize: 14),
                        softWrap: true,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() {
                            _stickyNotes.removeAt(idx);
                          });
                        },
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  // TAB 2: Smart AI-Style Reply Helper
  Widget _buildSmartReplyTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Instant Message Polish',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Paste any draft text or received message to instantly draft a perfect response.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Received Message or Rough Thought:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _msgController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Can you send the project report by today?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Tone Strategy:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Professional',
                        'Polite Decline',
                        'Casual / Friendly',
                        'Assertive Direct',
                      ].map((tone) {
                        return ChoiceChip(
                          label: Text(tone),
                          selected: _selectedTone == tone,
                          activeColor: Colors.deepPurpleAccent,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTone = tone;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _generateSmartReply,
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Generate Instant Reply'),
                      ),
                    )
                  ],
                ),
              ),
            ),

            if (_generatedReply.isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                color: const Color(0xFF26263A),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Generated Response:',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20, color: Colors.tealAccent),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied response to clipboard!')),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _generatedReply,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // TAB 3: Micro Decision Evaluator
  Widget _buildMicroDecisionTab() {
    double totalScore = (_necessityScore * 0.4) + (_affordabilityScore * 0.3) + (_longTermValueScore * 0.3);
    String decisionResult = 'MAYBE';
    Color resultColor = Colors.amber;

    if (totalScore >= 7.0) {
      decisionResult = 'YES! GOOD BUY / DECISION';
      resultColor = Colors.greenAccent;
    } else if (totalScore < 4.5) {
      decisionResult = 'NO! SKIP / RECONSIDER';
      resultColor = Colors.redAccent;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro Decision Engine',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Unsure whether to buy something or make a quick daily choice? Calculate dynamic score.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Estimated Cost: \$', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _itemPrice = double.tryParse(val) ?? 0.0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text('How urgent/necessary is this? (${_necessityScore.toStringAsFixed(1)}/10)'),
                    Slider(
                      value: _necessityScore,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _necessityScore = val),
                    ),

                    Text('How comfortable is your current budget for this? (${_affordabilityScore.toStringAsFixed(1)}/10)'),
                    Slider(
                      value: _affordabilityScore,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _affordabilityScore = val),
                    ),

                    Text('Long-term value / utility score? (${_longTermValueScore.toStringAsFixed(1)}/10)'),
                    Slider(
                      value: _longTermValueScore,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _longTermValueScore = val),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: resultColor, width: 2),
              ),
              child: Column(
                children: [
                  const Text('DECISION SCORE EVALUATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '${totalScore.toStringAsFixed(1)} / 10',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: resultColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    decisionResult,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: resultColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Estimated Item Price: \$${_itemPrice.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // TAB 4: Instant Split & Quick Math Utility
  Widget _buildQuickUtilityTab() {
    double tipAmount = (_billAmount * _tipPercentage) / 100;
    double totalBill = _billAmount + tipAmount;
    double perPerson = totalBill / (_peopleCount > 0 ? _peopleCount : 1);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instant Split & Math Suite',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Split bills instantly with custom tips and live headcounts.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Bill Amount (\$)'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _billController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _billAmount = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tip Percentage: ${_tipPercentage.toInt()}%'),
                        Text('Tip: \$${tipAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.tealAccent)),
                      ],
                    ),
                    Slider(
                      value: _tipPercentage,
                      min: 0,
                      max: 30,
                      divisions: 6,
                      activeColor: Colors.tealAccent,
                      onChanged: (val) => setState(() => _tipPercentage = val),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Split Between People:'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (_peopleCount > 1) {
                                  setState(() => _peopleCount--);
                                }
                              },
                            ),
                            Text(
                              '$_peopleCount',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() => _peopleCount++);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total with Tip:'),
                        Text(
                          '\$${totalBill.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Each Person Pays:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${perPerson.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.tealAccent),
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
    );
  }
}

// Wrapper for draggable gesture detection
class GestureDetectingWidget extends StatelessWidget {
  final Widget child;
  final GestureDragUpdateCallback onPanUpdate;

  const GestureDetectingWidget({
    Key? key,
    required this.child,
    required this.onPanUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      child: child,
    );
  }
}