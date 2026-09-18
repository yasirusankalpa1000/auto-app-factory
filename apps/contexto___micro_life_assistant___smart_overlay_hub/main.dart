import 'package:flutter/material.dart';

void main() {
  runApp(const ContextoApp());
}

class ContextoApp extends StatelessWidget {
  const ContextoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contexto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
      ),
      home: const ContextoMainScreen(),
    );
  }
}

class ContextoMainScreen extends StatefulWidget {
  const ContextoMainScreen({Key? key}) : super(key: key);

  @override
  State<ContextoMainScreen> createState() => _ContextoMainScreenState();
}

class _ContextoMainScreenState extends State<ContextoMainScreen> {
  int _currentIndex = 0;
  bool _isFloatingWidgetEnabled = true;
  bool _isNotificationOverlayEnabled = true;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const TextReplyAssistantView(),
      const ImpulseBuyInterceptorView(),
      const LeftoverChefView(),
      FloatingDockView(
        floatingEnabled: _isFloatingWidgetEnabled,
        notificationEnabled: _isNotificationOverlayEnabled,
        onToggleFloating: (val) {
          setState(() {
            _isFloatingWidgetEnabled = val;
          });
        },
        onToggleNotification: (val) {
          setState(() {
            _isNotificationOverlayEnabled = val;
          });
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.amber),
            const SizedBox(width: 8),
            const Text(
              'Contexto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'PRO ACTIVE',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        backgroundColor: const Color(0xFF1E1E28),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
          ),
          if (_isFloatingWidgetEnabled)
            Positioned(
              right: 12,
              top: 100,
              child: FloatingPreviewBubble(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Floating Helper Active! Contexto overlay ready.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E28),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Text Polish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            activeIcon: Icon(Icons.monetization_on),
            label: 'Impulse Guard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            activeIcon: Icon(Icons.restaurant),
            label: 'Quick Chef',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers_outlined),
            activeIcon: Icon(Icons.layers),
            label: 'Floating Dock',
          ),
        ],
      ),
    );
  }
}

// ------------------- VIEW 1: TEXT REPLY ASSISTANT -------------------
class TextReplyAssistantView extends StatefulWidget {
  const TextReplyAssistantView({Key? key}) : super(key: key);

  @override
  State<TextReplyAssistantView> createState() => _TextReplyAssistantViewState();
}

class _TextReplyAssistantViewState extends State<TextReplyAssistantView> {
  String _selectedCategory = 'Money Back';
  String _selectedTone = 'Polite & Firm';

