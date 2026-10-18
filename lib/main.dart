import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FloatingHubApp());
}

class FloatingHubApp extends StatelessWidget {
  const FloatingHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingHub Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainHomeScreen(),
    );
  }
}

class ClipItem {
  final String id;
  final String title;
  final String content;
  final String category; // 'Link', 'Bank', 'Address', 'Reply', 'Secret'
  bool isPinned;

  ClipItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global App States
  bool _isOverlayActive = true;
  bool _displayOverAppsPermission = true;
  bool _notificationPanelFastBar = true;
  Color _bubbleThemeColor = Colors.teal;
  double _bubbleOpacity = 0.9;
  
  int _actionsPerformedToday = 28;
  int _timeSavedMinutes = 19;

  // Snippets Memory Data
  final List<ClipItem> _clips = [
    ClipItem(
      id: '1',
      title: 'Bank Wire Transfer Info',
      content: 'Acc Name: J. Doe | Acc No: 88392019482 | Swift: HSBCLXX',
      category: 'Bank',
      isPinned: true,
    ),
    ClipItem(
      id: '2',
      title: 'Home Delivery Address',
      content: '742 Evergreen Terrace, Sector 4, Suite 102, NY 10001',
      category: 'Address',
      isPinned: true,
    ),
    ClipItem(
      id: '3',
      title: 'Store Promo Code',
      content: 'DISCOUNT25OFF',
      category: 'Secret',
      isPinned: false,
    ),
    ClipItem(
      id: '4',
      title: 'Meeting Link Zoom',
      content: 'https://zoom.us/j/9823471029?pwd=SamplePassword123',
      category: 'Link',
      isPinned: false,
    ),
  ];

  // Quick Notes Memory
  String _scratchpadText = "Quick floating note: Pick up package at 4 PM. Call bank rep regarding account sync.";

