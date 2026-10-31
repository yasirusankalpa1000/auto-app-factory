import 'package:flutter/material.dart';

void main() {
  runApp(const DockBuddyApp());
}

class DockBuddyApp extends StatelessWidget {
  const DockBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DockBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
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
  int _currentIndex = 0;
  bool _isOverlayEnabled = true;
  bool _isCompactMode = false;
  Offset _bubblePosition = const Offset(20, 150);

  // Clipboard items state
  final List<String> _pinnedClips = [
    "Address: 742 Evergreen Terrace, Springfield",
    "Promo Code: DISPATCH2025",
    "WiFi Pass: SuperFastNet#99",
  ];

  // Shopping deal calculator state
  double _itemPrice = 49.99;
  double _discountPercent = 20.0;
  double _taxPercent = 8.0;
  int _splitCount = 1;

  // Decision resolver state
  final List<String> _dilemmaOptions = [
    "Pizza",
    "Sushi",
    "Burgers",
    "Tacos",
    "Salad",
  ];
  String _selectedDecision = "Tap Spin to decide!";
  bool _isSpinning = false;

  // Floating notification text
  String _activeNote = "Tap floating bubble to open quick dock";

  void _addClip(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _pinnedClips.insert(0, text.trim());
      });
    }
  }

  void _removeClip(int index) {
    setState(() {
      _pinnedClips.removeAt(index);
    });
  }

  void _spinDecision() {
    if (_dilemmaOptions.isEmpty) return;
    setState(() {
      _isSpinning = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _dilemmaOptions.shuffle();
        _selectedDecision = _dilemmaOptions.first;
        _isSpinning = false;
      });
    });
  }

  void _showAddClipDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pin New Snippet"),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Enter address, code, or phone number...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addClip(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Snippet pinned to floating shelf!")),
                );
              },
              child: const Text("Save & Pin"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.deepPurple),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                "DockBuddy",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isOverlayEnabled ? Icons.layers : Icons.layers_clear,
              color: _isOverlayEnabled ? Colors.green : Colors.grey,
            ),
            tooltip: "Toggle Floating Assistant Overlay",
            onPressed: () {
              setState(() {
                _isOverlayEnabled = !_isOverlayEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isOverlayEnabled
                        ? "Floating Overlay Activated! Drag bubble anywhere."
                        : "Floating Overlay Deactivated.",
                  ),
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
              index: _currentIndex,
              children: [
                _buildFloatingShelfTab(theme),
                _buildShoppingDealTab(theme),
                _buildDecisionResolverTab(theme),
                _buildScreenRulerTab(theme),
                _buildSettingsTab(theme),
              ],
            ),
            if (_isOverlayEnabled) _buildSimulatedFloatingBubble(theme),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            selectedIcon: Icon(Icons.content_paste_go, color: Colors.deepPurple),
            label: "Shelf",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Colors.deepPurple),
            label: "Deals",
          ),
          NavigationDestination(
            icon: Icon(Icons.shuffle),
            selectedIcon: Icon(Icons.shuffle_on, color: Colors.deepPurple),
            label: "Decide",
          ),
          NavigationDestination(
            icon: Icon(Icons.straighten),
            selectedIcon: Icon(Icons.straighten, color: Colors.deepPurple),
            label: "Ruler",
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            selectedIcon: Icon(Icons.tune, color: Colors.deepPurple),
            label: "Dock Control",
          ),
        ],
      ),
    );
  }

  // Floating Overlay Bubble Simulator Widget
  Widget _buildSimulatedFloatingBubble(ThemeData theme) {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(30),
          color: Colors.deepPurple,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              _showQuickDockBottomSheet();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt, color: Colors.amber, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    _isCompactMode ? "Dock" : "DockBuddy Live",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickDockBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            "Floating Quick Shelf",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    "QUICK PINNED CLIPS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_pinnedClips.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text("No pinned clips yet."),
                    )
                  else
                    ..._pinnedClips.take(3).map((clip) => Card(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.copy, size: 18),
                            title: Text(
                              clip,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.check, size: 16),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Copied to clipboard!")),
                                );
                              },
                            ),
                          ),
                        )),
                  const SizedBox(height: 12),
                  const Text(
                    "INSTANT TOOLS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text("New Clip"),
                        onPressed: () {
                          Navigator.pop(context);
                          _showAddClipDialog();
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.shuffle, size: 16),
                        label: const Text("Pick Dinner"),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _currentIndex = 2;
                          });
                          _spinDecision();
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.calculate, size: 16),
                        label: const Text("20% Off Calc"),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _currentIndex = 1;
                            _discountPercent = 20;
                          });
                        },
                      ),
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

  // TAB 1: Floating Shelf & Clipboard Pinboard
  Widget _buildFloatingShelfTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.deepPurple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.deepPurple, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Floating Clipboard Shelf",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Keep addresses, serial numbers, and snippet clips pinned for instant access anywhere on screen.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pinned Snippets (${_pinnedClips.length})",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                onPressed: _showAddClipDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add Clip"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_pinnedClips.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.content_paste_off, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    const Text(
                      "No snippets pinned yet.\nTap 'Add Clip' to save quick context items!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedClips.length,
              itemBuilder: (context, index) {
                final item = _pinnedClips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.pin_drop, color: Colors.white, size: 18),
                    ),
                    title: Text(
                      item,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.blue),
                          tooltip: "Copy Snippet",
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Copied to clipboard: \"$item\""),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: "Delete Snippet",
                          onPressed: () => _removeClip(index),
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

  // TAB 2: Shopping Deal & Discount Visualizer
  Widget _buildShoppingDealTab(ThemeData theme) {
    final double discountAmount = _itemPrice * (_discountPercent / 100.0);
    final double priceAfterDiscount = _itemPrice - discountAmount;
    final double taxAmount = priceAfterDiscount * (_taxPercent / 100.0);
    final double finalPrice = priceAfterDiscount + taxAmount;
    final double splitPrice = finalPrice / (_splitCount > 0 ? _splitCount : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag, color: Colors.teal, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Smart Shopping Discount Visualizer",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Never get tricked by online sales. Calculate final checkout cost, tax, and group splits instantly.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
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
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Original Tag Price (\$) ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixText: "\$ ",
                      border: OutlineInputBorder(),
                      hintText: "49.99",
                    ),
                    onChanged: (val) {
                      setState(() {
                        _itemPrice = double.tryParse(val) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Quick Discount Buttons",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [10, 15, 20, 25, 30, 50, 70].map((pct) {
                      final bool isSelected = _discountPercent == pct.toDouble();
                      return ChoiceChip(
                        label: Text("$pct% OFF"),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _discountPercent = pct.toDouble();
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Discount: ${_discountPercent.toStringAsFixed(0)}%"),
                            Slider(
                              value: _discountPercent,
                              min: 0,
                              max: 90,
                              divisions: 18,
                              onChanged: (v) {
                                setState(() {
                                  _discountPercent = v;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tax: ${_taxPercent.toStringAsFixed(1)}%"),
                            Slider(
                              value: _taxPercent,
                              min: 0,
                              max: 25,
                              divisions: 50,
                              onChanged: (v) {
                                setState(() {
                                  _taxPercent = v;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Split with friends:"),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _splitCount > 1
                                ? () {
                                    setState(() {
                                      _splitCount--;
                                    });
                                  }
                                : null,
                          ),
                          Text(
                            "$_splitCount ${_splitCount == 1 ? 'person' : 'people'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                _splitCount++;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.teal.shade700,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("You Save:",
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text(
                        "\$${discountAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Estimated Tax:",
                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text(
                        "\$${taxAmount.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Final Net Price:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      Text(
                        "\$${finalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  if (_splitCount > 1) ...[
                    const Divider(color: Colors.white70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Each Person Pays ($_splitCount):",
                            style: const TextStyle(
                                color: Colors.amberAccent, fontWeight: FontWeight.w600)),
                        Text(
                          "\$${splitPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Micro-Decision Dilemma Resolver
  Widget _buildDecisionResolverTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.shuffle, color: Colors.orange, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Micro-Decision Dilemma Resolver",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Stuck deciding what to eat, watch, or do next? Let DockBuddy make micro-decisions effortlessly.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      "RECOMMENDED DECISION",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSpinning ? Icons.refresh : Icons.stars,
                        size: 48,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedDecision,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isSpinning ? Colors.grey : Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: _isSpinning ? null : _spinDecision,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(_isSpinning ? "Spinning..." : "Resolve Choice Now"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Current Options Pool",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text("Add Option"),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "e.g. Watch Movie, Order Burger...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              setState(() {
                                _dilemmaOptions.add(controller.text.trim());
                              });
                            }
                            Navigator.pop(c);
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: _dilemmaOptions.map((opt) {
              return Chip(
                label: Text(opt),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    _dilemmaOptions.remove(opt);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 4: Visual On-Screen Ruler
  Widget _buildScreenRulerTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.straighten, color: Colors.blue, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Precision On-Screen Ruler",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Place physical micro-objects (coins, screws, keys, cards) directly on the screen to measure rapidly.",
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.touch_app, color: Colors.white70, size: 36),
                        SizedBox(height: 8),
                        Text(
                          "Place object against ruler edge below",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                // Simulated Ruler Tick Marks
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.amber.shade700,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(12, (index) {
                        final bool isMajor = index % 3 == 0;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: isMajor ? 2.5 : 1.0,
                              height: isMajor ? 28 : 14,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 2),
                            if (isMajor)
                              Text(
                                "${index ~/ 3} cm",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Calibrated for standard mobile PPI scale.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 5: Dock Control & Overlay Settings
  Widget _buildSettingsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Floating Assistant Settings",
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text("Enable Floating Bubble Overlay"),
            subtitle: const Text("Shows floating HUD shortcut on screen"),
            value: _isOverlayEnabled,
            onChanged: (val) {
              setState(() {
                _isOverlayEnabled = val;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Compact Floating Mode"),
            subtitle: const Text("Reduces floating bubble width for less distraction"),
            value: _isCompactMode,
            onChanged: _isOverlayEnabled
                ? (val) {
                    setState(() {
                      _isCompactMode = val;
                    });
                  }
                : null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.deepPurple),
            title: const Text("Custom Floating Notification Text"),
            subtitle: Text(_activeNote),
            trailing: const Icon(Icons.edit),
            onTap: () {
              final controller = TextEditingController(text: _activeNote);
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text("Edit Notification Badge"),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(c),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activeNote = controller.text;
                        });
                        Navigator.pop(c);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.deepPurple.shade900,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        "DockBuddy Pro Status",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "All floating utilities active & ready for high-frequency daily usage.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}