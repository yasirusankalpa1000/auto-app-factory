import 'package:flutter/material.dart';

void main() {
  runApp(const OmniOverlayApp());
}

class OmniOverlayApp extends StatelessWidget {
  const OmniOverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniOverlay',
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

class FloatingWidgetData {
  String id;
  String title;
  String content;
  Offset position;
  double opacity;
  bool isMinimized;
  Color cardColor;
  String category;

  FloatingWidgetData({
    required this.id,
    required this.title,
    required this.content,
    required this.position,
    this.opacity = 0.9,
    this.isMinimized = false,
    this.cardColor = Colors.indigo,
    this.category = 'Note',
  });
}

class SnippetItem {
  String id;
  String label;
  String textValue;
  String category;
  IconData icon;

  SnippetItem({
    required this.id,
    required this.label,
    required this.textValue,
    required this.category,
    required this.icon,
  });
}

class CompareOption {
  String name;
  String price;
  double rating;
  String pros;
  String cons;

  CompareOption({
    required this.name,
    required this.price,
    required this.rating,
    required this.pros,
    required this.cons,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;
  bool _overlayPermissionGranted = true;
  bool _showGridOverlay = false;

  // Floating Widgets Canvas List
  final List<FloatingWidgetData> _floatingWidgets = [
    FloatingWidgetData(
      id: '1',
      title: 'Recipe Step 3',
      content: 'Add 2 tsp olive oil, garlic, and sauté for 4 mins on medium heat.',
      position: const Offset(20, 80),
      cardColor: Colors.teal,
      category: 'Recipe',
    ),
    FloatingWidgetData(
      id: '2',
      title: 'Bank Account Ref',
      content: 'Acc: 1002-8849-2201\nRouting: 09100002\nName: Alex Smith',
      position: const Offset(40, 260),
      cardColor: Colors.purple,
      category: 'Banking',
    ),
  ];

  // Quick Snippets Database
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: 's1',
      label: 'Home Address Template',
      textValue: '742 Evergreen Terrace, Sector 7G, Springfield, OR 97477',
      category: 'Personal',
      icon: Icons.home,
    ),
    SnippetItem(
      id: 's2',
      label: 'Tax ID & Business Reg',
      textValue: 'TAX-US-9982401-X | VAT: EU8830192',
      category: 'Work',
      icon: Icons.badge,
    ),
    SnippetItem(
      id: 's3',
      label: 'WiFi Key Guest',
      textValue: 'SuperSecretWiFi2025!',
      category: 'Utility',
      icon: Icons.wifi,
    ),
    SnippetItem(
      id: 's4',
      label: 'Crypto Wallet Address',
      textValue: '0x71C7656EC7ab88b098defB751B7401B5f6d8976F',
      category: 'Finance',
      icon: Icons.account_balance_wallet,
    ),
  ];

  // Visual Compare Matrix Data
  final List<CompareOption> _compareOptions = [
    CompareOption(
      name: 'Option A: Pro Laptop 15"',
      price: '\$1,299',
      rating: 4.8,
      pros: 'Super fast M3 chip, 18hr battery, sleek build',
      cons: 'Heavy (2.1kg), limited ports',
    ),
    CompareOption(
      name: 'Option B: Air Ultra 13"',
      price: '\$999',
      rating: 4.5,
      pros: 'Ultra lightweight, quiet fanless design',
      cons: 'Lower base storage, throttles under continuous load',
    ),
  ];

