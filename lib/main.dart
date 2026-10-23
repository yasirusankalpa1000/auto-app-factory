import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OmniDockApp());
}

class OmniDockApp extends StatelessWidget {
  const OmniDockApp({super.key});

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'OmniDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
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
  int _selectedTabIndex = 0;

  // Floating Overlay Bubble positions
  double _bubbleX = 20.0;
  double _bubbleY = 120.0;
  bool _overlayActive = true;
  String _activeOverlayTool = 'none';

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
  }

  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LinkSanitizerView(onNotify: _showNotificationSnackBar),
      StatusStudioView(onNotify: _showNotificationSnackBar),
      FloatingOverlayView(
        isOverlayActive: _overlayActive,
        onToggleOverlay: (val) {
          setState(() {
            _overlayActive = val;
          });
          _showNotificationSnackBar(
            val ? 'Floating Overlay Dock Enabled' : 'Floating Overlay Disabled',
          );
        },
      ),
      DecisionWheelView(onNotify: _showNotificationSnackBar),
      SnippetVaultView(onNotify: _showNotificationSnackBar),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.indigo),
            const SizedBox(width: 8),
            const Text(
              'OmniDock Hub',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _overlayActive ? Icons.layers : Icons.layers_clear,
                    size: 16,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _overlayActive ? 'Dock Active' : 'Dock Off',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: pages,
            ),
          ),
          // Interactive Floating Overlay Bubble Simulation
          if (_overlayActive)
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
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade800,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.flash_on,
                      color: Colors.amber,
                      size: 26,
                    ),
                    onSelected: (value) {
                      setState(() {
                        _activeOverlayTool = value;
                      });
                      _openMiniOverlayTool(value);
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'clean',
                        child: Row(
                          children: [
                            Icon(Icons.cleaning_services, size: 20, color: Colors.indigo),
                            SizedBox(width: 8),
                            Text('Quick Link Clean'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'note',
                        child: Row(
                          children: [
                            Icon(Icons.edit_note, size: 20, color: Colors.indigo),
                            SizedBox(width: 8),
                            Text('Floating Mini Note'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'clip',
                        child: Row(
                          children: [
                            Icon(Icons.content_paste, size: 20, color: Colors.indigo),
                            SizedBox(width: 8),
                            Text('Quick Clipboard'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined),
            selectedIcon: Icon(Icons.cleaning_services),
            label: 'Sanitizer',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers),
            label: 'Floating Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.casino_outlined),
            selectedIcon: Icon(Icons.casino),
            label: 'Decision',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Vault',
          ),
        ],
      ),
    );
  }

  void _openMiniOverlayTool(String tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Floating Tool: ${tool.toUpperCase()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.indigo,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (tool == 'clean') ...[
                const Text('Paste link to clean tracking params immediately:'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'https://example.com/item?utm_source=fb&ref=123',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (val) {
                    Navigator.pop(context);
                    _showNotificationSnackBar('Cleaned URL copied to clipboard!');
                  },
                ),
              ] else if (tool == 'note') ...[
                const Text('Quick floating micro note:'),
                const SizedBox(height: 8),
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type temporary thoughts here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showNotificationSnackBar('Note saved to Floating Vault!');
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Save Note'),
                )
              ] else ...[
                const Text('Quick copied snippets:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 16),
                      label: const Text('Bank account #'),
                      onPressed: () {
                        Navigator.pop(context);
                        _showNotificationSnackBar('Copied: Bank account #');
                      },
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 16),
                      label: const Text('Home Address'),
                      onPressed: () {
                        Navigator.pop(context);
                        _showNotificationSnackBar('Copied: Home Address');
                      },
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 16),
                      label: const Text('Standard Hashtags'),
                      onPressed: () {
                        Navigator.pop(context);
                        _showNotificationSnackBar('Copied: Standard Hashtags');
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ================= TAB 1: LINK & TEXT SANITIZER =================
class LinkSanitizerView extends StatefulWidget {
  final Function(String) onNotify;
  const LinkSanitizerView({super.key, required me, required this.onNotify});

  @override
  State<LinkSanitizerView> createState() => _LinkSanitizerViewState();
}

class _LinkSanitizerViewState extends State<LinkSanitizerView> {
  final TextEditingController _inputController = TextEditingController(
    text: 'Check this offer: https://store.example.com/item/8923?utm_source=newsletter&utm_medium=email&tracking_id=xyz987 and call +1 800 555 0199 or email support@shop.com!',
  );

  String _cleanedText = '';
  List<String> _extractedPhones = [];
  List<String> _extractedEmails = [];
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _processInput();
  }

  void _processInput() {
    final raw = _inputController.text;

    // Remove tracking queries from URLs
    String cleaned = raw.replaceAllRegExp(
      RegExp(r'(\?|&)(utm_[^=]+|ref|tracking_id|fbclid|gclid)=[^&\s]+'),
      '',
    );

    // Extract emails
    final emailRegExp = RegExp(r'[a-zA-Z0-9.\_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final emails = emailRegExp.allMatches(raw).map((m) => m.group(0)!).toList();

    // Extract phones
    final phoneRegExp = RegExp(r'\+?\d[\d\s\-]{7,}\d');
    final phones = phoneRegExp.allMatches(raw).map((m) => m.group(0)!.trim()).toList();

    // Word count
    final words = raw.trim().isEmpty ? 0 : raw.trim().split(RegExp(r'\s+')).length;

    setState(() {
      _cleanedText = cleaned;
      _extractedEmails = emails;
      _extractedPhones = phones;
      _wordCount = words;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'URL & Text Sanitizer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Paste long links or cluttered text to automatically strip tracking tags and extract key contact details.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Paste messy links or raw text here...',
              border: OutlineInputBorder(),
              labelText: 'Raw Input Text',
            ),
            onChanged: (val) => _processInput(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _processInput();
                  widget.onNotify('Sanitized & Extracted Content!');
                },
                icon: const Icon(Icons.cleaning_services, size: 18),
                label: const Text('Sanitize & Extract'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _inputController.clear();
                  _processInput();
                },
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear Input'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Output Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Cleaned Output',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy, size: 20),
                        tooltip: 'Copy Cleaned Text',
                        onPressed: () {
                          widget.onNotify('Cleaned text copied to clipboard!');
                        },
                      )
                    ],
                  ),
                  const Divider(),
                  SelectableText(
                    _cleanedText.isEmpty ? 'No text processed yet.' : _cleanedText,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.text_fields, size: 14),
                        label: Text('$_wordCount Words'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Extracted Data Highlights',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.blue),
                            SizedBox(width: 6),
                            Text(
                              'Phone Numbers',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_extractedPhones.isEmpty)
                          const Text('None detected', style: TextStyle(fontSize: 12))
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _extractedPhones
                                .map((p) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: SelectableText(p,
                                          style: const TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w600)),
                                    ))
                                .toList(),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: Colors.teal.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.email, size: 16, color: Colors.teal),
                            SizedBox(width: 6),
                            Text(
                              'Emails Found',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_extractedEmails.isEmpty)
                          const Text('None detected', style: TextStyle(fontSize: 12))
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _extractedEmails
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: SelectableText(e,
                                          style: const TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w600)),
                                    ))
                                .toList(),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Extension helper for RegExp string replacements
