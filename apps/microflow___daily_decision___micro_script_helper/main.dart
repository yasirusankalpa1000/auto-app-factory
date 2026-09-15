import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MicroFlowApp());
}

class MicroFlowApp extends StatelessWidget {
  const MicroFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
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
  int _selectedIndex = 0;
  int _userStreak = 5;
  int _savedMinutes = 140;
  String _activeNotificationBanner = "";

  void _triggerNotification(String message) {
    setState(() {
      _activeNotificationBanner = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.amber),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ImpulseDecisionTab(onDecisionMade: () {
        setState(() {
          _savedMinutes += 15;
        });
        _triggerNotification("Smart decision logged! You saved future stress.");
      }),
      MicroScriptsTab(onScriptCopied: () {
        _triggerNotification("Script copied to clipboard! Clear boundaries set.");
      }),
      MicroGapTab(onTaskCompleted: (mins) {
        setState(() {
          _savedMinutes += mins;
          _userStreak += 1;
        });
        _triggerNotification("Awesome! You turned $mins mins of idle time into a micro-win!");
      }),
      NotificationHubTab(
        streak: _userStreak,
        savedMinutes: _savedMinutes,
        onSimulateNudge: () {
          _triggerNotification("MicroFlow Nudge: Take 3 deep breaths and check your energy level!");
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.indigo, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'MicroFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_userStreak Days',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_activeNotificationBanner.isNotEmpty)
              Container(
                width: double.infinity,
                color: Colors.amber.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.amber, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _activeNotificationBanner,
                        style: TextStyle(color: Colors.indigo.shade900, fontSize: 12, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _activeNotificationBanner = ""),
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    )
                  ],
                ),
              ),
            Expanded(child: pages[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'Impulse Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Micro-Scripts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Micro-Gaps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            activeIcon: Icon(Icons.notifications_active),
            label: 'Nudges',
          ),
        ],
      ),
    );
  }
}

// ---------------- TAB 1: IMPULSE PURCHASE & DECISION CHECK ----------------
class ImpulseDecisionTab extends StatefulWidget {
  final VoidCallback onDecisionMade;
  const ImpulseDecisionTab({super.key, required this.onDecisionMade});

  @override
  State<ImpulseDecisionTab> createState() => _ImpulseDecisionTabState();
}

