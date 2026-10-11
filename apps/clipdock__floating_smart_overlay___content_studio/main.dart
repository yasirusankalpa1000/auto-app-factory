import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ClipDockApp());
}

class ClipDockApp extends StatelessWidget {
  const ClipDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClipDock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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
  int _currentIndex = 0;
  bool _isOverlayEnabled = true;
  bool _showFloatingBubble = true;
  Offset _bubblePosition = const Offset(20, 200);

  final List<String> _clipboardHistory = [
    "Check out this amazing creative direction! https://example.com/article?ref=123",
    "Meeting rescheduled to 3:30 PM tomorrow. Please bring the quarterly metrics.",
    "The secret of getting ahead is getting started.",
    "Use code SAVE50 at checkout to get \$50 off your first purchase!",
  ];

  void _addClipboardItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardHistory.insert(0, text.trim());
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to ClipDock Vault!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      FloatingOverlayTab(
        isOverlayEnabled: _isOverlayEnabled,
        onToggleOverlay: (val) {
          setState(() {
            _isOverlayEnabled = val;
            _showFloatingBubble = val;
          });
        },
        clipboardItems: _clipboardHistory,
        onAddItem: _addClipboardItem,
      ),
      ReplyGeneratorTab(
        onSaveToVault: _addClipboardItem,
      ),
      ViralCanvasTab(
        initialText: _clipboardHistory.isNotEmpty ? _clipboardHistory.first : "Your idea goes here...",
      ),
      ClipboardVaultTab(
        items: _clipboardHistory,
        onAddItem: _addClipboardItem,
        onDeleteItem: (index) {
          setState(() {
            _clipboardHistory.removeAt(index);
          });
        },
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: screens[_currentIndex],
          ),
          if (_showFloatingBubble)
            Positioned(
              left: _bubblePosition.dx,
              top: _bubblePosition.dy,
              child: GestureDetectWidget(
                onPanUpdate: (details) {
                  setState(() {
                    _bubblePosition += details.delta;
                  });
                },
                onTap: () {
                  _showOverlayModal(context);
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Overlay Dock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Smart Reply',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Viral Canvas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Clip Vault',
          ),
        ],
      ),
    );
  }

  void _showOverlayModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          "ClipDock Active Assistant",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  const Text(
                    "Quick Clipboard Actions:",
                    style: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.copy, size: 16, color: Colors.white),
                        label: const Text("Paste Last Clip"),
                        backgroundColor: Colors.indigo,
                        onPressed: () async {
                          ClipboardData? data = await Clipboard.getData('text/plain');
                          if (data != null && data.text != null) {
                            _addClipboardItem(data.text!);
                          }
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                        label: const Text("Stylize Text"),
                        backgroundColor: Colors.purple,
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() => _currentIndex = 3);
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.share, size: 16, color: Colors.white),
                        label: const Text("Create Story Card"),
                        backgroundColor: Colors.teal,
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() => _currentIndex = 2);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Active Background Services:",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text("Floating Window Permission Active", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GestureDetectWidget extends StatelessWidget {
  final GestureDragUpdateCallback onPanUpdate;
  final VoidCallback onTap;

  const GestureDetectWidget({
    super.key,
    required this.onPanUpdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.white70, width: 1.5),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, color: Colors.yellow, size: 20),
            SizedBox(width: 6),
            Text(
              "ClipDock",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingOverlayTab extends StatelessWidget {
  final bool isOverlayEnabled;
  final ValueChanged<bool> onToggleOverlay;
  final List<String> clipboardItems;
  final Function(String) onAddItem;

  const FloatingOverlayTab({
    super.key,
    required this.isOverlayEnabled,
    required this.onToggleOverlay,
    required this.clipboardItems,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderBar(
            title: "Overlay Assistant",
            subtitle: "Keep ClipDock running over any app for instant workflow.",
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Floating Service Status",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Simulates Display Over Apps permission for quick context access.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isOverlayEnabled,
                      onChanged: onToggleOverlay,
                      activeColor: Colors.indigoAccent,
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isOverlayEnabled ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOverlayEnabled ? Icons.notifications_active : Icons.notifications_off,
                        color: isOverlayEnabled ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isOverlayEnabled
                            ? "Active: Floating Widget ready on screen edge."
                            : "Inactive: Toggle switch to enable overlay widget.",
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Quick Add To Dock Vault",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          QuickInputField(onSubmitted: onAddItem),
          const SizedBox(height: 20),
          const Text(
            "Recent Screen Snippets",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (clipboardItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No snippets added yet.", style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: clipboardItems.length > 3 ? 3 : clipboardItems.length,
              itemBuilder: (context, index) {
                final item = clipboardItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.format_quote, color: Colors.indigoAccent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied to clipboard!')),
                          );
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
}

class ReplyGeneratorTab extends StatefulWidget {
  final Function(String) onSaveToVault;

  const ReplyGeneratorTab({super.key, required this.onSaveToVault});

  @override
  State<ReplyGeneratorTab> createState() => _ReplyGeneratorTabState();
}

class _ReplyGeneratorTabState extends State<ReplyGeneratorTab> {
  final TextEditingController _promptController = TextEditingController();
  String _selectedTone = "Witty";
  String _generatedReply = "";

  final List<String> _tones = ["Witty", "Professional", "Casual", "Flirty", "Aesthetic"];

  void _generateReply() {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_selectedTone == "Witty") {
        _generatedReply = "Haha, fair point! But if you think about it: $text 😏";
      } else if (_selectedTone == "Professional") {
        _generatedReply = "Thank you for sharing. Regarding '$text', I will review this promptly and get back to you with next steps.";
      } else if (_selectedTone == "Casual") {
        _generatedReply = "Oh totally! $text Sounds like a plan to me 🙌";
      } else if (_selectedTone == "Flirty") {
        _generatedReply = "You always know how to catch my attention ;) Especially with '$text' ✨";
      } else {
        _generatedReply = "✦ $text ✦ ·.✦ living for this vibe ✨";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderBar(
            title: "Smart Reply Composer",
            subtitle: "Craft perfect responses and captions for any social media app.",
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _promptController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Paste message received or topic here...",
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Response Tone:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tones.map((tone) {
                final isSelected = _selectedTone == tone;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tone),
                    selected: isSelected,
                    selectedColor: Colors.indigo,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedTone = tone;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _generateReply,
              icon: const Icon(Icons.bolt, color: Colors.white),
              label: const Text(
                "Generate Smart Response",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_generatedReply.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigoAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tone: $_selectedTone",
                        style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _generatedReply));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied response!')),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _generatedReply,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    softWrap: true,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => widget.onSaveToVault(_generatedReply),
                    icon: const Icon(Icons.bookmark_add, size: 16, color: Colors.indigoAccent),
                    label: const Text("Save to Vault", style: TextStyle(color: Colors.indigoAccent)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.indigoAccent),
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
}

class ViralCanvasTab extends StatefulWidget {
  final String initialText;

  const ViralCanvasTab({super.key, required this.initialText});

  @override
  State<ViralCanvasTab> createState() => _ViralCanvasTabState();
}

class _ViralCanvasTabState extends State<ViralCanvasTab> {
  late TextEditingController _textController;
  Color _cardColor = Colors.indigo;
  String _author = "@creative_mind";

  final List<Color> _colorOptions = [
    Colors.indigo,
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderBar(
            title: "Viral Canvas Studio",
            subtitle: "Turn snippets & quotes into beautiful shareable story cards.",
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Enter card quote...",
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Theme Color: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Wrap(
                spacing: 8,
                children: _colorOptions.map((color) {
                  final isSelected = _cardColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _cardColor = color),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Live Preview Card:", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, color: Colors.white70, size: 36),
                const SizedBox(height: 12),
                Text(
                  _textController.text.isEmpty ? "Your aesthetic quote preview..." : _textController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _author,
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("ClipDock", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: "${_textController.text} - $_author"));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card quote copied for sharing!')),
                );
              },
              icon: const Icon(Icons.share, color: Colors.white),
              label: const Text("Export & Copy Card", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClipboardVaultTab extends StatefulWidget {
  final List<String> items;
  final Function(String) onAddItem;
  final Function(int) onDeleteItem;

  const ClipboardVaultTab({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onDeleteItem,
  });

  @override
  State<ClipboardVaultTab> createState() => _ClipboardVaultTabState();
}

class _ClipboardVaultTabState extends State<ClipboardVaultTab> {
  String _selectedStyle = "Bubble";

  String _applyStyle(String text) {
    if (text.isEmpty) return "";
    if (_selectedStyle == "Bubble") {
      return text.split('').map((char) => "ⓅⓄⓅ: $char").take(15).join();
    } else if (_selectedStyle == "Clean URL") {
      return text.replaceAll(RegExp(r'\?.*'), '');
    } else if (_selectedStyle == "Hashtag") {
      return text.split(' ').map((w) => "#$w").join(' ');
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderBar(
            title: "Clip Vault & Text Styler",
            subtitle: "Organize, format, and stylize your daily clipboard entries.",
          ),
          const SizedBox(height: 16),
          QuickInputField(onSubmitted: widget.onAddItem),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Quick Formatting Tool:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedStyle,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                items: ["Bubble", "Clean URL", "Hashtag"].map((s) {
                  return DropdownMenuItem(value: s, child: Text(s));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStyle = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text("Vault is empty. Add items above!", style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final formatted = _applyStyle(item);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white70),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        softWrap: true,
                      ),
                      if (formatted != item) ...[
                        const SizedBox(height: 8),
                        Text(
                          "Formatted: $formatted",
                          style: const TextStyle(color: Colors.indigoAccent, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: formatted));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Copied formatted clip!')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                            onPressed: () => widget.onDeleteItem(index),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class HeaderBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const HeaderBar({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, color: Colors.indigoAccent, size: 28),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
          softWrap: true,
        ),
      ],
    );
  }
}

class QuickInputField extends StatefulWidget {
  final Function(String) onSubmitted;

  const QuickInputField({super.key, required this.onSubmitted});

  @override
  State<QuickInputField> createState() => _QuickInputFieldState();
}

class _QuickInputFieldState extends State<QuickInputField> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSubmitted(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Add note or snippet...",
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: _submit,
          icon: const Icon(Icons.add, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}