extension StringRegExpReplace on String {
  String replaceAllRegExp(RegExp regExp, String replacement) {
    return replaceAll(regExp, replacement);
  }
}

// ================= TAB 2: STATUS & STORY GRAPHIC STUDIO =================
class StatusStudioView extends StatefulWidget {
  final Function(String) onNotify;
  const StatusStudioView({super.key, required this.onNotify});

  @override
  State<StatusStudioView> createState() => _StatusStudioViewState();
}

class _StatusStudioViewState extends State<StatusStudioView> {
  final TextEditingController _quoteController = TextEditingController(
    text: '"Small daily improvements over time lead to stunning results."',
  );
  final TextEditingController _authorController = TextEditingController(
    text: '@daily_mindset',
  );

  int _selectedGradientIndex = 0;
  IconData _selectedIcon = Icons.star;
  bool _isStoryAspect = false; // False = Square (Post), True = Vertical (Story)

  final List<List<Color>> _gradients = [
    [Colors.indigo.shade700, Colors.purple.shade700],
    [Colors.teal.shade700, Colors.blue.shade800],
    [Colors.orange.shade800, Colors.deepOrange.shade900],
    [Colors.blueGrey.shade800, Colors.black],
    [Colors.purple.shade800, Colors.pink.shade700],
  ];

  final List<IconData> _iconOptions = [
    Icons.star,
    Icons.favorite,
    Icons.format_quote,
    Icons.lightbulb,
    Icons.verified,
    Icons.bolt,
  ];

