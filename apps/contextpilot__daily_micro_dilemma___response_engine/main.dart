import 'package:flutter/material.dart';

void main() {
  runApp(const ContextPilotApp());
}

class ContextPilotApp extends StatelessWidget {
  const ContextPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContextPilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _isFloatingHudEnabled = true;
  String _activeHudText = "ContextPilot HUD Ready: Tap for Quick Replies";

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const SmartReplyGeneratorPage(),
      const InteractiveRoleplayPage(),
      const DilemmaVaultPage(),
      const SettingsAndPermissionsPage(),
    ]);
  }

  void _triggerHudQuickAlert(String message) {
    setState(() {
      _activeHudText = message;
      _isFloatingHudEnabled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('HUD Updated: $message'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
            if (_isFloatingHudEnabled)
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.indigo.shade900,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.tealAccent.withOpacity(0.5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.flash_on, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _activeHudText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _isFloatingHudEnabled = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A24),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Reply Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Simulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Dilemmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Overlay & Permissions',
          ),
        ],
      ),
    );
  }
}

class SmartReplyGeneratorPage extends StatefulWidget {
  const SmartReplyGeneratorPage({super.key});

  @override
  State<SmartReplyGeneratorPage> createState() => _SmartReplyGeneratorPageState();
}

class _SmartReplyGeneratorPageState extends State<SmartReplyGeneratorPage> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedTone = 'Polite Decline';
  String _selectedRelationship = 'Boss / Manager';
  List<String> _generatedOptions = [];

  final List<String> _tones = [
    'Polite Decline',
    'Tactful Delay',
    'Professional Firm',
    'Witty & Sarcastic',
    'Warm & Caring',
    'Emergency Excuse'
  ];

  final List<String> _relationships = [
    'Boss / Manager',
    'Colleague',
    'Partner / Spouse',
    'Friend',
    'Acquaintance / Relative',
  ];

  final List<Map<String, String>> _presetScenarios = [
    {
      'label': 'Work Late Tonight?',
      'text': 'Can you stay back for 3 extra hours tonight to finish this deck?',
    },
    {
      'label': 'Borrow Money (\$100)',
      'text': 'Hey, can you lend me \$100 until next month? I really need it.',
    },
    {
      'label': 'Unwanted Weekend Party',
      'text': 'You are coming to the party this Saturday right? Everyone expects you!',
    },
    {
      'label': 'Late Meeting Response',
      'text': 'Why didn\'t you answer my call 10 minutes ago?',
    },
  ];

  void _generateReplies() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or select a scenario first!')),
      );
      return;
    }

    setState(() {
      if (_selectedTone == 'Polite Decline') {
        _generatedOptions = [
          'Thank you for thinking of me! Unfortunately, I already have prior commitments tonight so I won\'t be able to make it work. Appreciate your understanding!',
          'I\'d love to help, but my schedule is completely maxed out right now. Let\'s reconnect on this early next week!',
          'I won\'t be able to take this on right now, but I wanted to respond quickly so you can make other plans.'
        ];
      } else if (_selectedTone == 'Tactful Delay') {
        _generatedOptions = [
          'Thanks for letting me know. Let me double-check my schedule and get back to you in about 20 minutes!',
          'I am currently in the middle of something urgent. I\'ll review this thoroughly and message you shortly.',
          'Let me check my priorities for today and see how I can accommodate this. Will update you soon!'
        ];
      } else if (_selectedTone == 'Professional Firm') {
        _generatedOptions = [
          'I understand the urgency, but I am currently at full capacity with existing priority deliverables.',
          'To ensure the highest quality on my current targets, I cannot commit to additional requests today.',
          'I am unable to fulfill this request at short notice. Let\'s schedule a dedicated time to review.'
        ];
      } else if (_selectedTone == 'Witty & Sarcastic') {
        _generatedOptions = [
          'If I had a superpower to clone myself, you\'d be the first to get the clone! But right now I\'m out of commission.',
          'My battery is officially at 1% and charging night mode has been engaged!',
          'I would say yes, but my therapist and my calendar have formed a non-negotiable alliance against it.'
        ];
      } else if (_selectedTone == 'Warm & Caring') {
        _generatedOptions = [
          'I really care about this and wish I could step in right now! Sending you lots of love and support from afar.',
          'I know how important this is to you! I am swamped right now, but please keep me updated on how it goes.',
          'Thinking of you! Wish I could be there to support you today. Big hugs!'
        ];
      } else {
        _generatedOptions = [
          'I just ran into a sudden unexpected family obligation and won\'t be available for the rest of the evening.',
          'My phone lost signal/battery unexpectedly while I was in transit. Just seeing this now!',
          'An urgent home maintenance emergency popped up that I have to deal with immediately.'
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.psychology, color: Colors.tealAccent, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Smart Reply Generator',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Instant context-aware responses for awkward texts',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Presets (Tap to use):',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.tealAccent),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presetScenarios.map((preset) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    backgroundColor: const Color(0xFF222230),
                    side: const BorderSide(color: Colors.deepPurple),
                    label: Text(preset['label']!, style: const TextStyle(fontSize: 12, color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        _inputController.text = preset['text']!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Paste or type the awkward message you received here...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF1E1E2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Target Audience:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedRelationship,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF1E1E2A),
                        items: _relationships.map((rel) {
                          return DropdownMenuItem(
                            value: rel,
                            child: Text(rel, style: const TextStyle(fontSize: 12, color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedRelationship = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Desired Tone:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedTone,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF1E1E2A),
                        items: _tones.map((tone) {
                          return DropdownMenuItem(
                            value: tone,
                            child: Text(tone, style: const TextStyle(fontSize: 12, color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTone = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.bolt, color: Colors.amber),
              label: const Text(
                'Generate Smart Replies',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
              ),
              onPressed: _generateReplies,
            ),
          ),
          const SizedBox(height: 24),
          if (_generatedOptions.isNotEmpty) ...[
            const Text(
              'Select & Copy Ideal Reply:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            const SizedBox(height: 12),
            ..._generatedOptions.map((reply) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade700),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.tealAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          icon: const Icon(Icons.content_copy, size: 14, color: Colors.tealAccent),
                          label: const Text('Copy to Clipboard', style: TextStyle(fontSize: 11, color: Colors.tealAccent)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied response to clipboard! Ready to paste.'),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ]
        ],
      ),
    );
  }
}

class InteractiveRoleplayPage extends StatefulWidget {
  const InteractiveRoleplayPage({super.key});

  @override
  State<InteractiveRoleplayPage> createState() => _InteractiveRoleplayPageState();
}

class _InteractiveRoleplayPageState extends State<InteractiveRoleplayPage> {
  String _selectedPersona = 'Strict Boss';
  final TextEditingController _chatController = TextEditingController();

  int _awkwardScore = 20;
  int _persuasionScore = 80;

  final List<Map<String, String>> _messages = [
    {
      'sender': 'bot',
      'text': 'I noticed you left the office early yesterday without sending your daily report. What happened?'
    }
  ];

  void _switchPersona(String persona) {
    setState(() {
      _selectedPersona = persona;
      _messages.clear();
      if (persona == 'Strict Boss') {
        _messages.add({
          'sender': 'bot',
          'text': 'I noticed you left the office early yesterday without sending your daily report. What happened?'
        });
      } else if (persona == 'Angry Partner') {
        _messages.add({
          'sender': 'bot',
          'text': 'You completely forgot about our dinner plans last night. Do you even check your calendar?'
        });
      } else if (persona == 'Persistent Lender') {
        _messages.add({
          'sender': 'bot',
          'text': 'Hey! You promised you would pay back the \$50 by yesterday afternoon. Is everything okay?'
        });
      } else {
        _messages.add({
          'sender': 'bot',
          'text': 'Can you host 6 of my friends at your apartment this entire weekend?'
        });
      }
      _awkwardScore = 25;
      _persuasionScore = 75;
    });
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _chatController.clear();

      // Dynamic feedback calculation based on reply length & terms
      if (text.length < 15) {
        _awkwardScore = (_awkwardScore + 15).clamp(0, 100);
        _persuasionScore = (_persuasionScore - 10).clamp(0, 100);
        _messages.add({
          'sender': 'bot',
          'text': 'That answer feels a bit dismissive. Can you elaborate or give me a clear reason?'
        });
      } else if (text.toLowerCase().contains('sorry') || text.toLowerCase().contains('apologize')) {
        _awkwardScore = (_awkwardScore - 10).clamp(0, 100);
        _persuasionScore = (_persuasionScore + 15).clamp(0, 100);
        _messages.add({
          'sender': 'bot',
          'text': 'I appreciate your honesty. Let us make sure this is handled smoothly going forward.'
        });
      } else {
        _awkwardScore = (_awkwardScore - 5).clamp(0, 100);
        _persuasionScore = (_persuasionScore + 10).clamp(0, 100);
        _messages.add({
          'sender': 'bot',
          'text': 'I hear your side. Let us figure out the best workaround together.'
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sports_esports, color: Colors.tealAccent, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Live Response Simulator',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Practice delicate conversations before sending in real life!',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Select Simulator Persona:', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'Strict Boss',
                'Angry Partner',
                'Persistent Lender',
                'Overbearing Friend'
              ].map((p) {
                final isSelected = p == _selectedPersona;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(p, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.white)),
                    selected: isSelected,
                    selectedColor: Colors.tealAccent,
                    backgroundColor: const Color(0xFF1E1E2A),
                    onSelected: (val) {
                      if (val) _switchPersona(p);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Awkwardness Risk', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('$_awkwardScore%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _awkwardScore > 50 ? Colors.redAccent : Colors.greenAccent)),
                  ],
                ),
                Container(height: 25, width: 1, color: Colors.grey.shade800),
                Column(
                  children: [
                    const Text('Persuasion Rating', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('$_persuasionScore%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 260,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF161622),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple : const Color(0xFF262636),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg['text']!,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type your response to test persona reaction...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF1E1E2A),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.tealAccent),
                icon: const Icon(Icons.send, color: Colors.black, size: 20),
                onPressed: _sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}

class DilemmaVaultPage extends StatefulWidget {
  const DilemmaVaultPage({super.key});

  @override
  State<DilemmaVaultPage> createState() => _DilemmaVaultPageState();
}

class _DilemmaVaultPageState extends State<DilemmaVaultPage> {
  String _searchQuery = '';

  final List<Map<String, String>> _dilemmas = [
    {
      'title': 'Splitting a Restaurant Bill Fairly',
      'category': 'Finance / Social',
      'solution': 'Say upfront before ordering: "Hey guys, I am on a strict budget tonight so I\'ll just order my item and settle my portion directly!"'
    },
    {
      'title': 'Declining Unwanted Loan / Money Requests',
      'category': 'Finance',
      'solution': 'Use rule of thumb: "I have a strict personal rule never to mix finances with close personal relationships so we never risk our bond."'
    },
    {
      'title': 'Graceful Exit from Awkward Party / Event',
      'category': 'Social Exits',
      'solution': 'Set a timer in advance. Walk up to host with phone in hand: "I have an early start tomorrow morning for a family obligation, so I must slip out now!"'
    },
    {
      'title': 'Stopping Unsolicited Advice from Relatives',
      'category': 'Family',
      'solution': 'Smile warmly and state: "That is an interesting perspective! I\'ll definitely take that into consideration as I work through this."'
    },
    {
      'title': 'Dodging Last-Minute Work Requests on Friday',
      'category': 'Work / Boundaries',
      'solution': 'Reply: "I am offline for the weekend starting now. I have slotted this as my top priority first thing Monday morning at 9 AM."'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _dilemmas.where((d) {
      return d['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_stories, color: Colors.amberAccent, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Micro-Dilemma Vault',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Tested cheat-codes for awkward life moments',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) {
              setState(() => _searchQuery = val);
            },
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              hintText: 'Search dilemma (e.g., bill, party, work, loan)...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFF1E1E2A),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...filtered.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(item['category']!, style: const TextStyle(fontSize: 10, color: Colors.tealAccent)),
                        backgroundColor: const Color(0xFF12121A),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, size: 18, color: Colors.grey),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dilemma tactic ready to share!')),
                          );
                        },
                      )
                    ],
                  ),
                  Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['solution']!,
                    style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class SettingsAndPermissionsPage extends StatefulWidget {
  const SettingsAndPermissionsPage({super.key});

  @override
  State<SettingsAndPermissionsPage> createState() => _SettingsAndPermissionsPageState();
}

class _SettingsAndPermissionsPageState extends State<SettingsAndPermissionsPage> {
  bool _drawOverAppsPermitted = true;
  bool _floatingNotificationActive = true;
  bool _autoCopyEnabled = false;
  double _hudOpacity = 0.9;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.widgets, color: Colors.tealAccent, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Overlay & Permissions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Configure always-on floating widget & system tools',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Permission Controls',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Display Above Other Apps', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Allows floating HUD bubble to appear over messaging apps.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _drawOverAppsPermitted,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() => _drawOverAppsPermitted = val);
                  },
                ),
                const Divider(color: Colors.grey, height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Smart Active Notification', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Persistent notification drawer shortcut for 1-tap responses.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _floatingNotificationActive,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() => _floatingNotificationActive = val);
                  },
                ),
                const Divider(color: Colors.grey, height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Auto-Copy Selected Reply', style: TextStyle(fontSize: 13, color: Colors.white)),
                  subtitle: const Text('Automatically copies reply text when generated.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  value: _autoCopyEnabled,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) {
                    setState(() => _autoCopyEnabled = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HUD Transparency & Appearance',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Opacity:', style: TextStyle(fontSize: 12, color: Colors.white)),
                    Expanded(
                      child: Slider(
                        value: _hudOpacity,
                        min: 0.3,
                        max: 1.0,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) {
                          setState(() => _hudOpacity = val);
                        },
                      ),
                    ),
                    Text('${(_hudOpacity * 100).toInt()}%', style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.tealAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh, color: Colors.tealAccent),
              label: const Text('Test System Overlay Banner', style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Simulating System Floating Bubble Launch... Active!'),
                    backgroundColor: Colors.deepPurple,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}