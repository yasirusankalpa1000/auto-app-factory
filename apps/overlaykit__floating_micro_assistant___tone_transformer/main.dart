import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayKitApp());
}

class OverlayKitApp extends StatelessWidget {
  const OverlayKitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayKit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
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
  bool _isFloatingHudEnabled = true;
  Offset _floatingPosition = const Offset(20, 150);
  bool _isHudExpanded = false;

  // Quick clipboard storage demo items
  final List<String> _quickSnippets = [
    "Bank: 1029-3849-2019 (John Doe)",
    "Home Address: 42 Palm Avenue, Suite 4B",
    "WiFi Pass: SecureNet2025!",
  ];

  final TextEditingController _newSnippetController = TextEditingController();

  void _addSnippet() {
    if (_newSnippetController.text.trim().isNotEmpty) {
      setState(() {
        _quickSnippets.add(_newSnippetController.text.trim());
        _newSnippetController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Snippet saved to Quick Stack!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final List<Widget> pages = [
      const ToneTransformerPage(),
      QuickStackAndHudPage(
        snippets: _quickSnippets,
        onAddSnippet: _addSnippet,
        snippetController: _newSnippetController,
      ),
      const AwkwardSituationsPage(),
      const DailyLifeHacksPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Active Tab View
            IndexedStack(
              index: _currentIndex,
              children: pages,
            ),

            // Simulated Floating HUD (Interactive Overlay)
            if (_isFloatingHudEnabled)
              Positioned(
                left: _floatingPosition.dx,
                top: _floatingPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newX = _floatingPosition.dx + details.delta.dx;
                      double newY = _floatingPosition.dy + details.delta.dy;
                      // Keep within reasonable screen bounds
                      newX = newX.clamp(0.0, screenSize.width - 70);
                      newY = newY.clamp(0.0, screenSize.height - 150);
                      _floatingPosition = Offset(newX, newY);
                    });
                  },
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.primary,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        setState(() {
                          _isHudExpanded = !_isHudExpanded;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flash_on, color: Colors.white),
                            if (_isHudExpanded) ...[
                              const SizedBox(width: 8),
                              const Text(
                                "Quick HUD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    _isHudExpanded = false;
                                  });
                                },
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Floating Popup Panel when Overlay is tapped
            if (_isHudExpanded)
              Positioned(
                left: (_floatingPosition.dx > screenSize.width / 2)
                    ? null
                    : _floatingPosition.dx,
                right: (_floatingPosition.dx > screenSize.width / 2)
                    ? (screenSize.width - _floatingPosition.dx - 60)
                    : null,
                top: _floatingPosition.dy + 55,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: Container(
                    width: 240,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Floating Shortcuts",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isHudExpanded = false;
                                });
                              },
                              child: const Icon(Icons.cancel, size: 18),
                            )
                          ],
                        ),
                        const Divider(),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.copy, color: Colors.teal),
                          title: const Text("Copy Saved Bank Info",
                              style: TextStyle(fontSize: 12)),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied: Bank 1029-3849-2019")),
                            );
                            setState(() => _isHudExpanded = false);
                          },
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const Icon(Icons.forum, color: Colors.indigo),
                          title: const Text("Polite Decline Script",
                              style: TextStyle(fontSize: 12)),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Copied: 'I would love to, but I have a prior commitment!'")),
                            );
                            setState(() => _isHudExpanded = false);
                          },
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.lightbulb,
                              color: Colors.amber),
                          title: const Text("Micro Tip of the Day",
                              style: TextStyle(fontSize: 12)),
                          onTap: () {
                            _showTipDialog(context);
                            setState(() => _isHudExpanded = false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Tone Refiner',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Quick Stack',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            label: 'Situations',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb),
            label: 'Daily Hacks',
          ),
        ],
      ),
    );
  }

  void _showTipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("💡 Micro Life Tip"),
        content: const Text(
          "When asking for a discount or negotiating, pause for 3 full seconds after hearing the price. Silence gently pressures the other party to offer a better deal without argument!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Got It!"),
          )
        ],
      ),
    );
  }
}

// TAB 1: Smart Tone & Text Transformer
class ToneTransformerPage extends StatefulWidget {
  const ToneTransformerPage({Key? key}) : super(key: key);

  @override
  State<ToneTransformerPage> createState() => _ToneTransformerPageState();
}