  @override
  Widget build(BuildContext context) {
    final activeGradient = _gradients[_selectedGradientIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instant Status & Graphic Studio',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Create formatted graphic status cards for WhatsApp or Instagram stories in seconds.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Graphic Preview Container
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: _isStoryAspect ? 320 : 220,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: activeGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: activeGradient.first.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(_selectedIcon, color: Colors.white, size: 28),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          _quoteController.text.isEmpty
                              ? 'Your text here...'
                              : _quoteController.text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    _authorController.text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
                'Aspect Ratio:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Square Card'),
                    icon: Icon(Icons.crop_square, size: 16),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Story 9:16'),
                    icon: Icon(Icons.crop_portrait, size: 16),
                  ),
                ],
                selected: {_isStoryAspect},
                onSelectionChanged: (Set<bool> selection) {
                  setState(() {
                    _isStoryAspect = selection.first;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Color Theme:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _gradients.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGradientIndex = index;
                    });
                  },
                  child: Container(
                    width: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: _gradients[index]),
                      border: _selectedGradientIndex == index
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Badge Icon:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _iconOptions.map((iconData) {
              final isSelected = _selectedIcon == iconData;
              return ChoiceChip(
                label: Icon(
                  iconData,
                  size: 18,
                  color: isSelected ? Colors.indigo : Colors.grey,
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedIcon = iconData;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quoteController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Card Text / Quote',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Footer / Handle',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                widget.onNotify('Graphic card generated! Ready for status post.');
              },
              icon: const Icon(Icons.share),
              label: const Text('Export & Share Graphic Card'),
            ),
          )
        ],
      ),
    );
  }
}

// ================= TAB 3: FLOATING OVERLAY DOCK MANAGER =================
class FloatingOverlayView extends StatelessWidget {
  final bool isOverlayActive;
  final Function(bool) onToggleOverlay;

