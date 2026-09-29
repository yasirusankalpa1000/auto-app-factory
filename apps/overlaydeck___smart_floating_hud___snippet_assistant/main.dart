import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayDeckApp());
}

class ClipItem {
  final String id;
  String title;
  String content;
  String category;
  int copyCount;

  ClipItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.copyCount = 0,
  });
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
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
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
  bool _isOverlayEnabled = true;
  bool _isNotificationListenerActive = true;
  bool _isBubbleExpanded = false;
  Offset _bubblePosition = const Offset(20, 180);
  String _activeHUDTool = 'clips';

  // Snippet Vault State
  final List<ClipItem> _snippets = [
    ClipItem(
      id: '1',
      title: 'Bank Transfer Details',
      content: 'Account: 9081234456 | Branch: City Center | Name: J. Doe',
      category: 'Banking',
      copyCount: 14,
    ),
    ClipItem(
      id: '2',
      title: 'Delivery Address',
      content: 'No. 42, Sunrise Boulevard, Apt 4B, Metro District, 10200',
      category: 'Address',
      copyCount: 28,
    ),
    ClipItem(
      id: '3',
      title: 'Running Late Reply',
      content: 'Hey! I am on my way, heavy traffic right now. Be there in 10 minutes!',
      category: 'Quick Reply',
      copyCount: 9,
    ),
    ClipItem(
      id: '4',
      title: 'Guest Wi-Fi Key',
      content: 'GuestWiFi2025!#Pass',
      category: 'Quick Reply',
      copyCount: 19,
    ),
    ClipItem(
      id: '5',
      title: 'Promo Hashtag Bundle',
      content: '#dailytech #productivity #tools #mobilelife #lifehacks',
      category: 'Social',
      copyCount: 6,
    ),
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Micro-Tools State
  final TextEditingController _transformTextController = TextEditingController();
  String _transformedResult = '';

  final TextEditingController _billAmountController = TextEditingController(text: '45.00');
  final TextEditingController _billPeopleController = TextEditingController(text: '3');
  final TextEditingController _billTipController = TextEditingController(text: '15');
  double _splitPerPerson = 17.25;

  final List<String> _stickyNotes = [
    'Pick up laundry at 6:00 PM',
    'Verify client bank swift code',
    'Send delivery address to driver',
  ];
  final TextEditingController _newNoteController = TextEditingController();

  // Customization
  double _bubbleOpacity = 0.9;
  double _bubbleSize = 56.0;

  @override
  void initState() {
    super.initState();
    _calculateSplit();
  }

  void _calculateSplit() {
    double total = double.tryParse(_billAmountController.text) ?? 0.0;
    int people = int.tryParse(_billPeopleController.text) ?? 1;
    double tip = double.tryParse(_billTipController.text) ?? 0.0;
    if (people <= 0) people = 1;

    double grandTotal = total + (total * (tip / 100.0));
    setState(() {
      _splitPerPerson = grandTotal / people;
    });
  }

  void _copyToClipboard(String text, String title) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$title" to clipboard!'),
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addNewSnippetDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Banking';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E28),
              title: const Text('Add New Smart Snippet', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Title / Short Name',
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
                        labelText: 'Snippet Content',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      dropdownColor: const Color(0xFF282836),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Banking', 'Address', 'Quick Reply', 'Social'].map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => category = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                      setState(() {
                        _snippets.insert(
                          0,
                          ClipItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleController.text,
                            content: contentController.text,
                            category: category,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: _buildSelectedTabContent(),
                ),
              ],
            ),
          ),
          if (_isOverlayEnabled) _buildInteractiveOverlayBubble(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF282838), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (idx) => setState(() => _selectedTabIndex = idx),
          backgroundColor: const Color(0xFF14141E),
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'HUD Studio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_copy),
              label: 'Vault',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Micro Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF181824),
        border: Border(bottom: BorderSide(color: Color(0xFF282838), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.purpleAccent, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OverlayDeck',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Floating Assistant & Snippet Studio',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isOverlayEnabled ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isOverlayEnabled ? Colors.green : Colors.red,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: _isOverlayEnabled ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  _isOverlayEnabled ? 'HUD Active' : 'HUD Off',
                  style: TextStyle(
                    color: _isOverlayEnabled ? Colors.green : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildHUDStudioTab();
      case 1:
        return _buildSnippetVaultTab();
      case 2:
        return _buildMicroToolsTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildHUDStudioTab();
    }
  }

  // TAB 0: HUD STUDIO
  Widget _buildHUDStudioTab() {
    int totalCopies = _snippets.fold(0, (sum, item) => sum + item.copyCount);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A1B4E), Color(0xFF1A1A2E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.touch_app, color: Colors.purpleAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Live Floating Assistant',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Switch(
                        value: _isOverlayEnabled,
                        activeColor: Colors.purpleAccent,
                        onChanged: (val) {
                          setState(() => _isOverlayEnabled = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'The floating bubble stays on your screen over any application. Drag it anywhere or tap it to open instant micro-tools!',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Daily Stats Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A24),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A2A3A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Snippets', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '${_snippets.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                      color: const Color(0xFF1A1A24),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A2A3A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quick Copies', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '$totalCopies',
                          style: const TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold),
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
                      color: const Color(0xFF1A1A24),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2A2A3A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Est. Time Saved', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '${(totalCopies * 0.4).toStringAsFixed(1)}m',
                          style: const TextStyle(color: Colors.tealAccent, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'HUD Quick Launcher Tools',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Quick Tool Launch Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: [
                _buildToolLaunchCard(
                  title: 'Smart Clip Vault',
                  subtitle: '1-Tap Fast Copy',
                  icon: Icons.content_copy,
                  color: Colors.purpleAccent,
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                ),
                _buildToolLaunchCard(
                  title: 'Text Clean Studio',
                  subtitle: 'Format & Slugify',
                  icon: Icons.transform,
                  color: Colors.blueAccent,
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 2;
                      _activeHUDTool = 'text';
                    });
                  },
                ),
                _buildToolLaunchCard(
                  title: 'Split Bill Calculator',
                  subtitle: 'Instant Shares',
                  icon: Icons.calculate,
                  color: Colors.orangeAccent,
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 2;
                      _activeHUDTool = 'calc';
                    });
                  },
                ),
                _buildToolLaunchCard(
                  title: 'Sticky Pin Notes',
                  subtitle: 'Quick Reminders',
                  icon: Icons.note,
                  color: Colors.tealAccent,
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 2;
                      _activeHUDTool = 'notes';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Interactive Drag Guide Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF181824),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white70),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.amber, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Try the Live Simulator!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Drag the purple floating widget icon around your screen right now to test the real overlay interaction.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                          softWrap: true,
                        ),
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

  Widget _buildToolLaunchCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF181824),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: SNIPPET VAULT
  Widget _buildSnippetVaultTab() {
    List<ClipItem> filtered = _snippets.where((item) {
      bool matchesCategory = (_selectedCategory == 'All') || (item.category == _selectedCategory);
      bool matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          // Search & Add Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search snippets...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                      filled: true,
                      fillColor: const Color(0xFF1A1A26),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addNewSnippetDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ),

          // Categories Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['All', 'Banking', 'Address', 'Quick Reply', 'Social'].map((cat) {
                bool isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                    selected: isSelected,
                    selectedColor: Colors.purple,
                    backgroundColor: const Color(0xFF1E1E2C),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Snippets List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No snippets found.', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF181824),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF28283A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: const TextStyle(color: Colors.purpleAccent, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.content,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Used ${item.copyCount} times',
                                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          _snippets.removeWhere((s) => s.id == item.id);
                                        });
                                      },
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          item.copyCount++;
                                        });
                                        _copyToClipboard(item.content, item.title);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple.withOpacity(0.3),
                                        foregroundColor: Colors.purpleAccent,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      icon: const Icon(Icons.content_copy, size: 14),
                                      label: const Text('Copy', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // TAB 2: MICRO TOOLS HUB
  Widget _buildMicroToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tool Selector Bar
            Row(
              children: [
                Expanded(
                  child: _buildToolTabButton(
                    label: 'Text Clean',
                    icon: Icons.transform,
                    keyName: 'text',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildToolTabButton(
                    label: 'Split Bill',
                    icon: Icons.calculate,
                    keyName: 'calc',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildToolTabButton(
                    label: 'Sticky Notes',
                    icon: Icons.note,
                    keyName: 'notes',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_activeHUDTool == 'text') _buildTextCleanTool(),
            if (_activeHUDTool == 'calc') _buildSplitBillTool(),
            if (_activeHUDTool == 'notes') _buildStickyNotesTool(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolTabButton({
    required String label,
    required IconData icon,
    required String keyName,
  }) {
    bool isSelected = _activeHUDTool == keyName;
    return InkWell(
      onTap: () => setState(() => _activeHUDTool = keyName),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : const Color(0xFF181824),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.purpleAccent : const Color(0xFF282838),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Micro Tool 1: Text Clean Studio
  Widget _buildTextCleanTool() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF28283A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Text Formatting Engine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            'Paste raw text to strip extra spaces, fix casing, or convert into URL slug on the fly.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _transformTextController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Enter or paste text here...',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              fillColor: Color(0xFF12121A),
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _transformedResult = _transformTextController.text.toUpperCase();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28283A)),
                child: const Text('UPPERCASE', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _transformedResult = _transformTextController.text.toLowerCase();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28283A)),
                child: const Text('lowercase', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _transformedResult = _transformTextController.text.replaceAll(RegExp(r'\s+'), ' ').trim();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28283A)),
                child: const Text('Trim Spaces', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _transformedResult = _transformTextController.text
                        .toLowerCase()
                        .trim()
                        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
                        .replaceAll(RegExp(r'\s+'), '-');
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28283A)),
                child: const Text('Slugify-Url', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          ),
          if (_transformedResult.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF12121A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Result', style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.content_copy, color: Colors.purpleAccent, size: 16),
                        onPressed: () => _copyToClipboard(_transformedResult, 'Transformed Text'),
                      ),
                    ],
                  ),
                  Text(_transformedResult, style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Micro Tool 2: Split Bill HUD Calculator
  Widget _buildSplitBillTool() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF28283A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Split Bill & Tip Calculator',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate exact individual shares when dining or sharing group expenses.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _billAmountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => _calculateSplit(),
                  decoration: const InputDecoration(
                    labelText: 'Total Bill (\$)',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _billPeopleController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => _calculateSplit(),
                  decoration: const InputDecoration(
                    labelText: 'People Count',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _billTipController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => _calculateSplit(),
                  decoration: const InputDecoration(
                    labelText: 'Tip %',
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2A1B4E), Color(0xFF1A1A3A)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Each Person Pays', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_splitPerPerson.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.tealAccent, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _copyToClipboard('\$${_splitPerPerson.toStringAsFixed(2)}', 'Split Amount');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  icon: const Icon(Icons.content_copy, color: Colors.white, size: 16),
                  label: const Text('Copy Share', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Micro Tool 3: Sticky Notes
  Widget _buildStickyNotesTool() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF28283A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Pinboard Notes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            'Micro-notes available instantly inside the floating screen HUD.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newNoteController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Add quick micro note...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.purple),
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  if (_newNoteController.text.isNotEmpty) {
                    setState(() {
                      _stickyNotes.insert(0, _newNoteController.text);
                      _newNoteController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stickyNotes.length,
            itemBuilder: (context, idx) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF222230),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.push_pin, color: Colors.amber, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _stickyNotes[idx],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green, size: 18),
                      onPressed: () {
                        setState(() {
                          _stickyNotes.removeAt(idx);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // TAB 3: SETTINGS & PERMISSIONS STUDIO
  Widget _buildSettingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floating Service & Controls',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildSettingToggleTile(
              title: 'Display Over Other Apps',
              subtitle: 'Allow floating HUD bubble over external applications',
              icon: Icons.layers,
              value: _isOverlayEnabled,
              onChanged: (val) => setState(() => _isOverlayEnabled = val),
            ),
            const SizedBox(height: 8),

            _buildSettingToggleTile(
              title: 'Notification Auto-Listener',
              subtitle: 'Detect incoming tracking codes & copyable info',
              icon: Icons.notifications,
              value: _isNotificationListenerActive,
              onChanged: (val) => setState(() => _isNotificationListenerActive = val),
            ),
            const SizedBox(height: 20),

            const Text(
              'HUD Bubble Appearance',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF181824),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF282838)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bubble Opacity', style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('${(_bubbleOpacity * 100).round()}%', style: const TextStyle(color: Colors.purpleAccent, fontSize: 13)),
                    ],
                  ),
                  Slider(
                    value: _bubbleOpacity,
                    min: 0.3,
                    max: 1.0,
                    activeColor: Colors.purple,
                    onChanged: (val) => setState(() => _bubbleOpacity = val),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bubble Size', style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text('${_bubbleSize.round()} px', style: const TextStyle(color: Colors.purpleAccent, fontSize: 13)),
                    ],
                  ),
                  Slider(
                    value: _bubbleSize,
                    min: 44.0,
                    max: 72.0,
                    activeColor: Colors.purple,
                    onChanged: (val) => setState(() => _bubbleSize = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF14141E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield, color: Colors.tealAccent, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy First Design', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 2),
                        Text(
                          'All snippets and clip data remain 100% local on your hardware. Zero data leaves your device.',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
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

  Widget _buildSettingToggleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF181824),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF282838)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.purpleAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // INTERACTIVE OVERLAY BUBBLE & HUD SIMULATOR
  Widget _buildInteractiveOverlayBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _bubblePosition += details.delta;
              });
            },
            onTap: () {
              setState(() {
                _isBubbleExpanded = !_isBubbleExpanded;
              });
            },
            child: Opacity(
              opacity: _bubbleOpacity,
              child: Container(
                width: _bubbleSize,
                height: _bubbleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurpleAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    _isBubbleExpanded ? Icons.close : Icons.layers,
                    color: Colors.white,
                    size: _bubbleSize * 0.45,
                  ),
                ),
              ),
            ),
          ),

          // Expanded HUD Overlay Box
          if (_isBubbleExpanded) ...[
            const SizedBox(height: 8),
            Container(
              width: 260,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C).withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purpleAccent, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'OverlayDeck Mini HUD',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isBubbleExpanded = false),
                        child: const Icon(Icons.close, color: Colors.grey, size: 16),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 16),

                  const Text(
                    'Quick Clips (1-Tap Copy):',
                    style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),

                  ..._snippets.take(3).map((item) {
                    return InkWell(
                      onTap: () {
                        item.copyCount++;
                        _copyToClipboard(item.content, item.title);
                        setState(() => _isBubbleExpanded = false);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF282838),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.content_copy, color: Colors.purpleAccent, size: 12),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedTabIndex = 1;
                              _isBubbleExpanded = false;
                            });
                          },
                          child: const Text('Open Vault', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF282838),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedTabIndex = 2;
                              _isBubbleExpanded = false;
                            });
                          },
                          child: const Text('Tools', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}