class _ToneTransformerPageState extends State<ToneTransformerPage> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedTone = 'Polite & Friendly';
  List<String> _generatedResults = [];
  bool _isProcessing = false;

  final List<String> _tones = [
    'Polite & Friendly',
    'Strict & Professional',
    'Diplomatic Excuse',
    'Witty & Playful',
    'Firm Boundaries'
  ];

  void _transformText() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isProcessing = false;
        if (_selectedTone == 'Polite & Friendly') {
          _generatedResults = [
            "Hey! Thanks so much for reaching out about '$text'. I truly appreciate it, but I won't be able to make it work this time. Let's catch up soon!",
            "Hi there! I was thinking about '$text'. While I'd love to help, my schedule is completely packed right now. Hope you understand!",
            "Thank you for considering me for '$text'! I'm currently tied up, but I really appreciate your thoughtfulness."
          ];
        } else if (_selectedTone == 'Strict & Professional') {
          _generatedResults = [
            "Regarding '$text': I have reviewed this request and unfortunately cannot proceed at this stage due to prior commitments.",
            "Thank you for your message. Please be advised that '$text' falls outside my current scope of bandwidth. Best regards.",
            "I am writing to formally address '$text'. At present, I am unable to accommodate this. Thank you for understanding."
          ];
        } else if (_selectedTone == 'Diplomatic Excuse') {
          _generatedResults = [
            "I would have loved to handle '$text', but I am currently managing an urgent priority that requires my full focus today.",
            "That sounds interesting! Unfortunately, I committed to a family obligation earlier, so I won't be able to join for '$text'.",
            "I'm in the middle of resolving an unavoidable schedule clash regarding '$text'. Let's definitely reschedule for next week!"
          ];
        } else if (_selectedTone == 'Witty & Playful') {
          _generatedResults = [
            "My brain says yes to '$text', but my energy meter is currently sitting at 2%! Can I take a raincheck? ☕",
            "If I had a superpower to clone myself, I'd send clone #2 to do '$text'! Sadly, I'm stuck doing adulting today.",
            "10/10 idea for '$text'! Unfortunately, my sofa has officially adopted me for the evening. Catch you next time!"
          ];
        } else {
          _generatedResults = [
            "I appreciate you bringing up '$text', but that doesn't align with my current capacity. Thank you for respecting my decision.",
            "I need to be transparent: I cannot commit to '$text'. I prefer to give honest answers rather than overpromise.",
            "I am setting a firm boundary regarding '$text'. I hope you can respect my decision."
          ];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tone Refiner AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text("How it works"),
                  content: const Text(
                    "Type any rough thoughts (e.g., 'I can't lend you \$50 right now') and select a tone. Get instant, perfectly structured responses ready to copy!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text("OK"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Turn awkward or blunt thoughts into polished, context-ready text messages instantly.",
                        style: TextStyle(fontSize: 13),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Your Rough Thought / Raw Response:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _inputController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      "e.g., 'I can't attend the wedding tomorrow', or 'Stop asking to borrow money'",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Select Tone Style:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tones.map((tone) {
                  final isSelected = _selectedTone == tone;
                  return ChoiceChip(
                    label: Text(tone),
                    selected: isSelected,
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
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _transformText,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.bolt),
                  label: Text(_isProcessing ? "Refining..." : "Transform Text"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (_generatedResults.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Refined Suggestions:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Tap to copy",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ..._generatedResults.asMap().entries.map((entry) {
                  int idx = entry.key + 1;
                  String text = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Text(
                                  "$idx",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Option $idx",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Copied Option $idx to clipboard!"),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            text,
                            style: const TextStyle(fontSize: 14, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// TAB 2: Quick Clipboard Stack & HUD Settings
class QuickStackAndHudPage extends StatelessWidget {
  final List<String> snippets;
  final VoidCallback onAddSnippet;
  final TextEditingController snippetController;

  const QuickStackAndHudPage({
    Key? key,
    required this.snippets,
    required this.onAddSnippet,
    required this.snippetController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quick Stack & HUD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hud Status Card
              Card(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.touch_app, size: 36, color: Colors.teal),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Floating HUD Active",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Drag the floating trigger button anywhere on your screen for quick actions.",
                              style: TextStyle(fontSize: 12),
                              softWrap: true,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Save Frequently Used Text / Numbers:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: snippetController,
                      decoration: const InputDecoration(
                        hintText: "e.g. Account No, Address, Wi-Fi",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onAddSnippet,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    child: const Icon(Icons.add),
                  )
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Quick Copy Pins:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "${snippets.length} Items",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (snippets.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text("No items saved yet. Add one above!"),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snippets.length,
                  itemBuilder: (ctx, index) {
                    final item = snippets[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: const Icon(Icons.pin_drop, size: 18),
                        ),
                        title: Text(
                          item,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy, color: Colors.indigo),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Copied: '$item'")),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// TAB 3: Awkward Situation Decision Tree & Scripts
class AwkwardSituationsPage extends StatefulWidget {
  const AwkwardSituationsPage({Key? key}) : super(key: key);

  @override
  State<AwkwardSituationsPage> createState() => _Aw