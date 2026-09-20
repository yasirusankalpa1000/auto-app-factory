import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingCompanionApp());
}

class FloatingCompanionApp extends StatelessWidget {
  const FloatingCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
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
  bool _overlayEnabled = true;
  bool _notificationPermission = true;
  bool _autoCopyListener = true;

  // Floating Bubble position simulation
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;

  // Clipboard Vault Items
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Home Address',
      'category': 'Personal',
      'content': '124 Maple Avenue, Suite 4B, Springfield'
    },
    {
      'title': 'Bank Account details',
      'category': 'Finance',
      'content': 'Account: 9876-5432-1011 | Swift: SPFDUS33'
    },
    {
      'title': 'Wi-Fi Password',
      'category': 'Home',
      'content': 'GuestPass2025!\$'
    },
    {
      'title': 'Quick Polite Refusal',
      'category': 'Chat',
      'content': 'Thanks for reaching out! I am occupied today, let us reconnect next week.'
    },
    {
      'title': 'Meeting Link Standard',
      'category': 'Work',
      'content': 'Join video room: https://meet.company.com/room-daily'
    },
  ];

  String _searchQuery = '';
  final TextEditingController _snippetTitleController = TextEditingController();
  final TextEditingController _snippetContentController = TextEditingController();
  String _selectedCategory = 'Personal';

  // Text Transformer Tool
  final TextEditingController _transformerInputController = TextEditingController();
  String _transformedOutput = '';
  String _selectedTone = 'Professional';

  // Quick Choice Spinner Items
  final List<String> _choiceOptions = ['Pizza', 'Burgers', 'Sushi', 'Salad', 'Home Cooked'];
  String _chosenResult = 'Tap Spin to Decide!';

  void _addSnippet() {
    if (_snippetTitleController.text.trim().isEmpty || _snippetContentController.text.trim().isEmpty) {
      return;
    }
    setState(() {
      _snippets.insert(0, {
        'title': _snippetTitleController.text.trim(),
        'category': _selectedCategory,
        'content': _snippetContentController.text.trim(),
      });
      _snippetTitleController.clear();
      _snippetContentController.clear();
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New snippet saved to Clipboard Vault!')),
    );
  }

  void _transformText() {
    final input = _transformerInputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _transformedOutput = 'Please enter text above to convert.';
      });
      return;
    }

    setState(() {
      switch (_selectedTone) {
        case 'Professional':
          _transformedOutput = 'Dear team, regarding your query: "$input". Please let me know if further clarification is required. Best regards.';
          break;
        case 'Casual Chat':
          _transformedOutput = 'Hey! Just wanted to say: $input. Let me know what you think! 😊';
          break;
        case 'Bullet Points':
          List<String> words = input.split(' ');
          _transformedOutput = '• Key Note 1: ${words.take(3).join(' ')}\n• Key Note 2: ${words.skip(3).take(3).join(' ')}\n• Summary: $input';
          break;
        case 'Aesthetic Style':
          _transformedOutput = '✨ ${input.toUpperCase()} ✨ ~ [Saved via Floating Companion]';
          break;
        case 'Polite Request':
          _transformedOutput = 'Hi there, whenever you get a free moment, could you kindly help me with: "$input"? Thanks a lot!';
          break;
        default:
          _transformedOutput = input;
      }
    });
  }

  void _spinDecision() {
    if (_choiceOptions.isEmpty) return;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _choiceOptions.length;
    setState(() {
      _chosenResult = '👉 ${_choiceOptions[randomIndex]}!';
    });
  }

  void _showAddSnippetDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Quick Snippet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _snippetTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title (e.g. Bank IBAN)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _snippetContentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content to Quick Copy',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Category: ', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      items: ['Personal', 'Finance', 'Work', 'Home', 'Chat']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedCategory = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _addSnippet,
                    icon: const Icon(Icons.check),
                    label: const Text('Save Snippet'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredSnippets = _snippets.where((s) {
      final title = s['title']!.toLowerCase();
      final content = s['content']!.toLowerCase();
      final q = _searchQuery.toLowerCase();
      return title.contains(q) || content.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Companion Studio'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Floating Service Active in Background'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                _buildDashboardTab(filteredSnippets),
                _buildTransformerTab(),
                _buildDecisionTab(),
                _buildSettingsTab(),
              ],
            ),
            // Floating Interactive Overlay Simulator
            if (_overlayEnabled)
              Positioned(
                left: _bubbleX,
                top: _bubbleY,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX += details.delta.dx;
                      _bubbleY += details.delta.dy;
                    });
                  },
                  onTap: () {
                    _showQuickOverlayMenu();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 4),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.widgets,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.style),
            label: 'Tone Styler',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Decision',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Control Hub',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddSnippetDialog,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('New Snippet'),
            )
          : null,
    );
  }

  // Dashboard / Vault Tab
  Widget _buildDashboardTab(List<Map<String, String>> filteredSnippets) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.blueAccent],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Floating Bar Active',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Drag purple bubble anywhere on screen for instant access!',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search box
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search clipboard snippets...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Quick Snippets',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text('${filteredSnippets.length} items'),
                backgroundColor: Colors.indigo.withOpacity(0.1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (filteredSnippets.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Column(
                children: const [
                  Icon(Icons.content_paste, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('No snippets found. Add your first quick copy item!'),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSnippets.length,
              itemBuilder: (context, index) {
                final item = filteredSnippets[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['category']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['content']!,
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share, size: 20),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sharing: ${item['title']}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied "${item['title']}" to clipboard!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.content_copy, size: 16),
                              label: const Text('Copy', style: TextStyle(fontSize: 12)),
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

  // Tone & Style Transformer Tab
  Widget _buildTransformerTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Message Tone Switcher',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Type any draft message and instantly reframe it for chat, work, or social media.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _transformerInputController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Enter raw draft message...',
              hintText: 'e.g. I cannot come to work today because I am sick',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Desired Tone:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Professional',
              'Casual Chat',
              'Bullet Points',
              'Aesthetic Style',
              'Polite Request',
            ].map((tone) {
              final isSelected = tone == _selectedTone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSelected,
                selectedColor: Colors.indigo,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: _transformText,
              icon: const Icon(Icons.refresh),
              label: const Text('Transform Message'),
            ),
          ),
          const SizedBox(height: 20),
          if (_transformedOutput.isNotEmpty) ...[
            const Text(
              'Transformed Result:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _transformedOutput,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transformed text copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy, size: 16),
                      label: const Text('Copy Output'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Decision Spinner / Helper Tab
  Widget _buildDecisionTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Picker',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Can\'t decide what to eat, do, or buy? Let Floating Companion choose randomly!',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.calculate, size: 48, color: Colors.indigo),
                const SizedBox(height: 12),
                Text(
                  _chosenResult,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _spinDecision,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Spin / Pick Now'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Options Pool:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _choiceOptions
                .map(
                  (opt) => Chip(
                    label: Text(opt),
                    deleteIcon: const Icon(Icons.delete, size: 16),
                    onDeleted: () {
                      setState(() {
                        _choiceOptions.remove(opt);
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      setState(() {
                        _choiceOptions.add(val.trim());
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Add custom choice...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Type option and press Enter')),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Settings & Permission Control Tab
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Service Controls',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Display Over Other Apps (Overlay)'),
                  subtitle: const Text('Shows floating bubble for instant copy/paste access'),
                  value: _overlayEnabled,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _overlayEnabled = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Quick Notification Banner'),
                  subtitle: const Text('Keep active floating toolbar in notification tray'),
                  value: _notificationPermission,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _notificationPermission = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Auto-Capture Clipboard Snippets'),
                  subtitle: const Text('Detect copied text automatically in background'),
                  value: _autoCopyListener,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _autoCopyListener = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'System Diagnostics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildStatusRow('Service Status', 'Running in background', Colors.green),
                  const SizedBox(height: 8),
                  _buildStatusRow('Saved Items', '${_snippets.length} Vault items', Colors.blue),
                  const SizedBox(height: 8),
                  _buildStatusRow('Memory Saved', '4.2 MB', Colors.indigo),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Floating companion cache cleared')),
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('Clear Temporary Cache'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Quick Action Modal Overlay Sheet
  void _showQuickOverlayMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Floating Companion Quick Menu',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.widgets, color: Colors.indigo),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.content_copy, color: Colors.indigo),
                  title: const Text('Copy Most Recent Snippet'),
                  subtitle: Text(_snippets.isNotEmpty ? _snippets.first['title']! : 'No snippets'),
                  onTap: () {
                    Navigator.pop(ctx);
                    if (_snippets.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied: ${_snippets.first['title']}')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.style, color: Colors.teal),
                  title: const Text('Open Tone Styler'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calculate, color: Colors.deepOrange),
                  title: const Text('Random Decision Spin'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}