  final Map<String, Map<String, List<String>>> _replies = {
    'Money Back': {
      'Polite & Firm': [
        "Hey! Just checking in on that \\\$50 from last week. Let me know when you can send it over today, thanks!",
        "Hi! Hope you're well. I'm balancing my monthly budget today—could you transfer the money owed when you get a second?",
      ],
      'Casual': [
        "Yo! Quick reminder about that cash from dinner. Send over UPI/bank when free!",
        "Hey mate, hit me up with that transfer when you get a chance today!",
      ],
      'Strict': [
        "Hi, I need that balance cleared today as discussed. Please confirm once transferred.",
      ],
    },
    'Decline Event': {
      'Polite & Firm': [
        "Thanks so much for inviting me! I won't be able to make it this time due to prior commitments, but hope you all have a great time!",
        "Really appreciate the invite, but my schedule is completely packed this week. Catch up soon!",
      ],
      'Casual': [
        "Ah damn, gonna have to pass this time! Let's definitely raincheck though.",
        "Can't make it today guys! Catch you all next round.",
      ],
      'Strict': [
        "Thanks for asking, but I'm unavailable and won't be attending.",
      ],
    },
    'Work Boundaries': {
      'Polite & Firm': [
        "I've logged off for the day to recharge. I'll prioritize this first thing tomorrow morning at 9 AM!",
        "Thanks for the update. Since this is outside standard hours, I'll take a look at this tomorrow.",
      ],
      'Casual': [
        "Done for the evening! Will check this out tomorrow AM.",
      ],
      'Strict': [
        "I am currently off duty. Will handle this during business hours tomorrow.",
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    List<String> currentOptions = _replies[_selectedCategory]?[_selectedTone] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Awkward Text Reply Helper',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select your uncomfortable situation and pick a tone to get instant, perfectly worded responses.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text('1. Select Micro-Situation:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.amber)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Money Back', 'Decline Event', 'Work Boundaries'].map((cat) {
              final isSelected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: Colors.deepPurple,
                backgroundColor: const Color(0xFF2A2A38),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
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
          const Text('2. Select Desired Tone:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.amber)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Polite & Firm', 'Casual', 'Strict'].map((tone) {
              final isSelected = tone == _selectedTone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSelected,
                selectedColor: Colors.teal,
                backgroundColor: const Color(0xFF2A2A38),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
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
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.tealAccent),
              const SizedBox(width: 6),
              Text(
                'Ready Responses (${currentOptions.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...currentOptions.map((text) {
            return Card(
              color: const Color(0xFF1E1E28),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard! Ready to paste into WhatsApp / Messages.'),
                                backgroundColor: Colors.teal,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.content_copy, size: 14),
                          label: const Text('Copy Text', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// ------------------- VIEW 2: IMPULSE BUY INTERCEPTOR -------------------
class ImpulseBuyInterceptorView extends StatefulWidget {
  const ImpulseBuyInterceptorView({Key? key}) : super(key: key);

  @override
  State<ImpulseBuyInterceptorView> createState() => _ImpulseBuyInterceptorViewState();
}

class _ImpulseBuyInterceptorViewState extends State<ImpulseBuyInterceptorView> {
  double _itemPrice = 85.0;
  double _hourlyWage = 15.0;
  String _itemName = 'Wireless Earbuds';

  @override
  Widget build(BuildContext context) {
    double sweatHours = _hourlyWage > 0 ? (_itemPrice / _hourlyWage) : 0;
    int daysToWork = (sweatHours / 8).ceil();

    String regretRisk = 'MEDIUM';
    Color riskColor = Colors.orange;

    if (sweatHours > 20) {
      regretRisk = 'EXTREME';
      riskColor = Colors.red;
    } else if (sweatHours < 3) {
      regretRisk = 'LOW';
      riskColor = Colors.green;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impulse Purchase Interceptor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Convert real prices into labor hours before pressing "Buy Now".',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E28),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                    controller: TextEditingController(text: _itemName),
                    onChanged: (val) => _itemName = val,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item Price: \\\$${_itemPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Hourly Wage: \\\$${_hourlyWage.toStringAsFixed(0)}/hr', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Slider(
                    value: _itemPrice,
                    min: 5,
                    max: 500,
                    divisions: 99,
                    activeColor: Colors.deepPurpleAccent,
                    onChanged: (val) {
                      setState(() {
                        _itemPrice = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Hourly Wage:', style: TextStyle(fontSize: 13)),
                      Text('\\\$${_hourlyWage.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                  Slider(
                    value: _hourlyWage,
                    min: 5,
                    max: 100,
                    divisions: 19,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _hourlyWage = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E28),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: riskColor.withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: riskColor, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Regret Risk Level: $regretRisk',
                            style: TextStyle(fontWeight: FontWeight.bold, color: riskColor, fontSize: 16),
                          ),
                          const Text(
                            'Based on effort ratio & wage commitment',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Colors.white70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${sweatHours.toStringAsFixed(1)} hrs',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text('Sweat Work Required', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Container(height: 30, width: 1, color: Colors.white70),
                    Column(
                      children: [
                        Text(
                          '~$daysToWork Days',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        const SizedBox(height: 4),
                        const Text('Life Working Time', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.blueGrey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Psychological Reality Check: Are you willing to work ${sweatHours.toStringAsFixed(1)} uninterrupted hours solely for "$_itemName"?',
                      style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.white70),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ------------------- VIEW 3: LEFTOVER PANTRY CHEF -------------------
class LeftoverChefView extends StatefulWidget {
  const LeftoverChefView({Key? key}) : super(key: key);

  @override
  State<LeftoverChefView> createState() => _LeftoverChefViewState();
}

class _LeftoverChefViewState extends State<LeftoverChefView> {
  final List<String> _allIngredients = [
    'Eggs', 'Rice', 'Bread', 'Cheese', 'Tomatoes', 'Onions', 'Garlic', 'Chicken', 'Potatoes', 'Pasta'
  ];

  final Set<String> _selectedIngredients = {'Eggs', 'Rice', 'Onions'};

  final List<Map<String, dynamic>> _recipeDb = [
    {
      'title': 'Crispy Egg Fried Rice',
      'time': '10 mins',
      'match': 3,
      'ingredients': ['Eggs', 'Rice', 'Onions'],
      'desc': 'Scramble eggs with diced onions in hot oil, throw in cold leftover rice with soy sauce or spices.'
    },
    {
      'title': 'Cheesy Garlic Toast',
      'time': '8 mins',
      'match': 3,
      'ingredients': ['Bread', 'Cheese', 'Garlic'],
      'desc': 'Rub garlic on bread slices, top with grated cheese, and toast until bubbly and melted.'
    },
    {
      'title': 'Quick Tomato Egg Skillet',
      'time': '12 mins',
      'match': 3,
      'ingredients': ['Eggs', 'Tomatoes', 'Onions'],
      'desc': 'Sauté chopped onions and tomatoes until juicy, crack eggs directly on top and cover until set.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leftover & Pantry Chef',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap items currently in your fridge to discover instant 10-minute recipes.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allIngredients.map((ing) {
              final isSelected = _selectedIngredients.contains(ing);
              return FilterChip(
                label: Text(ing),
                selected: isSelected,
                selectedColor: Colors.teal,
                backgroundColor: const Color(0xFF2A2A38),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedIngredients.add(ing);
                    } else {
                      _selectedIngredients.remove(ing);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.restaurant_menu, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Instant Recipe Ideas (${_recipeDb.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._recipeDb.map((recipe) {
            List<String> reqs = List<String>.from(recipe['ingredients']);
            int matches = reqs.where((item) => _selectedIngredients.contains(item)).length;

            return Card(
              color: const Color(0xFF1E1E28),
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
                            recipe['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: Text(
                            recipe['time'],
                            style: const TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe['desc'],
                      style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Match Score: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('$matches/${reqs.length} ingredients',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: matches > 0 ? Colors.green : Colors.orange,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// ------------------- VIEW 4: FLOATING DOCK & PERMISSIONS -------------------
class FloatingDockView extends StatelessWidget {
  final bool floatingEnabled;
  final bool notificationEnabled;
  final ValueChanged<bool> onToggleFloating;
  final ValueChanged<bool> onToggleNotification;

  const FloatingDockView({
    Key? key,
    required this.floatingEnabled,
    required this.notificationEnabled,
    required this.onToggleFloating,
    required this.onToggleNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Screen Dock & Overlay',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep Contexto utilities floating over WhatsApp, Chrome, and social apps.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF1E1E28),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  value: floatingEnabled,
                  activeColor: Colors.deepPurpleAccent,
                  title: const Text('Floating Quick Bubble', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Simulates drawing over other apps for 1-tap responses.', style: TextStyle(fontSize: 12)),
                  onChanged: onToggleFloating,
                ),
                const Divider(height: 1, color: Colors.white70),
                SwitchListTile(
                  value: notificationEnabled,
                  activeColor: Colors.teal,
                  title: const Text('Persistent Smart Notification', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Access micro-tools directly from the phone status bar.', style: TextStyle(fontSize: 12)),
                  onChanged: onToggleNotification,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Active Floating Dock Preview:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252533),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.bolt, size: 16, color: Colors.amber),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Contexto Overlay Dock Preview',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 14, color: Colors.teal),
                      label: const Text('Quick Text Reply', style: TextStyle(fontSize: 12)),
                      onPressed: () {},
                      backgroundColor: const Color(0xFF1A1A24),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.monetization_on, size: 14, color: Colors.amber),
                      label: const Text('Impulse Check', style: TextStyle(fontSize: 12)),
                      onPressed: () {},
                      backgroundColor: const Color(0xFF1A1A24),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.kitchen, size: 14, color: Colors.orange),
                      label: const Text('Fridge Search', style: TextStyle(fontSize: 12)),
                      onPressed: () {},
                      backgroundColor: const Color(0xFF1A1A24),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF1E1E28),
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'System Permissions simulated: Display over apps permission active. Zero battery impact mode enabled.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ------------------- FLOATING PREVIEW BUBBLE -------------------
class FloatingPreviewBubble extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingPreviewBubble({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.amber, width: 1.5),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, color: Colors.amber, size: 18),
            SizedBox(width: 6),
            Text(
              'Contexto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}