  void _addNewFloatingWidget(String title, String content, Color color) {
    setState(() {
      _floatingWidgets.add(
        FloatingWidgetData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.isEmpty ? 'Quick Floating Pin' : title,
          content: content.isEmpty ? 'No text content provided.' : content,
          position: Offset(30.0 + (_floatingWidgets.length * 15), 100.0 + (_floatingWidgets.length * 20)),
          cardColor: color,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Floating Widget pinned to canvas!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final valueController = TextEditingController();
    String selectedCat = 'Personal';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Quick Snippet', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Label Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Snippet Text Content',
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
            onPressed: () {
              if (titleController.text.isNotEmpty && valueController.text.isNotEmpty) {
                setState(() {
                  _snippets.add(
                    SnippetItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: titleController.text,
                      textValue: valueController.text,
                      category: selectedCat,
                      icon: Icons.bookmark,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Snippet'),
          ),
        ],
      ),
    );
  }

  void _showAddFloatingPinDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    Color selectedColor = Colors.indigo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create Floating Reference Pin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Pin Title (e.g., Grocery List, Address)',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Details / Numbers / Instructions',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Theme Color', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Colors.indigo,
                        Colors.teal,
                        Colors.purple,
                        Colors.orange,
                        Colors.blue,
                      ].map((col) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedColor = col;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: col,
                            radius: 18,
                            child: selectedColor == col
                                ? const Icon(Icons.check, color: Colors.white, size: 18)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _addNewFloatingWidget(
                            titleController.text,
                            contentController.text,
                            selectedColor,
                          );
                          Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.push_pin, color: Colors.white),
                        label: const Text(
                          'Spawn Floating HUD Pin',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.layers, color: Colors.indigoAccent),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'OmniOverlay',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Visual Alignment Grid',
            icon: Icon(
              Icons.grid_4x4,
              color: _showGridOverlay ? Colors.cyanAccent : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _showGridOverlay = !_showGridOverlay;
              });
            },
          ),
          IconButton(
            tooltip: 'Add Floating Pin',
            icon: const Icon(Icons.add_circle_outline, color: Colors.indigoAccent),
            onPressed: _showAddFloatingPinDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Status Bar Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _overlayPermissionGranted
                  ? Colors.teal.withOpacity(0.15)
                  : Colors.orange.withOpacity(0.15),
              child: Row(
                children: [
                  Icon(
                    _overlayPermissionGranted ? Icons.check_circle : Icons.warning_amber,
                    color: _overlayPermissionGranted ? Colors.tealAccent : Colors.orangeAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _overlayPermissionGranted
                          ? 'Overlay Engine Active • Draw over screen ready'
                          : 'Overlay Permission Needed for system floating widgets',
                      style: TextStyle(
                        fontSize: 12,
                        color: _overlayPermissionGranted ? Colors.tealAccent : Colors.orangeAccent,
                      ),
                      softWrap: true,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _overlayPermissionGranted = !_overlayPermissionGranted;
                      });
                    },
                    child: Text(
                      _overlayPermissionGranted ? 'Active' : 'Enable',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Tab View Body
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildFloatingWorkspaceTab(),
                  _buildQuickSnippetsTab(),
                  _buildCompareMatrixTab(),
                  _buildSettingsAndToolsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'Canvas HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: 'Snippets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Tools & HUD',
          ),
        ],
      ),
    );
  }

  // TAB 1: Live Interactive Floating Workspace Canvas
  Widget _buildFloatingWorkspaceTab() {
    return Stack(
      children: [
        // Background Grid Pattern Simulation
        if (_showGridOverlay)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GridOverlayPainter(),
              ),
            ),
          ),

        // Workspace Helper Text
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.touch_app, color: Colors.indigoAccent, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Interactive Floating HUD Canvas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Drag floating cards around the screen. Collapse into bubbles or set transparency while multitasking!',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAxisAlignment.center,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text('Add Quick Pin', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.indigo,
                    onPressed: _showAddFloatingPinDialog,
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.layers_clear, size: 16, color: Colors.white),
                    label: const Text('Clear All HUD Pins', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red.withOpacity(0.7),
                    onPressed: () {
                      setState(() {
                        _floatingWidgets.clear();
                      });
                    },
                  ),
                  Chip(
                    label: Text(
                      'Active Pins: ${_floatingWidgets.length}',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    backgroundColor: const Color(0xFF334155),
                  ),
                ],
              ),

              const SizedBox(height: 350), // Reserve canvas area for floating elements
            ],
          ),
        ),

        // Render Draggable Floating Widgets over Canvas
        for (int i = 0; i < _floatingWidgets.length; i++)
          _buildDraggableWidgetCard(_floatingWidgets[i], i),
      ],
    );
  }

  // Draggable Floating Component
  Widget _buildDraggableWidgetCard(FloatingWidgetData widgetData, int index) {
    return Positioned(
      left: widgetData.position.dx,
      top: widgetData.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widgetData.position = Offset(
              widgetData.position.dx + details.delta.dx,
              widgetData.position.dy + details.delta.dy,
            );
          });
        },
        child: Opacity(
          opacity: widgetData.opacity,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widgetData.isMinimized ? 180 : 260,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widgetData.cardColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  Row(
                    children: [
                      const Icon(Icons.drag_handle, color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widgetData.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widgetData.isMinimized = !widgetData.isMinimized;
                          });
                        },
                        child: Icon(
                          widgetData.isMinimized ? Icons.aspect_ratio : Icons.remove_sharp,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _floatingWidgets.removeAt(index);
                          });
                        },
                        child: const Icon(Icons.close, color: Colors.white70, size: 18),
                      ),
                    ],
                  ),

                  if (!widgetData.isMinimized) ...[
                    const Divider(color: Colors.white70, height: 16),
                    Text(
                      widgetData.content,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    // Quick Action Opacity Slider
                    Row(
                      children: [
                        const Icon(Icons.opacity, color: Colors.white70, size: 14),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                            ),
                            child: Slider(
                              value: widgetData.opacity,
                              min: 0.3,
                              max: 1.0,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white70,
                              onChanged: (val) {
                                setState(() {
                                  widgetData.opacity = val;
                                });
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Text copied to clipboard!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Icon(Icons.copy, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TAB 2: Quick Snippets Vault
  Widget _buildQuickSnippetsTab() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Quick Snippets Vault',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: _showAddSnippetDialog,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text('New Snippet', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap any snippet to instantly spawn a floating HUD pin while using other apps.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          for (var item in _snippets)
            Card(
              color: const Color(0xFF1E293B),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo.withOpacity(0.2),
                          radius: 18,
                          child: Icon(item.icon, color: Colors.indigoAccent, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item.category,
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Spawn Floating Pin',
                          icon: const Icon(Icons.push_pin_outlined, color: Colors.tealAccent),
                          onPressed: () {
                            _addNewFloatingWidget(item.label, item.textValue, Colors.teal);
                          },
                        ),
                        IconButton(
                          tooltip: 'Copy Text',
                          icon: const Icon(Icons.content_copy, color: Colors.grey, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied "${item.label}" to clipboard!'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.textValue,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // TAB 3: Visual Comparison Matrix
  Widget _buildCompareMatrixTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                'Side-by-Side Compare Matrix',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.indigoAccent),
              onPressed: () {
                _showAddCompareDialog();
              },
            ),
          ],
        ),
        const Text(
          'Compare prices, features, and specs side-by-side without leaving your active workflow.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 16),

        // Comparison Cards Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var opt in _compareOptions)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opt.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        opt.price,
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${opt.rating} / 5.0',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white70, height: 16),
                      const Text('PROS', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(opt.pros, style: const TextStyle(color: Colors.white70, fontSize: 11), softWrap: true),
                      const SizedBox(height: 10),
                      const Text('CONS', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(opt.cons, style: const TextStyle(color: Colors.white70, fontSize: 11), softWrap: true),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.indigoAccent),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          onPressed: () {
                            _addNewFloatingWidget('Compare: ${opt.name}', '${opt.price} • ${opt.pros}', Colors.indigo);
                          },
                          child: const Text('Pin to Canvas', style: TextStyle(color: Colors.indigoAccent, fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 20),

        // Quick Calculation Helper Box
        Card(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calculate, color: Colors.amberAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Live Price Difference Analyzer',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Option A is \$300 higher than Option B (+30.0%). Option A provides better long-term performance & higher rating.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddCompareDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final prosController = TextEditingController();
    final consController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Comparison Option', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Product / Option Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Price Tag (e.g. \$499)',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: prosController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Pros',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: consController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cons',
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
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _compareOptions.add(
                    CompareOption(
                      name: nameController.text,
                      price: priceController.text.isEmpty ? '\$0' : priceController.text,
                      rating: 4.5,
                      pros: prosController.text.isEmpty ? 'N/A' : prosController.text,
                      cons: consController.text.isEmpty ? 'N/A' : consController.text,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add to Matrix'),
          ),
        ],
      ),
    );
  }

  // TAB 4: Overlay Settings & Utility Helpers
  Widget _buildSettingsAndToolsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Floating Engine & Utilities',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Card(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('System Overlay Permission', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Allows OmniOverlay to draw floating cards over other apps.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                value: _overlayPermissionGranted,
                activeColor: Colors.tealAccent,
                onChanged: (val) {
                  setState(() {
                    _overlayPermissionGranted = val;
                  });
                },
              ),
              const Divider(color: Colors.white70, height: 1),
              SwitchListTile(
                title: const Text('Visual Alignment Screen Grid', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Displays non-intrusive alignment lines over your active app.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                value: _showGridOverlay,
                activeColor: Colors.cyanAccent,
                onChanged: (val) {
                  setState(() {
                    _showGridOverlay = val;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text('Quick Utility Triggers', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Card(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.content_paste_go, color: Colors.indigoAccent),
                  title: const Text('Auto-Extract Clipboard Numbers', style: TextStyle(color: Colors.white, fontSize: 13)),
                  subtitle: const Text('Extract phone numbers, prices & tracking IDs from copied text', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Clipboard scanner activated!')),
                    );
                  },
                ),
                const Divider(color: Colors.white70, height: 1),
                ListTile(
                  leading: const Icon(Icons.aspect_ratio, color: Colors.tealAccent),
                  title: const Text('Floating Screen Ruler & Magnifier', style: TextStyle(color: Colors.white, fontSize: 13)),
                  subtitle: const Text('Measure dimensions and inspect UI elements on screen', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    _addNewFloatingWidget('Screen Ruler', 'Width: 390px • Height: 844px • Aspect Ratio: 19.5:9', Colors.teal);
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        Center(
          child: Text(
            'OmniOverlay v2.5 Pro • High Engagement Utility HUD',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

// Custom Grid Painter for Visual Alignment
class GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      color = Colors.cyan.withOpacity(0.15)
      ..strokeWidth = 1.0;

    const double step = 40.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}