  void _addClipItem(String title, String content, String category) {
    setState(() {
      _clips.insert(
        0,
        ClipItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.isEmpty ? 'Quick Clip Snippet' : title,
          content: content,
          category: category,
        ),
      );
      _actionsPerformedToday++;
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$label" to Clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
    setState(() {
      _actionsPerformedToday++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildFloatingHubTab(),
      _buildClipVaultTab(),
      _buildTextStudioTab(),
      _buildMiniToolsTab(),
      _buildSettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _bubbleThemeColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.widgets, color: _bubbleThemeColor),
            ),
            const SizedBox(width: 10),
            const Text(
              'FloatingHub Pro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: Icon(
                _isOverlayActive ? Icons.bolt : Icons.power_settings_new,
                color: Colors.white,
                size: 16,
              ),
              label: Text(
                _isOverlayActive ? 'ACTIVE' : 'OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              backgroundColor: _isOverlayActive ? Colors.green : Colors.grey,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers),
            label: 'Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_outlined),
            selectedIcon: Icon(Icons.content_paste),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_snippet_outlined),
            selectedIcon: Icon(Icons.text_snippet),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Overlay',
          ),
        ],
      ),
    );
  }

  // ================= TAB 1: LIVE FLOATING HUB DEMO & OVERLAY INTERACTION =================
  Widget _buildFloatingHubTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Banner
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daily Productivity Boost',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_actionsPerformedToday Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Saved ~$_timeSavedMinutes mins app-switching today',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          _isOverlayActive = !_isOverlayActive;
                        });
                      },
                      icon: Icon(_isOverlayActive ? Icons.pause : Icons.play_arrow),
                      tooltip: 'Toggle Overlay Service',
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Screen Floating Canvas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Drag bubble below',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Interactive Simulated Screen Frame
            const FloatingCanvasSimulator(),
            const SizedBox(height: 16),

            // Quick Floating Launchers List
            const Text(
              'Quick Overlay Dock Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildActionChip(
                  icon: Icons.paste,
                  label: 'Paste Top Snippet',
                  color: Colors.teal,
                  onTap: () {
                    if (_clips.isNotEmpty) {
                      _copyToClipboard(_clips.first.content, _clips.first.title);
                    }
                  },
                ),
                _buildActionChip(
                  icon: Icons.cleaning_services,
                  label: 'Clean Copied Text',
                  color: Colors.blue,
                  onTap: () async {
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    if (data != null && data.text != null) {
                      String cleaned = data.text!.replaceAll(RegExp(r'\s+'), ' ').trim();
                      _copyToClipboard(cleaned, 'Cleaned Text');
                    } else {
                      _showNotice('No text found in device clipboard!');
                    }
                  },
                ),
                _buildActionChip(
                  icon: Icons.note_alt,
                  label: 'Open Scratchpad',
                  color: Colors.orange,
                  onTap: () => _showScratchpadBottomSheet(),
                ),
                _buildActionChip(
                  icon: Icons.add,
                  label: 'Add Quick Clip',
                  color: Colors.purple,
                  onTap: () => _showAddClipDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 2: SMART CLIPBOARD VAULT =================
  String _selectedCategoryFilter = 'All';

  Widget _buildClipVaultTab() {
    final categories = ['All', 'Pinned', 'Bank', 'Address', 'Link', 'Secret'];

    List<ClipItem> filteredList = _clips.where((c) {
      if (_selectedCategoryFilter == 'Pinned') return c.isPinned;
      if (_selectedCategoryFilter != 'All') {
        return c.category.toLowerCase() == _selectedCategoryFilter.toLowerCase();
      }
      return true;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          // Search & Category Filters Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search snippets...',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: () => _showAddClipDialog(),
                      icon: const Icon(Icons.add),
                      tooltip: 'Add Snippet',
                    )
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = _selectedCategoryFilter == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(cat),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryFilter = cat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Snippets List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.content_paste_off, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No clips found in this category.',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(item.category).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(item.category),
                              color: _getCategoryColor(item.category),
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.isPinned)
                                const Icon(
                                  Icons.push_pin,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              item.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                color: Theme.of(context).primaryColor,
                                onPressed: () => _copyToClipboard(item.content, item.title),
                                tooltip: 'Copy Snippet',
                              ),
                              PopupMenuButton<String>(
                                onSelected: (val) {
                                  if (val == 'pin') {
                                    setState(() {
                                      item.isPinned = !item.isPinned;
                                    });
                                  } else if (val == 'delete') {
                                    setState(() {
                                      _clips.removeWhere((c) => c.id == item.id);
                                    });
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'pin',
                                    child: Text(item.isPinned ? 'Unpin' : 'Pin to Top'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
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
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bank':
        return Colors.green;
      case 'Address':
        return Colors.orange;
      case 'Link':
        return Colors.blue;
      case 'Secret':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bank':
        return Icons.attach_money;
      case 'Address':
        return Icons.pin_drop;
      case 'Link':
        return Icons.link;
      case 'Secret':
        return Icons.lock;
      default:
        return Icons.label;
    }
  }

  // ================= TAB 3: SMART TEXT STUDIO & TEMPLATE GENERATOR =================
  final TextEditingController _templateNameController = TextEditingController(text: "Alex");
  final TextEditingController _templateAmountController = TextEditingController(text: "150");
  final TextEditingController _rawTextInputController = TextEditingController();

  Widget _buildTextStudioTab() {
    String dynamicReplyText =
        "Hi ${_templateNameController.text.isEmpty ? 'Friend' : _templateNameController.text}, "
        "your pending payment of \$${_templateAmountController.text.isEmpty ? '0' : _templateAmountController.text} "
        "is confirmed. Please reply to this message if you need the invoice receipt. Thanks!";

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dynamic Template Fast-Reply',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Inject instant dynamic values into pre-made message templates.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _templateNameController,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Recipient Name',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _templateAmountController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Amount (\$) ',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Generated Live Fast Reply:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dynamicReplyText,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _copyToClipboard(dynamicReplyText, 'Fast Reply Template');
                        },
                        icon: const Icon(Icons.content_copy),
                        label: const Text('Copy Generated Reply'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Text Transformer Utility
            const Text(
              'Quick Text Transformer Studio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Format raw input text instantly without leaving your workflow.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _rawTextInputController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Paste or type raw messy text here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    String input = _rawTextInputController.text;
                    _rawTextInputController.text = input.toUpperCase();
                  },
                  icon: const Icon(Icons.arrow_upward, size: 16),
                  label: const Text('UPPERCASE'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    String input = _rawTextInputController.text;
                    _rawTextInputController.text = input.toLowerCase();
                  },
                  icon: const Icon(Icons.arrow_downward, size: 16),
                  label: const Text('lowercase'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    String input = _rawTextInputController.text;
                    _rawTextInputController.text = input.replaceAll(RegExp(r'\s+'), ' ').trim();
                  },
                  icon: const Icon(Icons.cleaning_services, size: 16),
                  label: const Text('Remove Extra Spaces'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_rawTextInputController.text.isNotEmpty) {
                      _copyToClipboard(_rawTextInputController.text, 'Transformed Text');
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Copy Result'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 4: FLOATING MINI-TOOLS & QUICK SPLITTER =================
  final TextEditingController _totalBillController = TextEditingController(text: "84.50");
  final TextEditingController _peopleCountController = TextEditingController(text: "3");
  double _tipPercent = 15.0;

  Widget _buildMiniToolsTab() {
    double totalBill = double.tryParse(_totalBillController.text) ?? 0.0;
    int people = int.tryParse(_peopleCountController.text) ?? 1;
    if (people < 1) people = 1;

    double tipAmount = totalBill * (_tipPercent / 100);
    double grandTotal = totalBill + tipAmount;
    double perPerson = grandTotal / people;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Bill Splitter
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calculate, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Floating Quick Splitter',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _totalBillController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Total Bill (\$) ',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _peopleCountController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'People',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          'Tip: ${_tipPercent.toInt()}%',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Slider(
                            value: _tipPercent,
                            min: 0,
                            max: 30,
                            divisions: 6,
                            label: '${_tipPercent.toInt()}%',
                            onChanged: (val) {
                              setState(() {
                                _tipPercent = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Each Person Pays:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(
                                '\$${perPerson.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _copyToClipboard(
                                'Split Share: \$${perPerson.toStringAsFixed(2)} per person (Total: \$${grandTotal.toStringAsFixed(2)})',
                                'Split Calculation',
                              );
                            },
                            icon: const Icon(Icons.share, size: 16),
                            label: const Text('Share Share'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Persistent Scratchpad
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.note_alt, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Floating Quick Scratchpad',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _scratchpadText = "";
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      initialValue: _scratchpadText,
                      maxLines: 4,
                      onChanged: (val) {
                        _scratchpadText = val;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type fast sticky notes or temporary text here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_scratchpadText.isNotEmpty) {
                              _copyToClipboard(_scratchpadText, 'Scratchpad Note');
                            }
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy Note'),
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

  // ================= TAB 5: OVERLAY SYSTEM & SETTINGS =================
  Widget _buildSettingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Overlay Permissions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.layers, color: Colors.teal),
                    title: const Text('Display Over Other Apps'),
                    subtitle: const Text('Required for floating bubble & quick drawer'),
                    value: _displayOverAppsPermission,
                    onChanged: (val) {
                      setState(() {
                        _displayOverAppsPermission = val;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications, color: Colors.blue),
                    title: const Text('Notification Panel Fast-Bar'),
                    subtitle: const Text('Access quick clipboard directly from notification shade'),
                    value: _notificationPanelFastBar,
                    onChanged: (val) {
                      setState(() {
                        _notificationPanelFastBar = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Floating Bubble Customizer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bubble Color Theme', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildColorOption(Colors.teal),
                        _buildColorOption(Colors.blue),
                        _buildColorOption(Colors.purple),
                        _buildColorOption(Colors.orange),
                        _buildColorOption(Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Bubble Opacity: ${(_bubbleOpacity * 100).toInt()}%',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _bubbleOpacity,
                      min: 0.3,
                      max: 1.0,
                      onChanged: (val) {
                        setState(() {
                          _bubbleOpacity = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Card(
              color: Colors.teal.withOpacity(0.08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'FloatingHub Pro runs seamlessly in background. Tap the bubble anytime while chatting or browsing!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
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

  Widget _buildColorOption(Color color) {
    bool isSelected = _bubbleThemeColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleThemeColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8, spreadRadius: 2)]
              : null,
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  // Helper Modals
  void _showAddClipDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Bank';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Snippet to Vault'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title (e.g. WiFi Password)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Snippet Text Content',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: category,
                      items: ['Bank', 'Address', 'Link', 'Secret', 'Reply']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            category = val;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (contentCtrl.text.isNotEmpty) {
                      _addClipItem(titleCtrl.text, contentCtrl.text, category);
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showScratchpadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Floating Scratchpad',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _scratchpadText,
                maxLines: 4,
                onChanged: (val) {
                  _scratchpadText = val;
                },
                decoration: const InputDecoration(
                  hintText: 'Type quick temporary note...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _copyToClipboard(_scratchpadText, 'Scratchpad Note');
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy & Close'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showNotice(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}

// ================= SIMULATED INTERACTIVE SCREEN CANVAS WITH DRAGGABLE FLOATING BUBBLE =================
class FloatingCanvasSimulator extends StatefulWidget {
  const FloatingCanvasSimulator({super.key});

  @override
  State<FloatingCanvasSimulator> createState() => _FloatingCanvasSimulatorState();
}

class _FloatingCanvasSimulatorState extends State<FloatingCanvasSimulator> {
  Offset _bubbleOffset = const Offset(220, 140);
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark phone screen background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade700, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Stack(
        children: [
          // Background Simulated Phone App UI
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone status bar mock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '09:41',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.wifi, color: Colors.white70, size: 14),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full, color: Colors.white70, size: 14),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Chat mock bubbles behind floating overlay
                  _buildMockChatMessage(
                    'Hey! Can you send me your home address and bank details for the transfer?',
                    false,
                  ),
                  const SizedBox(height: 10),
                  _buildMockChatMessage(
                    'Sure! Tap the floating green bubble to paste it instantly.',
                    true,
                  ),
                  const SizedBox(height: 10),
                  _buildMockChatMessage(
                    'Also split the \$84 bill among us 3 people!',
                    false,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Floating Drawer Overlay Mock
          if (_isExpanded)
            Positioned(
              left: 20,
              right: 20,
              top: 70,
              child: Card(
                color: const Color(0xFF0F172A),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.widgets, color: Colors.teal, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Floating Quick Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isExpanded = false;
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.white70, size: 18),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70, height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildOverlayIconButton(
                            icon: Icons.paste,
                            label: 'Fast Clip',
                            color: Colors.teal,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Floating Drawer: Pasted snippet to Chat!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              setState(() {
                                _isExpanded = false;
                              });
                            },
                          ),
                          _buildOverlayIconButton(
                            icon: Icons.calculate,
                            label: 'Split \$84',
                            color: Colors.blue,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Split Result: \$28.00 per person copied!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              setState(() {
                                _isExpanded = false;
                              });
                            },
                          ),
                          _buildOverlayIconButton(
                            icon: Icons.cleaning_services,
                            label: 'Clean Text',
                            color: Colors.purple,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Text sanitized & formatted!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                              setState(() {
                                _isExpanded = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Interactive Draggable Floating Bubble
          Positioned(
            left: _bubbleOffset.dx,
            top: _bubbleOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newX = _bubbleOffset.dx + details.delta.dx;
                  double newY = _bubbleOffset.dy + details.delta.dy;
                  // Clamp bounds inside container
                  newX = newX.clamp(10.0, 280.0);
                  newY = newY.clamp(30.0, 310.0);
                  _bubbleOffset = Offset(newX, newY);
                });
              },
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Material(
                elevation: 6,
                shape: const CircleBorder(),
                color: Colors.transparent,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.tealAccent,
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.widgets,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockChatMessage(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        maxWidth: 220,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal.shade700 : const Color(0xFF334155),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildOverlayIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 18,
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}