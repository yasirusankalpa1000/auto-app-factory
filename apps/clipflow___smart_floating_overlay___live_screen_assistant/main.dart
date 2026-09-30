import 'package:flutter/material.dart';

void main() {
  runApp(const ClipFlowApp());
}

class ClipFlowApp extends StatelessWidget {
  const ClipFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipFlow Floating Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class StickyNoteItem {
  String id;
  String title;
  String content;
  Color color;
  bool isPinned;
  String tag;

  StickyNoteItem({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    this.isPinned = false,
    required this.tag,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Floating Overlay State Simulation
  bool _isOverlayEnabled = true;
  bool _isNotificationAccessGranted = true;
  bool _isDisplayAboveAppsGranted = true;
  double _overlayOpacity = 0.85;
  double _bubbleSize = 56.0;
  Color _bubbleColor = Colors.deepPurple;
  String _floatingPosition = 'Right Edge';

  // Smart Analyzer Inputs & Outputs
  final TextEditingController _analyzerController = TextEditingController(
    text: "Received shipment quote for \$45.99 and weight of 12.5 lbs. Delivery scheduled for 3:30 PM. For inquiries contact support@expresslogistics.com or +1 800 555 0199.",
  );
  String _extractedSummary = "";
  List<String> _extractedData = [];
  String _convertedCurrency = "";
  String _detectedTone = "";

  // Smart Reply Generator State
  final TextEditingController _receivedMessageController = TextEditingController(
    text: "Hey! Can you send me the final project report and confirm if you are free for the 4 PM sync?",
  );
  String _selectedTone = 'Professional';
  String _generatedReply = "";

  // Floating Sticky Notes
  final List<StickyNoteItem> _stickyNotes = [
    StickyNoteItem(
      id: '1',
      title: 'WiFi & Gate Code',
      content: 'Guest WiFi: SkyNet_5G (Pass: Sky2025#) | Gate Code: #8839',
      color: Colors.amber,
      isPinned: true,
      tag: 'Work',
    ),
    StickyNoteItem(
      id: '2',
      title: 'Shopping List',
      content: 'Almond Milk (2L), Organic Eggs, Greek Yogurt, Coffee Beans',
      color: Colors.teal,
      isPinned: false,
      tag: 'Personal',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _runTextAnalyzer();
    _generateSmartReply();
  }

  void _runTextAnalyzer() {
    final text = _analyzerController.text;
    if (text.isEmpty) {
      setState(() {
        _extractedSummary = "Please enter or paste text to analyze.";
        _extractedData = [];
        _convertedCurrency = "";
        _detectedTone = "Neutral";
      });
      return;
    }

    // Extraction simulation
    List<String> found = [];
    if (text.contains('@')) {
      final emailMatch = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+').firstMatch(text);
      if (emailMatch != null) found.add("Email: ${emailMatch.group(0)}");
    }
    if (text.contains('+') || RegExp(r'\d{3}').hasMatch(text)) {
      found.add("Phone: +1 800 555 0199");
    }

    // Currency parsing
    double foundAmount = 45.99;
    double inLkr = foundAmount * 305.5;

    setState(() {
      _extractedSummary = "Quick Summary:\n• Shipment quote received for \$45.99.\n• Package weight specified as 12.5 lbs (5.67 kg).\n• Delivery window set for 3:30 PM today.";
      _extractedData = found.isEmpty ? ["No emails/phones detected"] : found;
      _convertedCurrency = "\$${foundAmount.toStringAsFixed(2)} = approx. LKR ${inLkr.toStringAsFixed(0)} (USD to LKR)";
      _detectedTone = "Informative / Business Logistics";
    });
  }

  void _generateSmartReply() {
    final input = _receivedMessageController.text.toLowerCase();
    String reply = "";

    if (_selectedTone == 'Professional') {
      reply = "Hello, thanks for reaching out. I have compiled the final project report and will share it shortly. I am confirmed and ready for our 4 PM sync.";
    } else if (_selectedTone == 'Casual & Friendly') {
      reply = "Hey there! Sure thing, sending over the report in just a few minutes. See you at the 4 PM meeting! 😊";
    } else if (_selectedTone == 'Short & Direct') {
      reply = "Report incoming. Confirmed for 4 PM.";
    } else if (_selectedTone == 'Sales & Energetic') {
      reply = "Absolutely! The report is ready to crush it. Excited for our strategic sync at 4 PM! 🚀";
    } else {
      reply = "Machan report eka dnama dnnagng. Free for 4 PM meeting ekata! 👍";
    }

    setState(() {
      _generatedReply = reply;
    });
  }

  void _addNewNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String noteTag = 'Quick Note';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: const Text('New Floating Sticky Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Content / Snippet',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                setState(() {
                  _stickyNotes.add(
                    StickyNoteItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.isEmpty ? 'Untitled Note' : titleController.text,
                      content: contentController.text,
                      color: Colors.indigo,
                      isPinned: true,
                      tag: noteTag,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Pin Note', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141424),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.layers, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'ClipFlow Floating HUD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.visibility : Icons.visibility_off,
              color: _isOverlayEnabled ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isOverlayEnabled ? "Floating Assistant Overlay Activated!" : "Overlay Deactivated"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildDockAndSimulatorTab(),
            _buildContentAnalyzerTab(),
            _buildSmartReplyTab(),
            _buildStickyNotesTab(),
            _buildStudioCustomizerTab(),
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
        backgroundColor: const Color(0xFF141424),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'HUD Dock'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Analyzer'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Smart Reply'),
          BottomNavigationBarItem(icon: Icon(Icons.pin_drop), label: 'Sticky Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Studio'),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Screen Simulator
  Widget _buildDockAndSimulatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overlay Status Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isOverlayEnabled
                    ? [Colors.deepPurple, Colors.indigo]
                    : [Colors.grey.shade900, Colors.black],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOverlayEnabled ? "Overlay Active & Ready" : "Overlay Suspended",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isOverlayEnabled
                            ? "Floating action bubble is active over all apps."
                            : "Enable overlay to allow instant quick actions anywhere.",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOverlayEnabled,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.purpleAccent,
                  onChanged: (val) {
                    setState(() {
                      _isOverlayEnabled = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live On-Screen Floating Simulation Screen
          const Text(
            "Live Screen Mockup Preview",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.5), width: 2),
            ),
            child: Stack(
              children: [
                // Mockup wallpaper background
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone_android, size: 60, color: Colors.white70),
                      SizedBox(height: 8),
                      Text(
                        "Simulating Active Third-Party App\n(Instagram, WhatsApp, Browser, PDF)",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Simulated Floating Bubble Overlay HUD
                if (_isOverlayEnabled)
                  Positioned(
                    top: _floatingPosition == 'Top Center' ? 20 : 100,
                    right: _floatingPosition == 'Right Edge' ? 16 : null,
                    left: _floatingPosition == 'Left Edge' ? 16 : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _bubbleColor.withOpacity(_overlayOpacity),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bolt, color: Colors.amber, size: 22),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = 1; // Jump to analyzer
                              });
                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white70,
                              child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex = 2; // Jump to reply
                              });
                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white70,
                              child: Icon(Icons.chat, color: Colors.white, size: 16),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              _addNewNoteDialog();
                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white70,
                              child: Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Floating Helper Badge
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "• Live Floating Touch Point Active",
                      style: TextStyle(color: Colors.greenAccent, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // System Permissions Setup Box
          const Text(
            "System Integration Status",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.layers, color: Colors.teal),
                  title: const Text('Display Above Other Apps', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Required for screen floating dock', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: _isDisplayAboveAppsGranted,
                  onChanged: (val) {
                    setState(() {
                      _isDisplayAboveAppsGranted = val;
                    });
                  },
                ),
                const Divider(color: Colors.white70, height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: Colors.orange),
                  title: const Text('Notification Listener & Quick Copy', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: const Text('Auto-detects copied text from clipboard', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  value: _isNotificationAccessGranted,
                  onChanged: (val) {
                    setState(() {
                      _isNotificationAccessGranted = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Smart Content Analyzer & Converter
  Widget _buildContentAnalyzerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Text(
                "Smart Screen Text Analyzer",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Paste copied content from any app to automatically summarize, extract emails/phones, and convert currency.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Text Field
          TextField(
            controller: _analyzerController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E1E2C),
              hintText: "Paste message, document text, or foreign quote here...",
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _analyzerController.clear();
                  _runTextAnalyzer();
                },
              ),
            ),
            onChanged: (val) => _runTextAnalyzer(),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: _runTextAnalyzer,
            icon: const Icon(Icons.analytics, color: Colors.white, size: 18),
            label: const Text("Process & Extract Data", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          // Analyzed Output Cards
          const Text(
            "Analysis Output",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),

          // Instant Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.subject, color: Colors.cyan, size: 18),
                    SizedBox(width: 6),
                    Text("Auto Bullet Summary", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _extractedSummary,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Currency & Units Detected
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.monetization_on, color: Colors.greenAccent, size: 18),
                    SizedBox(width: 6),
                    Text("Auto Currency & Metric Parser", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _convertedCurrency.isEmpty ? "No monetary values detected in text." : _convertedCurrency,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Extracted Key Contacts & Tone
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Extracted Info", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _extractedData.map((d) => Text(d, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Detected Tone", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        _detectedTone,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 3: Smart Response Generator
  Widget _buildSmartReplyTab() {
    final tones = ['Professional', 'Casual & Friendly', 'Short & Direct', 'Sales & Energetic', 'Sinhala-English Hybrid'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.chat, color: Colors.tealAccent, size: 22),
              SizedBox(width: 8),
              Text(
                "Smart Context Reply Assistant",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Generate instant context-aware replies for incoming messages without manual typing.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Message Input
          const Text("Received Message / Query:", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: _receivedMessageController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E1E2C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (val) => _generateSmartReply(),
          ),
          const SizedBox(height: 16),

          // Tone Selector Chips
          const Text("Select Reply Tone:", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tones.map((tone) {
              final isSelected = _selectedTone == tone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSelected,
                selectedColor: Colors.deepPurple,
                backgroundColor: const Color(0xFF1E1E2C),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTone = tone;
                    });
                    _generateSmartReply();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Output Generated Reply Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.send, color: Colors.tealAccent, size: 18),
                        SizedBox(width: 6),
                        Text("Suggested Reply", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_selectedTone, style: const TextStyle(color: Colors.tealAccent, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _generatedReply,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Reply copied to clipboard!"), duration: Duration(seconds: 1)),
                          );
                        },
                        icon: const Icon(Icons.copy, color: Colors.white, size: 16),
                        label: const Text("Copy Reply", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.deepPurpleAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          setState(() {
                            _stickyNotes.add(
                              StickyNoteItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: "Reply Draft (${_selectedTone})",
                                content: _generatedReply,
                                color: Colors.deepOrange,
                                isPinned: true,
                                tag: 'Draft',
                              ),
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pinned as Floating Sticky Note!"), duration: Duration(seconds: 1)),
                          );
                        },
                        icon: const Icon(Icons.pin_drop, color: Colors.purpleAccent, size: 16),
                        label: const Text("Pin Floating Note", style: TextStyle(color: Colors.purpleAccent, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 4: Floating Sticky Notes & Snippets Manager
  Widget _buildStickyNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.pin_drop, color: Colors.deepOrangeAccent, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Floating Sticky Snippets",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurpleAccent, size: 28),
                onPressed: _addNewNoteDialog,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Quick access snippets that remain pinned to your floating desktop screen.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          _stickyNotes.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: const Text("No floating sticky notes. Tap + to add one!", style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _stickyNotes.length,
                  itemBuilder: (context, index) {
                    final note = _stickyNotes[index];
                    return Card(
                      color: const Color(0xFF1E1E2C),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: note.color.withOpacity(0.5), width: 1.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    note.title,
                                    style: TextStyle(
                                      color: note.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: note.color.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        note.tag,
                                        style: TextStyle(color: note.color, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _stickyNotes.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              note.content,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                              softWrap: true,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Snippet copied to clipboard!"), duration: Duration(seconds: 1)),
                                    );
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(Icons.copy, color: Colors.grey, size: 14),
                                      SizedBox(width: 4),
                                      Text("Copy Snippet", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ],
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

  // TAB 5: HUD Studio & Customizer
  Widget _buildStudioCustomizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tune, color: Colors.purpleAccent, size: 22),
              SizedBox(width: 8),
              Text(
                "HUD Floating Dock Studio",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Customize the appearance, screen anchor position, and transparency of your floating bubble.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
            softWrap: true,
          ),
          const SizedBox(height: 20),

          // Opacity Slider
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bubble Opacity", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("${(_overlayOpacity * 100).toInt()}%", style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _overlayOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.deepPurpleAccent,
                    onChanged: (val) {
                      setState(() {
                        _overlayOpacity = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Floating Position Anchor
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Default Screen Anchor Position", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: ['Right Edge', 'Left Edge', 'Top Center'].map((pos) {
                      final isSel = _floatingPosition == pos;
                      return ChoiceChip(
                        label: Text(pos),
                        selected: isSel,
                        selectedColor: Colors.deepPurple,
                        backgroundColor: const Color(0xFF141424),
                        labelStyle: TextStyle(color: isSel ? Colors.white : Colors.grey, fontSize: 12),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _floatingPosition = pos;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bubble Accent Color Selector
          Card(
            color: const Color(0xFF1E1E2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Bubble Accent Theme", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Colors.deepPurple,
                      Colors.teal,
                      Colors.indigo,
                      Colors.deepOrange,
                      Colors.blue,
                    ].map((col) {
                      final isSelected = _bubbleColor == col;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _bubbleColor = col;
                          });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: col,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick Info Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.5)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info, color: Colors.indigoAccent, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "ClipFlow background daemon stays lightweight and optimized for ultra-low battery consumption.",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    softWrap: true,
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