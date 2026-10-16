import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OmniPopApp());
}

class OmniPopApp extends StatelessWidget {
  const OmniPopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniPop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFAFAFA),
      ),
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
  int _selectedTabIndex = 0;
  bool _isFloatingBubbleEnabled = true;
  Offset _bubblePosition = const Offset(20, 180);

  // Stats for user engagement tracking
  int _decisionsMade = 14;
  double _moneySaved = 42.50;
  int _scriptsCopied = 9;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                _buildEngagementHeader(),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTabIndex,
                    children: [
                      FridgeMealScreen(onMealLogged: () {
                        setState(() => _decisionsMade++);
                      }),
                      SocialScriptScreen(onScriptCopied: () {
                        setState(() => _scriptsCopied++);
                      }),
                      PriceCompareScreen(onDealSaved: (amount) {
                        setState(() => _moneySaved += amount);
                      }),
                      DecisionSpinnerScreen(onDecisionMade: () {
                        setState(() => _decisionsMade++);
                      }),
                      BillSplitterScreen(onSplitDone: () {
                        setState(() => _decisionsMade++);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Interactive Draggable Floating Assist Overlay Button
          if (_isFloatingBubbleEnabled)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _bubblePosition.dx + details.delta.dx;
                    double newY = _bubblePosition.dy + details.delta.dy;
                    // Keep floating bubble within bounds
                    newX = newX.clamp(10.0, screenSize.width - 70.0);
                    newY = newY.clamp(40.0, screenSize.height - 120.0);
                    _bubblePosition = Offset(newX, newY);
                  });
                },
                onTap: () => _openFloatingQuickSheet(context),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.widgets, color: Colors.white, size: 28),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Scripts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Decision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bill Split',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.stars, color: Colors.indigo, size: 24),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OmniPop',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                Text(
                  'Daily Micro-Assistant Active',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Text('Floating Pop', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              Switch(
                value: _isFloatingBubbleEnabled,
                activeColor: Colors.indigo,
                onChanged: (val) => setState(() => _isFloatingBubbleEnabled = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Decisions', '$_decisionsMade', Icons.check_circle_outline),
          Container(height: 20, width: 1, color: Colors.white70),
          _buildStatItem('Saved', '\$${_moneySaved.toStringAsFixed(2)}', Icons.monetization_on),
          Container(height: 20, width: 1, color: Colors.white70),
          _buildStatItem('Scripts', '$_scriptsCopied', Icons.content_copy),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  void _openFloatingQuickSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.widgets, color: Colors.indigo),
                SizedBox(width: 8),
                Text('OmniPop Quick Tools Overlay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Instant access micro-helpers for real-time daily decisions',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildQuickActionTile(
                  context,
                  title: 'Quick 50/50 Coin',
                  subtitle: 'Heads or Tails',
                  icon: Icons.monetization_on,
                  color: Colors.amber.shade700,
                  onTap: () {
                    Navigator.pop(ctx);
                    _showCoinFlipDialog(context);
                  },
                ),
                _buildQuickActionTile(
                  context,
                  title: 'Awkward Text Solver',
                  subtitle: 'Instant Polite Replies',
                  icon: Icons.chat,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _selectedTabIndex = 1);
                  },
                ),
                _buildQuickActionTile(
                  context,
                  title: 'Store Deal Checker',
                  subtitle: 'Unit Price Check',
                  icon: Icons.shopping_bag,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _selectedTabIndex = 2);
                  },
                ),
                _buildQuickActionTile(
                  context,
                  title: 'Fridge Meal Idea',
                  subtitle: 'Leftover Matcher',
                  icon: Icons.restaurant_menu,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _selectedTabIndex = 0);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCoinFlipDialog(BuildContext context) {
    bool isHeads = Random().nextBool();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Decision Coin', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: isHeads ? Colors.amber : Colors.blueGrey,
              child: Icon(
                isHeads ? Icons.star : Icons.shield,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isHeads ? 'HEADS - GO FOR IT!' : 'TAILS - WAIT / PASS',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: FRIDGE LEFTOVER MEAL MATCHER
// ============================================================================
class FridgeMealScreen extends StatefulWidget {
  final VoidCallback onMealLogged;
  const FridgeMealScreen({Key? key, required onMealLogged})
      : onMealLogged = onMealLogged,
        super(key: key);

  @override
  State<FridgeMealScreen> createState() => _FridgeMealScreenState();
}

class _FridgeMealScreenState extends State<FridgeMealScreen> {
  final List<String> _availableIngredients = [
    'Eggs', 'Rice', 'Bread', 'Cheese', 'Tomato', 'Milk', 'Chicken', 
    'Pasta', 'Potato', 'Onion', 'Garlic', 'Butter', 'Canned Beans'
  ];

  final Set<String> _selectedIngredients = {'Eggs', 'Bread', 'Cheese'};

  final List<Map<String, dynamic>> _allRecipes = [
    {
      'title': 'Cheesy Omelette Toast',
      'time': '5 mins',
      'difficulty': 'Easy',
      'ingredients': ['Eggs', 'Bread', 'Cheese', 'Butter'],
      'instructions': '1. Beat eggs with salt.\n2. Melt butter on pan and cook omelette.\n3. Add cheese and serve between toasted bread.',
    },
    {
      'title': 'Quick Fried Rice',
      'time': '8 mins',
      'difficulty': 'Easy',
      'ingredients': ['Rice', 'Eggs', 'Onion', 'Garlic'],
      'instructions': '1. Sauté garlic and onion in hot pan.\n2. Scramble egg on side, mix with leftover rice.\n3. Season with soy sauce or salt.',
    },
    {
      'title': 'Creamy Tomato Garlic Pasta',
      'time': '12 mins',
      'difficulty': 'Medium',
      'ingredients': ['Pasta', 'Tomato', 'Garlic', 'Cheese', 'Milk'],
      'instructions': '1. Boil pasta.\n2. Sauté minced garlic & tomato puree.\n3. Add splash of milk and stir in cheese.',
    },
    {
      'title': 'Loaded Stuffed Baked Potato',
      'time': '15 mins',
      'difficulty': 'Easy',
      'ingredients': ['Potato', 'Cheese', 'Butter', 'Onion'],
      'instructions': '1. Microwave potato for 6 mins until soft.\n2. Slice open, top with butter, chopped onion, and melted cheese.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> matchingRecipes = _getMatchingRecipes();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fridge Leftover Meal Matcher',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select ingredients you currently have to discover fast recipes.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Ingredient Selector Chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: _availableIngredients.map((item) {
                final isSelected = _selectedIngredients.contains(item);
                return FilterChip(
                  label: Text(item, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                  selected: isSelected,
                  selectedColor: Colors.indigo,
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedIngredients.add(item);
                      } else {
                        _selectedIngredients.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suggested Recipes (${matchingRecipes.length})',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                if (_selectedIngredients.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _selectedIngredients.clear()),
                    child: const Text('Clear All', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (matchingRecipes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off, color: Colors.orange, size: 36),
                    SizedBox(height: 8),
                    Text(
                      'No matching recipes found',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Try selecting more basic ingredients like Rice, Eggs, or Bread.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                children: matchingRecipes.map((recipe) => _buildRecipeCard(recipe)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMatchingRecipes() {
    return _allRecipes.where((recipe) {
      List<String> reqs = recipe['ingredients'] as List<String>;
      // Check if at least 2 ingredients match
      int matchCount = reqs.where((i) => _selectedIngredients.contains(i)).length;
      return matchCount >= 2;
    }).toList();
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    List<String> ingredients = recipe['ingredients'] as List<String>;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: const Icon(Icons.restaurant, color: Colors.indigo),
        ),
        title: Text(recipe['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Row(
          children: [
            const Icon(Icons.schedule, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text('${recipe['time']} • ${recipe['difficulty']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Required Ingredients:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: ingredients.map((ing) {
                    bool hasIt = _selectedIngredients.contains(ing);
                    return Chip(
                      labelStyle: TextStyle(fontSize: 10, color: hasIt ? Colors.green.shade900 : Colors.red.shade900),
                      backgroundColor: hasIt ? Colors.green.shade50 : Colors.red.shade50,
                      avatar: Icon(
                        hasIt ? Icons.check_circle : Icons.cancel,
                        size: 12,
                        color: hasIt ? Colors.green : Colors.red,
                      ),
                      label: Text(ing),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text('Quick Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  recipe['instructions'],
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      widget.onMealLogged();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cooked ${recipe['title']}! Added to history.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Mark as Cooked Today', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 2: SOCIAL SCRIPT & AWKWARD RESPONSE GENERATOR
// ============================================================================
class SocialScriptScreen extends StatefulWidget {
  final VoidCallback onScriptCopied;
  const SocialScriptScreen({Key? key, required onScriptCopied})
      : onScriptCopied = onScriptCopied,
        super(key: key);

  @override
  State<SocialScriptScreen> createState() => _SocialScriptScreenState();
}

class _SocialScriptScreenState extends State<SocialScriptScreen> {
  String _selectedCategory = 'Declining Invitations';
  String _selectedTone = 'Polite & Kind';

  final List<String> _categories = [
    'Declining Invitations',
    'Asking for Overdue Money',
    'Late Reply Apology',
    'Work Boundary / Overtime',
    'Rescheduling Plans',
  ];

  final List<String> _tones = ['Polite & Kind', 'Firm & Direct', 'Witty & Lighthearted', 'Professional'];

  final Map<String, Map<String, String>> _scriptDatabase = {
    'Declining Invitations': {
      'Polite & Kind': "Hey! Thanks so much for inviting me. I won't be able to make it this time due to prior commitments, but I really appreciate you thinking of me! Hope you all have an amazing time!",
      'Firm & Direct': "Thanks for the invite, but I won't be able to come. My schedule is full for that day.",
      'Witty & Lighthearted': "I'd love to say yes, but my social battery and schedule are begging for mercy today! Catch you next time for sure!",
      'Professional': "Thank you for the invitation. Regrettably, I have a prior commitment and will be unable to attend. I appreciate your thoughtful invitation.",
    },
    'Asking for Overdue Money': {
      'Polite & Kind': "Hey! Hope you're having a good week. Just following up on the \$[AMOUNT] from [EVENT/MEAL]. Whenever you have a quick moment, could you send that over? Thanks a lot!",
      'Firm & Direct': "Hi, just dropping a quick reminder for the \$[AMOUNT] owed for [EVENT]. Please send it through Venmo/Zelle today.",
      'Witty & Lighthearted': "Hey! My wallet is sending out a polite SOS call regarding that \$[AMOUNT] from the other day! Let me know when you send it over!",
      'Professional': "Hello, I am following up regarding the outstanding amount of \$[AMOUNT] for [EVENT]. Please transfer the balance when convenient.",
    },
    'Late Reply Apology': {
      'Polite & Kind': "Hi! So sorry for the delayed reply—it's been a super hectic couple of days. Regarding your message...",
      'Firm & Direct': "Apologies for the delay in responding. Here are the details you requested...",
      'Witty & Lighthearted': "My phone has been holding my messages hostage! Sorry for the delay!",
      'Professional': "Thank you for your patience. I am writing to respond to your inquiry...",
    },
    'Work Boundary / Overtime': {
      'Polite & Kind': "Thanks for reaching out! I've wrapped up for today, but I will make this my top priority first thing tomorrow morning.",
      'Firm & Direct': "I am currently offline for the day. I will address this during business hours tomorrow.",
      'Witty & Lighthearted': "My brain has officially entered weekend mode! I'll dive straight into this tomorrow morning.",
      'Professional': "I have received your request. I am currently away from my desk and will review this thoroughly during standard working hours tomorrow.",
    },
    'Rescheduling Plans': {
      'Polite & Kind': "Hey! I'm so sorry, but something urgent came up and I won't be able to make today work. Can we reschedule for later this week?",
      'Firm & Direct': "I need to move our meeting scheduled for today. Are you free same time next Tuesday?",
      'Witty & Lighthearted': "Life threw a plot twist my way today! Can we take a raincheck and reschedule?",
      'Professional': "Due to an unexpected scheduling conflict, I need to request a postponement of our scheduled meeting. Please let me know your availability for next week.",
    },
  };

  final TextEditingController _amountController = TextEditingController(text: "25.00");

  @override
  Widget build(BuildContext context) {
    String script = _scriptDatabase[_selectedCategory]?[_selectedTone] ?? "Select options above.";
    if (script.contains("\$[AMOUNT]")) {
      script = script.replaceAll("\$[AMOUNT]", "\$${_amountController.text.isEmpty ? "0.00" : _amountController.text}");
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Social Script Generator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Solve awkward social texts with pre-formatted, polite, or direct scripts.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            const Text('Scenario Category:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_selectedCategory == 'Asking for Overdue Money') ...[
              const Text('Amount Owed (\$):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: 'e.g. 25.00',
                ),
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 12),
            ],

            const Text('Desired Tone:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _tones.map((tone) {
                bool isSel = _selectedTone == tone;
                return ChoiceChip(
                  label: Text(tone, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : Colors.black87)),
                  selected: isSel,
                  selectedColor: Colors.teal,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedTone = tone);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Script Box Result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, color: Colors.teal.shade800, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Ready Script',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal.shade900, fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(_selectedTone, style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    script,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: script));
                            widget.onScriptCopied();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied script to clipboard!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy to Clipboard', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 3: SMART GROCERY UNIT PRICE COMPARISON
// ============================================================================
class PriceCompareScreen extends StatefulWidget {
  final Function(double) onDealSaved;
  const PriceCompareScreen({Key? key, required this.onDealSaved}) : super(key: key);

  @override
  State<PriceCompareScreen> createState() => _PriceCompareScreenState();
}

class _PriceCompareScreenState extends State<PriceCompareScreen> {
  final TextEditingController _priceAController = TextEditingController(text: "8.99");
  final TextEditingController _unitAController = TextEditingController(text: "500");

  final TextEditingController _priceBController = TextEditingController(text: "14.50");
  final TextEditingController _unitBController = TextEditingController(text: "900");

  String _unitType = 'Grams (g)';
  final List<String> _unitTypes = ['Grams (g)', 'Ounces (oz)', 'Milliliters (ml)', 'Count / Items'];

  @override
  Widget build(BuildContext context) {
    double priceA = double.tryParse(_priceAController.text) ?? 0;
    double unitA = double.tryParse(_unitAController.text) ?? 1;

    double priceB = double.tryParse(_priceBController.text) ?? 0;
    double unitB = double.tryParse(_unitBController.text) ?? 1;

    double unitPriceA = priceA / (unitA > 0 ? unitA : 1);
    double unitPriceB = priceB / (unitB > 0 ? unitB : 1);

    bool isABetter = unitPriceA < unitPriceB;
    double diffPercent = 0.0;
    if (unitPriceA > 0 && unitPriceB > 0) {
      double higher = isABetter ? unitPriceB : unitPriceA;
      double lower = isABetter ? unitPriceA : unitPriceB;
      diffPercent = ((higher - lower) / higher) * 100;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grocery Deal & Unit Price Saver',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Find out which box or deal is actually cheaper per unit before buying.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text('Measurement Unit: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _unitType,
                        isDense: true,
                        items: _unitTypes
                            .map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _unitType = val);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _buildItemInputBox('Option A', _priceAController, _unitAController, isABetter)),
                const SizedBox(width: 12),
                Expanded(child: _buildItemInputBox('Option B', _priceBController, _unitBController, !isABetter)),
              ],
            ),
            const SizedBox(height: 20),

            // Summary Results Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isABetter ? Colors.green.shade50 : Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isABetter ? Colors.green.shade300 : Colors.purple.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, color: isABetter ? Colors.green.shade800 : Colors.purple.shade800),
                      const SizedBox(width: 6),
                      Text(
                        isABetter ? 'OPTION A IS CHEAPER!' : 'OPTION B IS CHEAPER!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isABetter ? Colors.green.shade900 : Colors.purple.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Saves ~${diffPercent.toStringAsFixed(1)}% per unit compared to the other package.',
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildUnitPriceText('A Unit Cost', '\$${unitPriceA.toStringAsFixed(4)}'),
                      _buildUnitPriceText('B Unit Cost', '\$${unitPriceB.toStringAsFixed(4)}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isABetter ? Colors.green.shade800 : Colors.purple.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      double savedApprox = (priceA - priceB).abs() * 0.25;
                      if (savedApprox <= 0) savedApprox = 1.20;
                      widget.onDealSaved(savedApprox);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logged \$${savedApprox.toStringAsFixed(2)} savings!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark, size: 16),
                    label: const Text('Log Deal & Add Savings', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemInputBox(
    String title,
    TextEditingController priceCtrl,
    TextEditingController unitCtrl,
    bool isWinner,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isWinner ? Colors.green : Colors.grey.shade300, width: isWinner ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              if (isWinner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                  child: const Text('BEST VALUE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Price (\$)', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: priceCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              isDense: true,
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 10),
          const Text('Qty / Size', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: unitCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              isDense: true,
            ),
            onChanged: (v) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitPriceText(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ============================================================================
// TAB 4: DECISION SPINNER & ARENA
// ============================================================================
class DecisionSpinnerScreen extends StatefulWidget {
  final VoidCallback onDecisionMade;
  const DecisionSpinnerScreen({Key? key, required this.onDecisionMade}) : super(key: key);

  @override
  State<DecisionSpinnerScreen> createState() => _DecisionSpinnerScreenState();
}

class _DecisionSpinnerScreenState extends State<DecisionSpinnerScreen> {
  final List<String> _options = ['Pizza', 'Sushi', 'Burgers', 'Tacos', 'Home Cooked'];
  final TextEditingController _addOptionController = TextEditingController();
  String? _winningOption;
  bool _isSpinning = false;

  void _spinChoice() async {
    if (_options.isEmpty) return;
    setState(() {
      _isSpinning = true;
      _winningOption = null;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    final random = Random();
    final selected = _options[random.nextInt(_options.length)];

    setState(() {
      _winningOption = selected;
      _isSpinning = false;
    });
    widget.onDecisionMade();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Micro-Decision Arena',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Stop overthinking micro-choices. Add options and let the engine decide!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addOptionController,
                    decoration: const InputDecoration(
                      hintText: 'Add new option (e.g. Thai Food)...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onPressed: () {
                    if (_addOptionController.text.trim().isNotEmpty) {
                      setState(() {
                        _options.add(_addOptionController.text.trim());
                        _addOptionController.clear();
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text('Current Choice Pool:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _options.map((opt) {
                return Chip(
                  label: Text(opt, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.indigo.shade50,
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () {
                    setState(() => _options.remove(opt));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Spin Arena Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                children: [
                  Icon(
                    _isSpinning ? Icons.refresh : Icons.casino,
                    size: 48,
                    color: Colors.amber.shade900,
                  ),
                  const SizedBox(height: 12),
                  if (_isSpinning)
                    const Text('Randomizing choice...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  else if (_winningOption != null)
                    Column(
                      children: [
                        const Text('DECISION MADE:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          _winningOption!,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  else
                    const Text('Tap below to make a quick choice!', style: TextStyle(fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isSpinning ? null : _spinChoice,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('PICK FOR ME NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 5: FAIR BILL & ITEMIZED SPLITTER
// ============================================================================
class BillSplitterScreen extends StatefulWidget {
  final VoidCallback onSplitDone;
  const BillSplitterScreen({Key? key, required this.onSplitDone}) : super(key: key);

  @override
  State<BillSplitterScreen> createState() => _BillSplitterScreenState();
}

class _BillSplitterScreenState extends State<BillSplitterScreen> {
  final TextEditingController _totalBillController = TextEditingController(text: "120.00");
  int _peopleCount = 4;
  double _tipPercentage = 15.0;

  @override
  Widget build(BuildContext context) {
    double totalBill = double.tryParse(_totalBillController.text) ?? 0.0;
    double tipAmount = totalBill * (_tipPercentage / 100);
    double finalTotal = totalBill + tipAmount;
    double perPerson = _peopleCount > 0 ? finalTotal / _peopleCount : 0.0;

    String summaryString = "Group Bill Split Summary:\n"
        "Total Bill: \$${totalBill.toStringAsFixed(2)}\n"
        "Tip (${_tipPercentage.toInt()}%): \$${tipAmount.toStringAsFixed(2)}\n"
        "Grand Total: \$${finalTotal.toStringAsFixed(2)}\n"
        "--------------------\n"
        "Each Person Pays ($_peopleCount people): \$${perPerson.toStringAsFixed(2)}";

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fair Bill & Tip Splitter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Instantly split dining or event bills fairly with tips and shareable summary.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            const Text('Total Bill Amount (\$):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _totalBillController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onChanged: (v) => setState(() {}),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of People:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_peopleCount > 1) setState(() => _peopleCount--);
                      },
                    ),
                    Text('$_peopleCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _peopleCount++),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tip Percentage:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('${_tipPercentage.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              ],
            ),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 30,
              divisions: 6,
              activeColor: Colors.indigo,
              label: '${_tipPercentage.toInt()}%',
              onChanged: (val) => setState(() => _tipPercentage = val),
            ),
            const SizedBox(height: 16),

            // Per Person Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade200),
              ),
              child: Column(
                children: [
                  const Text('EACH PERSON PAYS', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    '\$${perPerson.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBillSummaryText('Base Total', '\$${totalBill.toStringAsFixed(2)}'),
                      _buildBillSummaryText('Tip Total', '\$${tipAmount.toStringAsFixed(2)}'),
                      _buildBillSummaryText('Grand Total', '\$${finalTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: summaryString));
                      widget.onSplitDone();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied bill split breakdown to clipboard!'),
                          backgroundColor: Colors.indigo,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Copy Breakdown String', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillSummaryText(String title, String val) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}