import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OmniCompanionApp());
}

class OmniCompanionApp extends StatelessWidget {
  const OmniCompanionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniCompanion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
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

  // Floating Overlay Bubble state
  Offset _bubbleOffset = const Offset(20, 200);
  bool _isOverlayExpanded = false;
  bool _overlayPermissionEnabled = true;

  // Notification simulation banner state
  String? _activeBannerNotification;
  Timer? _bannerTimer;

  // Global Quick Note state for overlay quick capture
  final List<String> _quickNotes = [];

  void _showNotificationBanner(String message) {
    _bannerTimer?.cancel();
    setState(() {
      _activeBannerNotification = message;
    });
    _bannerTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _activeBannerNotification = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Tabs
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                ScriptGeneratorTab(
                  onNotificationTriggered: _showNotificationBanner,
                ),
                DecisionMatrixTab(
                  onNotificationTriggered: _showNotificationBanner,
                ),
                FloatingOverlayStudioTab(
                  overlayEnabled: _overlayPermissionEnabled,
                  onToggleOverlay: (val) {
                    setState(() {
                      _overlayPermissionEnabled = val;
                    });
                  },
                  onSendTestNotification: _showNotificationBanner,
                ),
                EscapeAndToolsTab(
                  onNotificationTriggered: _showNotificationBanner,
                ),
              ],
            ),
          ),

          // Dynamic Floating Top Notification Toast Simulation
          if (_activeBannerNotification != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: Colors.indigo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _activeBannerNotification!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          softWrap: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _activeBannerNotification = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Floating Assistant Overlay Bubble
          if (_overlayPermissionEnabled)
            Positioned(
              left: _bubbleOffset.dx,
              top: _bubbleOffset.dy,
              child: GestureOverlayBubble(
                isExpanded: _isOverlayExpanded,
                onTap: () {
                  setState(() {
                    _isOverlayExpanded = !_isOverlayExpanded;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubbleOffset.dx + details.delta.dx;
                    double newY = _bubbleOffset.dy + details.delta.dy;
                    // Clamp to screen bounds
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(50.0, screenSize.height - 120.0);
                    _bubbleOffset = Offset(newX, newY);
                  });
                },
                onQuickScriptRequest: (script) {
                  Clipboard.setData(ClipboardData(text: script));
                  _showNotificationBanner('Copied to clipboard: "$script"');
                  setState(() {
                    _isOverlayExpanded = false;
                  });
                },
                onSaveQuickNote: (note) {
                  if (note.trim().isNotEmpty) {
                    setState(() {
                      _quickNotes.add(note.trim());
                      _isOverlayExpanded = false;
                    });
                    _showNotificationBanner('Quick note saved to memory!');
                  }
                },
                notesCount: _quickNotes.length,
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Scripts',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Decision Matrix',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers),
            label: 'Overlay Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Escape & Tools',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: SITUATIONAL SCRIPT GENERATOR
// ==========================================
class ScriptGeneratorTab extends StatefulWidget {
  final Function(String) onNotificationTriggered;
  const ScriptGeneratorTab({
    Key? key,
    required this.onNotificationTriggered,
  }) : super(key: key);

  @override
  State<ScriptGeneratorTab> createState() => _ScriptGeneratorTabState();
}

class _ScriptGeneratorTabState extends State<ScriptGeneratorTab> {
  String _selectedCategory = 'Saying No Politely';
  String _selectedTone = 'Balanced';
  
  final TextEditingController _nameController = TextEditingController(text: 'Alex');
  final TextEditingController _detailController = TextEditingController(text: 'this weekend project');

  final List<String> _categories = [
    'Saying No Politely',
    'Asking Money Back',
    'Price Bargaining',
    'Work Follow-Up',
    'Dating Awkward Delay',
    'Event Cancellation',
  ];

  final List<String> _tones = ['Ultra-Soft', 'Balanced', 'Firm & Direct', 'Witty'];

  String _generateScript() {
    final name = _nameController.text.trim().isEmpty ? 'Friend' : _nameController.text.trim();
    final detail = _detailController.text.trim().isEmpty ? 'this matter' : _detailController.text.trim();

    if (_selectedCategory == 'Saying No Politely') {
      if (_selectedTone == 'Ultra-Soft') {
        return 'Hey $name! Thank you so much for thinking of me regarding $detail. I would love to help, but my calendar is completely packed right now. I really hope it goes smoothly!';
      } else if (_selectedTone == 'Firm & Direct') {
        return 'Hi $name, I won\'t be able to commit to $detail at this time. I\'m currently prioritizing existing deadlines. Thanks for understanding!';
      } else if (_selectedTone == 'Witty') {
        return 'Hey $name! If I had a clone, I\'d send them to help with $detail! Unfortunately, 100% of my single energy is booked today. Catch up soon!';
      } else {
        return 'Hey $name, thanks for reaching out about $detail. I won\'t be able to make it work this time around, but let\'s connect again soon!';
      }
    } else if (_selectedCategory == 'Asking Money Back') {
      if (_selectedTone == 'Ultra-Soft') {
        return 'Hey $name! Hope you\'re having a great week. Just checking in casually about the \$ balance for $detail when you get a quick minute. Thanks!';
      } else if (_selectedTone == 'Firm & Direct') {
        return 'Hi $name, following up regarding the pending payment for $detail. Please transfer it at your earliest convenience today.';
      } else if (_selectedTone == 'Witty') {
        return 'Hey $name! My wallet is starting a tiny strike over $detail! Let me know when you send that payment over! Cheers!';
      } else {
        return 'Hey $name, just a gentle reminder about the expense for $detail. Let me know once you\'ve sent it over!';
      }
    } else if (_selectedCategory == 'Price Bargaining') {
      if (_selectedTone == 'Firm & Direct') {
        return 'Hello, I am interested in $detail. My final budget is fixed at \$50. Let me know if we can close the deal today.';
      } else {
        return 'Hi there! Really love $detail. Would you be open to doing \$45 if I can complete the transaction immediately? Thanks!';
      }
    } else if (_selectedCategory == 'Work Follow-Up') {
      return 'Hi $name, checking in on the status of $detail. Please let me know if you need any additional details from my side to move forward.';
    } else {
      return 'Hey $name, apologies for the slight delay in getting back to you regarding $detail! Catching up now and ready when you are.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final generatedText = _generateScript();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chat, color: Colors.indigo, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Situational Script Assistant',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Generate flawless replies for tricky situations',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category Selector (Horizontal Wrap / Scroll)
            const Text(
              'Select Scenario Category',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.indigo,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Tone Selector
            const Text(
              'Select Tone',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _tones.map((tone) {
                final isSelected = tone == _selectedTone;
                return ChoiceChip(
                  label: Text(tone),
                  selected: isSelected,
                  selectedColor: Colors.amber.shade700,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
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

            // Dynamic Inputs
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Recipient Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _detailController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Subject / Context',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Generated Result Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Generated Script',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedTone,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    generatedText,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: generatedText));
                            widget.onNotificationTriggered('Script copied to clipboard!');
                          },
                          icon: const Icon(Icons.content_copy, size: 16),
                          label: const Text('Copy Script'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          setState(() {});
                          widget.onNotificationTriggered('Script refreshed!');
                        },
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh Script',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 2: LIFE DECISION MATRIX
// ==========================================
class DecisionMatrixTab extends StatefulWidget {
  final Function(String) onNotificationTriggered;
  const DecisionMatrixTab({
    Key? key,
    required this.onNotificationTriggered,
  }) : super(key: key);

  @override
  State<DecisionMatrixTab> createState() => _DecisionMatrixTabState();
}

class _DecisionMatrixTabState extends State<DecisionMatrixTab> {
  final TextEditingController _dilemmaController = TextEditingController(
    text: 'Should I spend \$80 on dinner & drinks tonight?',
  );

  double _necessityScore = 5.0; // 1 to 10
  double _budgetImpact = 6.0;   // 1 to 10
  double _regretPotential = 4.0; // 1 to 10
  double _energyLevel = 5.0;    // 1 to 10

  String _calculateDecisionOutcome() {
    // Score math
    double score = (_necessityScore * 2.0) - (_budgetImpact * 1.5) - (_regretPotential * 1.2) + (_energyLevel * 1.0);
    if (score >= 6.0) {
      return 'GO FOR IT! ✅\nThe evaluation shows high value and manageable risk.';
    } else if (score >= 0.0) {
      return 'SLEEP ON IT! ⏳\nWait 24 hours before spending or committing.';
    } else {
      return 'SKIP / SAY NO! 🛑\nHigh potential for regret or unnecessary drain.';
    }
  }

  Color _getScoreColor() {
    double score = (_necessityScore * 2.0) - (_budgetImpact * 1.5) - (_regretPotential * 1.2) + (_energyLevel * 1.0);
    if (score >= 6.0) return Colors.green;
    if (score >= 0.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final decisionResult = _calculateDecisionOutcome();
    final scoreColor = _getScoreColor();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.psychology, color: Colors.teal, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Life Decision Matrix',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Eliminate fatigue & make micro-choices effortlessly',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dilemma Input
            TextField(
              controller: _dilemmaController,
              decoration: const InputDecoration(
                labelText: 'What decision are you weighing?',
                hintText: 'e.g. Buying new shoes, going out, accepting project...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.help_outline),
              ),
            ),
            const SizedBox(height: 20),

            // Sliders Matrix
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSliderRow(
                    label: 'Necessity / Importance',
                    value: _necessityScore,
                    minLabel: 'Low',
                    maxLabel: 'Essential',
                    color: Colors.teal,
                    onChanged: (v) => setState(() => _necessityScore = v),
                  ),
                  const SizedBox(height: 12),
                  _buildSliderRow(
                    label: 'Financial / Time Cost',
                    value: _budgetImpact,
                    minLabel: 'Cheap',
                    maxLabel: 'Expensive',
                    color: Colors.deepOrange,
                    onChanged: (v) => setState(() => _budgetImpact = v),
                  ),
                  const SizedBox(height: 12),
                  _buildSliderRow(
                    label: 'Potential Future Regret',
                    value: _regretPotential,
                    minLabel: 'Zero',
                    maxLabel: 'High',
                    color: Colors.purple,
                    onChanged: (v) => setState(() => _regretPotential = v),
                  ),
                  const SizedBox(height: 12),
                  _buildSliderRow(
                    label: 'Current Energy / Willingness',
                    value: _energyLevel,
                    minLabel: 'Exhausted',
                    maxLabel: 'Pumped',
                    color: Colors.blue,
                    onChanged: (v) => setState(() => _energyLevel = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Outcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scoreColor, width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.stars, color: scoreColor, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'MATRIX RECOMMENDATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: scoreColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    decisionResult,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required String minLabel,
    required String maxLabel,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(
              '${value.toInt()}/10',
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
            trackHeight: 6,
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(maxLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// TAB 3: FLOATING OVERLAY & NOTIFICATION STUDIO
// ==========================================
class FloatingOverlayStudioTab extends StatelessWidget {
  final bool overlayEnabled;
  final ValueChanged<bool> onToggleOverlay;
  final Function(String) onSendTestNotification;

  const FloatingOverlayStudioTab({
    Key? key,
    required this.overlayEnabled,
    required this.onToggleOverlay,
    required this.onSendTestNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.layers, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overlay & Floating Hub',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage real-time screen companion & toasts',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Permission Switch Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.indigo, size: 30),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Floating Assistant Bubble',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          overlayEnabled
                              ? 'Active on screen. Drag bubble anywhere!'
                              : 'Disabled. Turn on to enable floating bubble.',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: overlayEnabled,
                    activeColor: Colors.indigo,
                    onChanged: onToggleOverlay,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Simulate Dynamic Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Trigger micro-prompts that assist you during daily phone usage:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Notification Presets
            _buildNotificationTriggerTile(
              context,
              title: '💡 Quick Micro-Break Reminder',
              subtitle: 'Sends gentle prompt to unclench jaw & relax shoulders',
              onTap: () => onSendTestNotification('OmniPrompt: Relax your shoulders and take a deep breath!'),
            ),
            const SizedBox(height: 10),
            _buildNotificationTriggerTile(
              context,
              title: '💬 Awkward Text Emergency Assistant',
              subtitle: 'Sends direct quick shortcut to text script engine',
              onTap: () => onSendTestNotification('OmniScript: Need to say NO politely? Open Assistant now.'),
            ),
            const SizedBox(height: 10),
            _buildNotificationTriggerTile(
              context,
              title: '💰 Impulse Spend Alert Check',
              subtitle: 'Asks "Do I need this?" before online shopping checkout',
              onTap: () => onSendTestNotification('Impulse Check: Evaluate necessity score in Decision Matrix!'),
            ),
            const SizedBox(height: 20),

            // Info Container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.indigo, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'The Floating Assistant bubble stays on top of all application views so you can tap it instantly whenever you need a quick script or decision check!',
                      style: TextStyle(fontSize: 12, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTriggerTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.send_outlined, size: 18, color: Colors.indigo),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: ESCAPE CALL & MICRO TOOLS
// ==========================================
class EscapeAndToolsTab extends StatefulWidget {
  final Function(String) onNotificationTriggered;
  const EscapeAndToolsTab({
    Key? key,
    required this.onNotificationTriggered,
  }) : super(key: key);

  @override
  State<EscapeAndToolsTab> createState() => _EscapeAndToolsTabState();
}

class _EscapeAndToolsTabState extends State<EscapeAndToolsTab> {
  // Fake Call State
  bool _isFakeCallScheduled = false;
  int _secondsRemaining = 10;
  Timer? _callTimer;
  bool _isCallActiveScreen = false;

  final TextEditingController _callerNameController = TextEditingController(
    text: 'Work Manager',
  );

  // Tip & Bill Splitter
  final TextEditingController _billAmountController = TextEditingController(text: '45.00');
  double _tipPercentage = 15.0;
  int _splitCount = 2;

  void _startEscapeCallCountdown() {
    setState(() {
      _isFakeCallScheduled = true;
      _secondsRemaining = 10;
    });

    widget.onNotificationTriggered('Escape call scheduled in 10 seconds!');

    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isFakeCallScheduled = false;
          _isCallActiveScreen = true;
        });
      }
    });
  }

  void _cancelCall() {
    _callTimer?.cancel();
    setState(() {
      _isFakeCallScheduled = false;
      _isCallActiveScreen = false;
    });
    widget.onNotificationTriggered('Escape call cancelled.');
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _callerNameController.dispose();
    _billAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCallActiveScreen) {
      return _buildSimulatedIncomingCallScreen();
    }

    // Calculation for Splitter
    double bill = double.tryParse(_billAmountController.text) ?? 0.0;
    double totalTip = bill * (_tipPercentage / 100.0);
    double grandTotal = bill + totalTip;
    double perPerson = _splitCount > 0 ? grandTotal / _splitCount : grandTotal;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.build, color: Colors.red, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Escape & Tools',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Fake escape call generator & quick calculators',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Emergency Escape Call Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.phone_callback, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Social Escape Call Simulator',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Triggers a realistic incoming phone call screen to give you a polite excuse to leave awkward situations.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _callerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Caller Name / Label',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isFakeCallScheduled)
                    Column(
                      children: [
                        LinearProgressIndicator(value: (10 - _secondsRemaining) / 10.0),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Call incoming in $_secondsRemaining sec...',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            TextButton(
                              onPressed: _cancelCall,
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _startEscapeCallCountdown,
                        icon: const Icon(Icons.timer),
                        label: const Text('Trigger Escape Call (10s Delay)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Micro Tool: Quick Tip & Bill Splitter
            const Text(
              'Quick Tip & Bill Splitter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _billAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Total Bill Amount (\$)',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tip Percentage:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Text(
                        '${_tipPercentage.toInt()}% (\$"${totalTip.toStringAsFixed(2)}")',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ],
                  ),
                  Slider(
                    value: _tipPercentage,
                    min: 0,
                    max: 30,
                    divisions: 6,
                    activeColor: Colors.indigo,
                    onChanged: (val) => setState(() => _tipPercentage = val),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Split Between:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _splitCount > 1
                                ? () => setState(() => _splitCount--)
                                : null,
                          ),
                          Text(
                            '$_splitCount people',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => setState(() => _splitCount++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Each Person Pays:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '\$${perPerson.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Simulated Full Screen Phone Call
  Widget _buildSimulatedIncomingCallScreen() {
    final callerName = _callerNameController.text.trim().isEmpty
        ? 'Work Manager'
        : _callerNameController.text.trim();

    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                callerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Incoming Mobile Call...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Decline Button
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'decline_btn',
                    backgroundColor: Colors.red,
                    onPressed: () {
                      setState(() {
                        _isCallActiveScreen = false;
                      });
                      widget.onNotificationTriggered('Call declined.');
                    },
                    child: const Icon(Icons.call_end, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('Decline', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
              // Accept Button
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'accept_btn',
                    backgroundColor: Colors.green,
                    onPressed: () {
                      setState(() {
                        _isCallActiveScreen = false;
                      });
                      widget.onNotificationTriggered('Call answered! Perfect escape excuse.');
                    },
                    child: const Icon(Icons.call, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text('Accept', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// DRAGGABLE FLOATING OVERLAY BUBBLE COMPONENT
// ==========================================
class GestureOverlayBubble extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(DragUpdateDetails) onPanUpdate;
  final Function(String) onQuickScriptRequest;
  final Function(String) onSaveQuickNote;
  final int notesCount;

  const GestureOverlayBubble({
    Key? key,
    required this.isExpanded,
    required this.onTap,
    required this.onPanUpdate,
    required this.onQuickScriptRequest,
    required this.onSaveQuickNote,
    required this.notesCount,
  }) : super(key: key);

  @override
  State<GestureOverlayBubble> createState() => _GestureOverlayBubbleState();
}

class _GestureOverlayBubbleState extends State<GestureOverlayBubble> {
  final TextEditingController _quickNoteController = TextEditingController();

  @override
  void dispose() {
    _quickNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpanded) {
      return Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigo, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flash_on, color: Colors.amber, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Omni Assistant Hub',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                ],
              ),
              const Divider(height: 16),

              // Instant Quick Scripts Shortcuts
              const Text(
                'Instant Quick Replies:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildQuickScriptChip(
                    'Can\'t talk now',
                    'Hey! Can\'t talk right now, I will get back to you shortly.',
                  ),
                  _buildQuickScriptChip(
                    'Send details',
                    'Could you please send me the details via text/email? Thanks!',
                  ),
                  _buildQuickScriptChip(
                    'Polite Decline',
                    'Thanks for inviting me! I won\'t be able to make it this time.',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Micro Scratchpad
              const Text(
                'Quick Memory Scratchpad:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quickNoteController,
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Type fast thought...',
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green, size: 20),
                    onPressed: () {
                      widget.onSaveQuickNote(_quickNoteController.text);
                      _quickNoteController.clear();
                    },
                  ),
                ],
              ),
              if (widget.notesCount > 0) ...[
                const SizedBox(height: 6),
                Text(
                  'Saved Notes in Session: ${widget.notesCount}',
                  style: const TextStyle(fontSize: 10, color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Unexpanded Floating Bubble (Draggable)
    return GestureDetector(
      onPanUpdate: widget.onPanUpdate,
      onTap: widget.onTap,
      child: Material(
        elevation: 8,
        shape: const CircleBorder(),
        color: Colors.indigo,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickScriptChip(String label, String fullScript) {
    return InkWell(
      onTap: () => widget.onQuickScriptRequest(fullScript),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.indigo.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.indigo),
        ),
      ),
    );
  }
}