class _ImpulseDecisionTabState extends State<ImpulseDecisionTab> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  double _needScore = 5.0;
  String _decisionResult = "";
  String _hoursRequiredText = "";
  Color _resultColor = Colors.grey;

  void _calculateImpulse() {
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final double hourlyRate = double.tryParse(_hourlyRateController.text) ?? 0.0;

    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price.')),
      );
      return;
    }

    double hoursNeeded = 0;
    if (hourlyRate > 0) {
      hoursNeeded = price / hourlyRate;
      _hoursRequiredText = "Costs ~${hoursNeeded.toStringAsFixed(1)} hours of your labor!";
    } else {
      _hoursRequiredText = "Add hourly rate to calculate labor hours.";
    }

    // Logic evaluation
    if (_needScore >= 8) {
      _decisionResult = "APPROVED: High necessity score. Go for it responsibly!";
      _resultColor = Colors.green;
    } else if (_needScore >= 5) {
      if (hoursNeeded > 10) {
        _decisionResult = "WAIT 48 HOURS: High labor cost for moderate need. Sleep on it!";
        _resultColor = Colors.orange;
      } else {
        _decisionResult = "THINK TWICE: Ask yourself if you'll use this in 30 days.";
        _resultColor = Colors.blue;
      }
    } else {
      _decisionResult = "SKIP IT: Pure impulse! Put standard \$${price.toStringAsFixed(0)} into savings instead.";
      _resultColor = Colors.red;
    }

    setState(() {});
    widget.onDecisionMade();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          const Text(
            'Impulse Purchase Reality Evaluator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 6),
          const Text(
            'Stop spending on micro-impulses. Calculate real labor cost & necessity.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Item Price (\$)',
                      hintText: 'e.g. 45.00',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _hourlyRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Your Hourly Earn Rate (\$) (Optional)',
                      hintText: 'e.g. 20.00',
                      prefixIcon: Icon(Icons.work_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Necessity Rating (1 to 10):',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _needScore.toInt().toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: _needScore,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: Colors.indigo,
                    label: _needScore.round().toString(),
                    onChanged: (val) {
                      setState(() {
                        _needScore = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _calculateImpulse,
                      icon: const Icon(Icons.analytics),
                      label: const Text('Evaluate Purchase', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_decisionResult.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _resultColor.withOpacity(0.1),
                border: Border.all(color: _resultColor, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: _resultColor),
                      const SizedBox(width: 8),
                      const Text(
                        'FLOW ADVICE',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _decisionResult,
                    style: TextStyle(color: _resultColor, fontWeight: FontWeight.bold, fontSize: 15),
                    softWrap: true,
                  ),
                  if (_hoursRequiredText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _hoursRequiredText,
                      style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white70,
            radius: 24,
            child: Icon(Icons.psychology, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Micro Decision Hub',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  'Avoid regret. Test your everyday buying micro-impulses.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- TAB 2: MICRO-SCRIPTS FOR DIPLOMATIC BOUNDARIES ----------------
class MicroScriptsTab extends StatefulWidget {
  final VoidCallback onScriptCopied;
  const MicroScriptsTab({super.key, required this.onScriptCopied});

  @override
  State<MicroScriptsTab> createState() => _MicroScriptsTabState();
}

class _MicroScriptsTabState extends State<MicroScriptsTab> {
  String _selectedCategory = 'All';

  final List<Map<String, String>> _scripts = [
    {
      'title': 'Refusing Unwanted Social Plan',
      'category': 'Social',
      'tone': 'Warm & Firm',
      'script': 'Hey! Thanks so much for inviting me. I have reached my social bandwidth for this week and need a quiet evening in. Hope you all have an amazing time!',
    },
    {
      'title': 'Politely Turning Down Personal Loan',
      'category': 'Money',
      'tone': 'Diplomatic',
      'script': 'I really sympathize with your situation, but as a strict personal rule I don\'t lend money to friends or family to protect our relationship. I\'m rooting for you to solve this quickly!',
    },
    {
      'title': 'Pushing Back on Last-Minute Work Request',
      'category': 'Work',
      'tone': 'Professional',
      'script': 'Thanks for flagging this. I\'m currently maxed out on my primary deliverables for today. If this takes priority, which item should I push to tomorrow?',
    },
    {
      'title': 'Declining Overtime / Late Meetings',
      'category': 'Work',
      'tone': 'Respectful',
      'script': 'I have prior personal commitments right after work hours today, so I won\'t be able to stay late. Happy to tackle this first thing tomorrow morning!',
    },
    {
      'title': 'Responding to Unsolicited Advice',
      'category': 'Family',
      'tone': 'Gentle Boundary',
      'script': 'I appreciate you sharing your perspective on this! I\'m currently comfortable with my plan, but I\'ll let you know if I need further input.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? _scripts
        : _scripts.where((s) => s['category'] == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Scripts Studio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            'Copy & paste polite, clear boundaries for awkward life moments.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Social', 'Money', 'Work', 'Family'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(cat),
                    selectedColor: Colors.indigo.shade100,
                    checkmarkColor: Colors.indigo,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['tone'] ?? '',
                              style: TextStyle(color: Colors.indigo.shade800, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['script'] ?? '',
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: item['script'] ?? ''));
                            widget.onScriptCopied();
                          },
                          icon: const Icon(Icons.copy, size: 16, color: Colors.indigo),
                          label: const Text('Copy Script', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
                        ),
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
}

// ---------------- TAB 3: MICRO-GAP DOWNTIME ACTIVATOR ----------------
class MicroGapTab extends StatefulWidget {
  final Function(int minutes) onTaskCompleted;
  const MicroGapTab({super.key, required this.onTaskCompleted});

  @override
  State<MicroGapTab> createState() => _MicroGapTabState();
}

class _MicroGapTabState extends State<MicroGapTab> {
  int _selectedMinutes = 5;
  String _selectedEnergy = 'Medium';

  final Map<int, List<String>> _activityMap = {
    5: [
      'Do a 60-second eye reset & 4-7-8 breathing cycle.',
      'Unsubscribe from 3 clutter marketing emails.',
      'Drink 1 full glass of water & stretch your lower back.',
    ],
    10: [
      'Clear off physical desk workspace clutter.',
      'Send a genuine gratitude micro-text to a friend.',
      'Review tomorrow\'s top 1 single priority task.',
    ],
    15: [
      'Take a brisk walk without looking at your phone.',
      'Tidy up 1 drawer or digital downloads folder.',
      'Read 2 pages of a non-fiction book.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final activities = _activityMap[_selectedMinutes] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Gap Downtime Activator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            'Got a short gap between tasks? Replace doomscrolling with micro-wins.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How many free minutes do you have?', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [5, 10, 15].map((mins) {
                      final isSel = _selectedMinutes == mins;
                      return ChoiceChip(
                        label: Text('$mins Mins'),
                        selected: isSel,
                        selectedColor: Colors.indigo,
                        labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87),
                        onSelected: (val) {
                          if (val) setState(() => _selectedMinutes = mins);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  const Text('Current Energy Level:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Low Energy', 'Medium', 'High Focus'].map((e) {
                      final isSel = _selectedEnergy == e;
                      return ChoiceChip(
                        label: Text(e),
                        selected: isSel,
                        selectedColor: Colors.teal,
                        labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87),
                        onSelected: (val) {
                          if (val) setState(() => _selectedEnergy = e);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Suggested Micro-Wins:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, idx) {
              final act = activities[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: Text('${idx + 1}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(act, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    onPressed: () {
                      widget.onTaskCompleted(_selectedMinutes);
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
}

// ---------------- TAB 4: NOTIFICATION HUB & REWARDS ----------------
class NotificationHubTab extends StatefulWidget {
  final int streak;
  final int savedMinutes;
  final VoidCallback onSimulateNudge;

  const NotificationHubTab({
    super.key,
    required this.streak,
    required this.savedMinutes,
    required this.onSimulateNudge,
  });

  @override
  State<NotificationHubTab> createState() => _NotificationHubTabState();
}

class _NotificationHubTabState extends State<NotificationHubTab> {
  bool _impulseNudgeEnabled = true;
  bool _downtimeAlertEnabled = true;
  bool _boundaryCheckEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCard(),
          const SizedBox(height: 16),
          const Text(
            'Smart Notification & Habit Nudges',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 4),
          const Text(
            'Receive timely context nudges throughout the day to keep you focused.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Impulse Purchase Reality Check'),
                  subtitle: const Text('Triggers gentle warning during high shopping hours.'),
                  value: _impulseNudgeEnabled,
                  activeColor: Colors.indigo,
                  onChanged: (val) => setState(() => _impulseNudgeEnabled = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Downtime Gap Activator Alert'),
                  subtitle: const Text('Suggests micro-wins when gaps appear in your schedule.'),
                  value: _downtimeAlertEnabled,
                  activeColor: Colors.indigo,
                  onChanged: (val) => setState(() => _downtimeAlertEnabled = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Social Battery & Boundary Check'),
                  subtitle: const Text('Prompts diplomatic scripts when social fatigue hits.'),
                  value: _boundaryCheckEnabled,
                  activeColor: Colors.indigo,
                  onChanged: (val) => setState(() => _boundaryCheckEnabled = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.indigo, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: widget.onSimulateNudge,
              icon: const Icon(Icons.notifications_active, color: Colors.indigo),
              label: const Text(
                'Test Live In-App Nudge Notification',
                style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.bolt, color: Colors.indigo, size: 28),
              const SizedBox(height: 4),
              Text(
                '${widget.streak} Days',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo),
              ),
              const Text('Flow Streak', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Container(height: 40, width: 1, color: Colors.indigo.shade200),
          Column(
            children: [
              const Icon(Icons.hourglass_top, color: Colors.teal, size: 28),
              const SizedBox(height: 4),
              Text(
                '${widget.savedMinutes} Mins',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
              ),
              const Text('Reclaimed Downtime', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}