  const FloatingOverlayView({
    super.key,
    required this.isOverlayActive,
    required this.onToggleOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Dock Overlay Assistant',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Keep quick action bubbles floating on top of your mobile screen to access clipboard notes and sanitizers anytime.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.layers, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Display Above Other Apps',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Simulate system floating bubble widget permissions.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isOverlayActive,
                    onChanged: onToggleOverlay,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Active Floating Tools Suite',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.flash_on, color: Colors.amber),
            title: const Text('Floating Flash Clean'),
            subtitle: const Text('Strip tracker query parameters with 1 tap'),
            trailing: Chip(
              label: Text(isOverlayActive ? 'Enabled' : 'Disabled'),
              backgroundColor: isOverlayActive ? Colors.green.shade100 : Colors.grey.shade200,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.note_alt_outlined, color: Colors.blue),
            title: const Text('Mini Quick Scratchpad'),
            subtitle: const Text('Type micro notes without leaving other apps'),
            trailing: Chip(
              label: Text(isOverlayActive ? 'Enabled' : 'Disabled'),
              backgroundColor: isOverlayActive ? Colors.green.shade100 : Colors.grey.shade200,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.content_paste_go, color: Colors.teal),
            title: const Text('Quick Snippet Dropper'),
            subtitle: const Text('Instant paste addresses, phone numbers & bank IDs'),
            trailing: Chip(
              label: Text(isOverlayActive ? 'Enabled' : 'Disabled'),
              backgroundColor: isOverlayActive ? Colors.green.shade100 : Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: Drag the yellow floating lightning bolt icon around the screen to position your floating tool hub wherever convenient!',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ================= TAB 4: WEIGHTED DECISION WHEEL =================
class DecisionWheelView extends StatefulWidget {
  final Function(String) onNotify;
  const DecisionWheelView({super.key, required this.onNotify});

  @override
  State<DecisionWheelView> createState() => _DecisionWheelViewState();
}

class _DecisionWheelViewState extends State<DecisionWheelView> {
  final List<Map<String, dynamic>> _options = [
    {'name': 'Order Pizza', 'weight': 3.0},
    {'name': 'Cook Pasta', 'weight': 2.0},
    {'name': 'Eat Salad', 'weight': 1.0},
  ];

  final TextEditingController _newItemController = TextEditingController();
  String _selectedResult = '';
  bool _isSpinning = false;

  void _spinWheel() {
    if (_options.isEmpty) return;

    setState(() {
      _isSpinning = true;
      _selectedResult = '';
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      final rand = Random();
      double totalWeight = _options.fold(0, (sum, item) => sum + (item['weight'] as double));
      double randomVal = rand.nextDouble() * totalWeight;

      double currentSum = 0;
      String chosen = _options.first['name'];

      for (var item in _options) {
        currentSum += item['weight'] as double;
        if (randomVal <= currentSum) {
          chosen = item['name'];
          break;
        }
      }

      setState(() {
        _isSpinning = false;
        _selectedResult = chosen;
      });

      widget.onNotify('Decision Picked: $chosen');
    });
  }

  void _addNewOption() {
    if (_newItemController.text.trim().isNotEmpty) {
      setState(() {
        _options.add({
          'name': _newItemController.text.trim(),
          'weight': 2.0,
        });
        _newItemController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Micro-Decision Choice Matrix',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Can\'t decide what to pick? Set preference weights and let the weighted randomizer decide.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Decision Result Visualizer Box
          Card(
            color: Colors.indigo.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.casino, color: Colors.amber, size: 36),
                    const SizedBox(height: 8),
                    _isSpinning
                        ? const CircularProgressIndicator(color: Colors.amber)
                        : Text(
                            _selectedResult.isEmpty ? 'Tap Spin to Resolve Dilemma' : _selectedResult,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _isSpinning ? null : _spinWheel,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Spin Choice Wheel'),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newItemController,
                  decoration: const InputDecoration(
                    hintText: 'Add new option (e.g. Sushi)...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _addNewOption,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Options & Weight Ratings:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final item = _options[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _options.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Priority:', style: TextStyle(fontSize: 12)),
                          Expanded(
                            child: Slider(
                              value: item['weight'],
                              min: 1.0,
                              max: 5.0,
                              divisions: 4,
                              label: item['weight'].toStringAsFixed(0),
                              onChanged: (val) {
                                setState(() {
                                  item['weight'] = val;
                                });
                              },
                            ),
                          ),
                          Text(
                            'Weight: ${item[\'weight\'].toInt()}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// ================= TAB 5: QUICK SNIPPET VAULT =================
class SnippetVaultView extends StatefulWidget {
  final Function(String) onNotify;
  const SnippetVaultView({super.key, required this.onNotify});

  @override
  State<SnippetVaultView> createState() => _SnippetVaultViewState();
}

class _SnippetVaultViewState extends State<SnippetVaultView> {
  final List<Map<String, String>> _snippets = [
    {
      'title': 'Bank Account Wire Details',
      'content': 'Bank: Chase | Acct: 9876543210 | Routing: 123456789',
      'tag': 'Finance'
    },
    {
      'title': 'Home Shipping Address',
      'content': '124 Conch Street, Apt 4B, Bikini Bottom, CA 90210',
      'tag': 'Address'
    },
    {
      'title': 'Instagram Tech Hashtags',
      'content': '#FlutterDev #MobileApps #UIUX #Coding #SoftwareEngineering',
      'tag': 'Social'
    },
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedTag = 'General';

  void _addSnippet() {
    if (_titleController.text.trim().isNotEmpty && _contentController.text.trim().isNotEmpty) {
      setState(() {
        _snippets.add({
          'title': _titleController.text.trim(),
          'content': _contentController.text.trim(),
          'tag': _selectedTag,
        });
        _titleController.clear();
        _contentController.clear();
      });
      widget.onNotify('New Snippet Saved!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Snippet Vault',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Store address templates, bank account info, and hashtags for single-tap quick copy.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Quick Snippet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Snippet Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Snippet Content / Text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: _selectedTag,
                        items: ['General', 'Finance', 'Address', 'Social', 'Work']
                            .map((tag) => DropdownMenuItem(value: tag, child: Text(tag)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedTag = val;
                            });
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        onPressed: _addSnippet,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Snippet'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Saved Snippets Vault:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _snippets.length,
            itemBuilder: (context, index) {
              final item = _snippets[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.content_paste, size: 18),
                  ),
                  title: Text(
                    item['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(item['content'] ?? ''),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(
                          item['tag'] ?? 'General',
                          style: const TextStyle(fontSize: 10),
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      )
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.indigo),
                        tooltip: 'Copy Snippet',
                        onPressed: () {
                          widget.onNotify('Copied "${item['title']}" to clipboard!');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () {
                          setState(() {
                            _snippets.removeAt(index);
                          });
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}