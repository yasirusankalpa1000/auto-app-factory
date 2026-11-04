import 'package:flutter/material.dart';

void main() {
  runApp(const ContextMateApp());
}

class ContextMateApp extends StatelessWidget {
  const ContextMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'ContextMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121420),
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
  int _currentIndex = 0;
  bool _overlayEnabled = true;
  bool _notificationEnabled = true;
  String _activeSnippet = "Copied: Quick Reply #1";

  // Dynamic status snackbar alert helper
  void _showNotice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Floating Overlay Status Simulation Banner
            if (_overlayEnabled)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "ContextMate Floating Dock Active",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _activeSnippet,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                      onPressed: () {
                        setState(() {
                          _overlayEnabled = false;
                        });
                      },
                    ),
                  ],
                ),
              ),

            // Tab View Body
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  SmartTextRewriterTab(onCopy: (txt) {
                    setState(() => _activeSnippet = "Ready: $txt");
                    _showNotice("Text copied & synced to floating dock!");
                  }),
                  const ImpulseBuyCalculatorTab(),
                  SocialRescueTab(onTriggerCall: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => const FakeIncomingCallScreen(),
                      ),
                    );
                  }),
                  ClipboardAndOverlayTab(
                    overlayEnabled: _overlayEnabled,
                    notificationEnabled: _notificationEnabled,
                    onToggleOverlay: (v) => setState(() => _overlayEnabled = v),
                    onToggleNotification: (v) => setState(() => _notificationEnabled = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: const Color(0xFF1B1E2F),
        indicatorColor: Colors.indigoAccent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.psychology, color: Colors.white70),
            selectedIcon: Icon(Icons.psychology, color: Colors.white),
            label: "Smart Text",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag, color: Colors.white70),
            selectedIcon: Icon(Icons.shopping_bag, color: Colors.white),
            label: "Impulse Check",
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_callback, color: Colors.white70),
            selectedIcon: Icon(Icons.phone_callback, color: Colors.white),
            label: "Social Rescue",
          ),
          NavigationDestination(
            icon: Icon(Icons.layers, color: Colors.white70),
            selectedIcon: Icon(Icons.layers, color: Colors.white),
            label: "Dock & Snippets",
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: SMART TEXT & RESPONSE REWRITER
// -----------------------------------------------------------------------------
class SmartTextRewriterTab extends StatefulWidget {
  final Function(String) onCopy;
  const SmartTextRewriterTab({Key? key, required me, required this.onCopy}) : super(key: key);

  @override
  State<SmartTextRewriterTab> createState() => _SmartTextRewriterTabState();
}

class _SmartTextRewriterTabState extends State<SmartTextRewriterTab> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedTone = "Polite Refusal";
  String _generatedOutput = "";

  final List<String> _tones = [
    "Polite Refusal",
    "Professional",
    "Witty Excuse",
    "Direct & Firm",
    "Apologetic",
  ];

  final Map<String, List<String>> _quickTemplates = {
    "Polite Refusal": [
      "I won't be able to make it this time, but thanks so much for thinking of me!",
      "I'm currently at max capacity, so I'll have to pass on this for now.",
      "Unfortunately, I have prior commitments, but let's connect another time!"
    ],
    "Professional": [
      "Thank you for reaching out. I have reviewed the details and will follow up shortly.",
      "Per my previous email, please let me know if you need further clarification.",
      "I appreciate the update and will make sure this is addressed by EOD."
    ],
    "Witty Excuse": [
      "My social battery is currently at 1% and charging slow. Next time for sure!",
      "I checked with my inner cat, and we decided staying home is mandatory today.",
      "I promised my couch I wouldn't cheat on it tonight!"
    ],
    "Direct & Firm": [
      "No, I cannot lend money right now. Please do not ask again.",
      "I'm not interested, but thanks for asking.",
      "That deadline is impossible without reducing scope. Let's fix the timeline."
    ],
    "Apologetic": [
      "I am so sorry for the delay! Running 15 minutes late due to traffic.",
      "Sincere apologies for missing that detail in the earlier draft.",
      "I completely messed up the timing. So sorry for causing any trouble!"
    ],
  };

  void _generateText() {
    FocusScope.of(context).unfocus();
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      final samples = _quickTemplates[_selectedTone] ?? ["Sample response generated!"];
      setState(() {
        _generatedOutput = samples[DateTime.now().second % samples.length];
      });
      return;
    }

    if (_selectedTone == "Polite Refusal") {
      _generatedOutput = "Regarding '$text': Thank you so much for bringing this up! However, I won't be able to commit to this right now. Hope you understand!";
    } else if (_selectedTone == "Professional") {
      _generatedOutput = "Dear Team/Name, regarding '$text', I have noted the details and am taking appropriate steps. I will update you once finalized.";
    } else if (_selectedTone == "Witty Excuse") {
      _generatedOutput = "I'd love to help with '$text', but my calendar just started crying. Let's touch base when things settle!";
    } else if (_selectedTone == "Direct & Firm") {
      _generatedOutput = "I need to be clear about '$text': I cannot proceed with this under current conditions. Let's adjust parameters first.";
    } else {
      _generatedOutput = "I deeply apologize regarding '$text'. I am taking immediate action to rectify this right away.";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: Colors.indigoAccent, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Smart Response & Polisher",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Draft awkward messages, refusals, or work emails instantly with perfect tone.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Tone Selection Badges
            const Text(
              "Select Desired Tone:",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tones.map((tone) {
                final isSelected = tone == _selectedTone;
                return ChoiceChip(
                  label: Text(tone),
                  selected: isSelected,
                  selectedColor: Colors.indigoAccent,
                  backgroundColor: const Color(0xFF23273B),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedTone = tone);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Input Field
            TextField(
              controller: _inputController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Type raw thought (e.g., 'I can't go to party tonight' or 'Give me raise')...",
                hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                filled: true,
                fillColor: Color(0xFF1B1E2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _generateText,
                icon: const Icon(Icons.bolt, color: Colors.white),
                label: const Text(
                  "Polish & Generate Response",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Preset Suggestions
            const Text(
              "Instant Quick Presets:",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: (_quickTemplates[_selectedTone] ?? []).map((preset) {
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1E2F),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.indigo.shade800),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preset,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => widget.onCopy(preset),
                          child: const Row(
                            children: [
                              Icon(Icons.copy, color: Colors.indigoAccent, size: 14),
                              SizedBox(width: 4),
                              Text(
                                "Copy",
                                style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            if (_generatedOutput.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2238),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigoAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Generated Result",
                          style: TextStyle(
                            color: Colors.indigoAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.white, size: 20),
                          onPressed: () => widget.onCopy(_generatedOutput),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _generatedOutput,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: IMPULSE BUY REALITY CHECK CALCULATOR
// -----------------------------------------------------------------------------
class ImpulseBuyCalculatorTab extends StatefulWidget {
  const ImpulseBuyCalculatorTab({Key? key}) : super(key: key);

  @override
  State<ImpulseBuyCalculatorTab> createState() => _ImpulseBuyCalculatorTabState();
}

class _ImpulseBuyCalculatorTabState extends State<ImpulseBuyCalculatorTab> {
  final TextEditingController _incomeController = TextEditingController(text: "3200");
  final TextEditingController _hoursController = TextEditingController(text: "40");
  final TextEditingController _itemNameController = TextEditingController(text: "Wireless Earbuds");
  final TextEditingController _itemPriceController = TextEditingController(text: "180");

  double _hourlyRate = 0;
  double _hoursNeeded = 0;
  double _financialRegretScore = 0;
  String _verdictText = "";

  @override
  void initState() {
    super.initState();
    _calculateReality();
  }

  void _calculateReality() {
    final double income = double.tryParse(_incomeController.text) ?? 1;
    final double weeklyHours = double.tryParse(_hoursController.text) ?? 1;
    final double price = double.tryParse(_itemPriceController.text) ?? 0;

    // Monthly hours = weekly hours * 4.33
    final monthlyHours = weeklyHours * 4.33;
    final hourlyWage = income / (monthlyHours <= 0 ? 1 : monthlyHours);
    final hoursToEarn = price / (hourlyWage <= 0 ? 1 : hourlyWage);

    // Regret score calculated based on income ratio
    final ratio = (price / (income <= 0 ? 1 : income)) * 100;
    double regret = (ratio * 2.5).clamp(5, 99);

    String advice = "";
    if (hoursToEarn > 40) {
      advice = "⚠️ HIGH IMPULSE RISK: Requires more than a FULL WEEK of continuous hard labor!";
    } else if (hoursToEarn > 15) {
      advice = "⚡ MODERATE RISK: You must trade nearly 2 full workdays for this single item.";
    } else {
      advice = "✅ LOW FINANCIAL STRESS: Requires less than a day of work. Safe if needed!";
    }

    setState(() {
      _hourlyRate = hourlyWage;
      _hoursNeeded = hoursToEarn;
      _financialRegretScore = regret;
      _verdictText = advice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: Colors.deepOrangeAccent, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Impulse Buy Reality Check",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Convert price tags into exact hours of work you must trade from your life.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Form Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _incomeController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Monthly Income (\$)",
                      labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      filled: true,
                      fillColor: Color(0xFF1B1E2F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (_) => _calculateReality(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Hours / Week",
                      labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      filled: true,
                      fillColor: Color(0xFF1B1E2F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (_) => _calculateReality(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      filled: true,
                      fillColor: Color(0xFF1B1E2F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _itemPriceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Price (\$)",
                      labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      filled: true,
                      fillColor: Color(0xFF1B1E2F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (_) => _calculateReality(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reality Score Display Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepOrangeAccent.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Net Hourly Wage",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "\$${_hourlyRate.toStringAsFixed(2)} / hr",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Work Hours Required",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            "${_hoursNeeded.toStringAsFixed(1)} Hours",
                            style: const TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Financial Stress Index:",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        "${_financialRegretScore.toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: _financialRegretScore > 50 ? Colors.redAccent : Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_financialRegretScore / 100).clamp(0.0, 1.0),
                    backgroundColor: Colors.white70,
                    color: _financialRegretScore > 50 ? Colors.redAccent : Colors.greenAccent,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _verdictText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: SOCIAL RESCUE & FAKE CALL SIMULATOR
// -----------------------------------------------------------------------------
class SocialRescueTab extends StatefulWidget {
  final VoidCallback onTriggerCall;
  const SocialRescueTab({Key? key, required this.onTriggerCall}) : super(key: key);

  @override
  State<SocialRescueTab> createState() => _SocialRescueTabState();
}

class _SocialRescueTabState extends State<SocialRescueTab> {
  String _selectedCaller = "Urgent Work Call";
  int _delaySeconds = 3;
  bool _isCountdownActive = false;
  int _currentCountdown = 0;

  final List<String> _callerPresets = [
    "Urgent Work Call",
    "Landlord Inspection",
    "Doctor Appointment",
    "Family Emergency",
    "Delivery Driver",
  ];

  void _startTimerAndTrigger() async {
    setState(() {
      _isCountdownActive = true;
      _currentCountdown = _delaySeconds;
    });

    for (int i = _delaySeconds; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _currentCountdown = i - 1;
      });
    }

    if (mounted) {
      setState(() {
        _isCountdownActive = false;
      });
      widget.onTriggerCall();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone_callback, color: Colors.greenAccent, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Social Awkwardness Rescue",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Trigger a realistic incoming emergency call to politely excuse yourself.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 20),

            const Text(
              "Select Caller Identity:",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Column(
              children: _callerPresets.map((caller) {
                final isSelected = caller == _selectedCaller;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? Colors.greenAccent : Colors.white70,
                      ),
                    ),
                    tileColor: const Color(0xFF1B1E2F),
                    leading: Icon(
                      Icons.person_pin,
                      color: isSelected ? Colors.greenAccent : Colors.white70,
                    ),
                    title: Text(
                      caller,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.greenAccent)
                        : null,
                    onTap: () => setState(() => _selectedCaller = caller),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Text(
              "Trigger Delay:",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [3, 5, 10, 30].map((sec) {
                final isSelected = _delaySeconds == sec;
                return ChoiceChip(
                  label: Text("${sec}s Delay"),
                  selected: isSelected,
                  selectedColor: Colors.green,
                  backgroundColor: const Color(0xFF23273B),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  onSelected: (v) {
                    if (v) setState(() => _delaySeconds = sec);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isCountdownActive ? Colors.orange : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isCountdownActive ? null : _startTimerAndTrigger,
                icon: Icon(
                  _isCountdownActive ? Icons.hourglass_top : Icons.ring_volume,
                  color: Colors.white,
                ),
                label: Text(
                  _isCountdownActive
                      ? "Rescue incoming in $_currentCountdown seconds..."
                      : "Trigger Fake Call Now",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FAKE INCOMING CALL OVERLAY SCREEN
// -----------------------------------------------------------------------------
class FakeIncomingCallScreen extends StatelessWidget {
  const FakeIncomingCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 64, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Urgent Work Call",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Incoming Rescue Call...",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Decline Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 8),
                        const Text("Decline", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  // Accept Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Call Answered! Take your exit opportunity now."),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.call, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 8),
                        const Text("Accept", style: TextStyle(color: Colors.white70)),
                      ],
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

// -----------------------------------------------------------------------------
// TAB 4: SYSTEM OVERLAY & CLIPBOARD HUB
// -----------------------------------------------------------------------------
class ClipboardAndOverlayTab extends StatefulWidget {
  final bool overlayEnabled;
  final bool notificationEnabled;
  final ValueChanged<bool> onToggleOverlay;
  final ValueChanged<bool> onToggleNotification;

  const ClipboardAndOverlayTab({
    Key? key,
    required this.overlayEnabled,
    required this.notificationEnabled,
    required this.onToggleOverlay,
    required this.onToggleNotification,
  }) : super(key: key);

  @override
  State<ClipboardAndOverlayTab> createState() => _ClipboardAndOverlayTabState();
}

class _ClipboardAndOverlayTabState extends State<ClipboardAndOverlayTab> {
  final List<String> _pinnedSnippets = [
    "My Address: 742 Evergreen Terrace, Springfield",
    "Tax ID / SSN: XX-XXX-9821",
    "IBAN/Account: US91 2281 9901 2231 09",
    "WiFi Pass: SecureGuest2025!",
  ];

  final TextEditingController _snippetController = TextEditingController();

  void _addSnippet() {
    if (_snippetController.text.trim().isNotEmpty) {
      setState(() {
        _pinnedSnippets.add(_snippetController.text.trim());
        _snippetController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.layers, color: Colors.amberAccent, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Dock & System Settings",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Manage persistent overlay controls and 1-tap fast pinned clipboard snippets.",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Switches
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B1E2F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Display Above Apps (Floating Banner)", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("Simulates floating active shortcut dynamic widget", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    value: widget.overlayEnabled,
                    activeColor: Colors.amberAccent,
                    onChanged: widget.onToggleOverlay,
                  ),
                  const Divider(color: Colors.white70, height: 1),
                  SwitchListTile(
                    title: const Text("Floating Notifications Permission", style: TextStyle(color: Colors.white)),
                    subtitle: const Text("Enable emergency alert triggers & quick actions", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    value: widget.notificationEnabled,
                    activeColor: Colors.amberAccent,
                    onChanged: widget.onToggleNotification,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Pinned Quick Snippets (1-Tap Copy):",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _snippetController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Add snippet (Address, Account #)...",
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                      filled: true,
                      fillColor: Color(0xFF1B1E2F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.amberAccent),
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: _addSnippet,
                ),
              ],
            ),
            const SizedBox(height: 12),

            Column(
              children: _pinnedSnippets.asMap().entries.map((entry) {
                final idx = entry.key;
                final text = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1E2F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pin_drop, color: Colors.amberAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied snippet: $text")),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          setState(() {
                            _pinnedSnippets.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}