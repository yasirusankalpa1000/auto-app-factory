import 'package:flutter/material.dart';

void main() {
  runApp(const OmniHUDApp());
}

class OmniHUDApp extends StatelessWidget {
  const OmniHUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.amber,
          surface: Color(0xFF1E293B),
        ),
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
  int _currentBottomNavIndex = 0;
  
  // User Profile / Settings State
  double _hourlyRate = 18.50;
  double _totalMoneySaved = 245.00;
  bool _overlayPermissionGranted = true;
  bool _notificationsEnabled = true;

  // Floating Overlay Bubble Drag State
  Offset _bubblePosition = const Offset(20, 200);
  bool _isHUDExpanded = false;
  String _activeNotificationMessage = "OmniHUD Floating Shield Active";

  // Impulse Shield State
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final List<Map<String, dynamic>> _vaultedItems = [
    {"name": "Wireless Headphones", "price": 89.99, "hours": 4.86, "hoursLeft": 18, "status": "Cooling"},
    {"name": "Gaming Mouse", "price": 45.00, "hours": 2.43, "hoursLeft": 6, "status": "Cooling"},
  ];

  // Quick Notes State
  final TextEditingController _noteInputController = TextEditingController();
  final List<String> _pinnedNotes = [
    "Grocery list: Milk, Eggs, Oats",
    "WiFi Password: SafePass2025",
    "Call mechanic at 4:00 PM",
  ];

  // Micro Decision State
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  String _decisionResult = "";

  void _showNotification(String msg) {
    setState(() {
      _activeNotificationMessage = msg;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF334155),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addImpulseToVault() {
    final String name = _itemNameController.text.trim();
    final double? price = double.tryParse(_itemPriceController.text.trim());

    if (name.isEmpty || price == null || price <= 0) {
      _showNotification("Please enter a valid product name and price!");
      return;
    }

    final double hoursNeeded = price / (_hourlyRate > 0 ? _hourlyRate : 1.0);

    setState(() {
      _vaultedItems.add({
        "name": name,
        "price": price,
        "hours": hoursNeeded,
        "hoursLeft": 24,
        "status": "Cooling",
      });
      _itemNameController.clear();
      _itemPriceController.clear();
    });

    _showNotification("Locked \$${price.toStringAsFixed(2)} in 24h Vault! Avoided impulse purchase.");
  }

  void _claimSavedMoney(int index) {
    setState(() {
      final item = _vaultedItems[index];
      _totalMoneySaved += item["price"] as double;
      _vaultedItems.removeAt(index);
    });
    _showNotification("Awesome! You saved money and boosted your score!");
  }

  void _makeMicroDecision() {
    final optA = _optionAController.text.trim();
    final optB = _optionBController.text.trim();

    if (optA.isEmpty || optB.isEmpty) {
      setState(() {
        _decisionResult = "Please enter two options to compare!";
      });
      return;
    }

    final choices = [optA, optB];
    choices.shuffle();
    setState(() {
      _decisionResult = "Smart Choice: GO WITH -> \"${choices.first}\"";
    });
    _showNotification("Decision Matrix solved your conflict!");
  }

  void _addQuickNote() {
    final note = _noteInputController.text.trim();
    if (note.isNotEmpty) {
      setState(() {
        _pinnedNotes.insert(0, note);
        _noteInputController.clear();
      });
      _showNotification("Pinned note to Floating HUD!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Main Body Content
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _currentBottomNavIndex,
                    children: [
                      _buildImpulseShieldTab(),
                      _buildMicroDecisionTab(),
                      _buildScratchpadTab(),
                      _buildHUDSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating System Overlay Bubble Simulation (Draggable)
          Positioned(
            left: _bubblePosition.dx.clamp(0.0, screenSize.width - 70.0),
            top: _bubblePosition.dy.clamp(50.0, screenSize.height - 130.0),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _bubblePosition += details.delta;
                });
              },
              child: _buildFloatingHUDBubble(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (idx) {
          setState(() {
            _currentBottomNavIndex = idx;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Impulse Shield',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Decide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Floating Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'HUD Controls',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.flash_on, color: Colors.teal, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OmniHUD System Companion',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Saved Total: \$${_totalMoneySaved.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _overlayPermissionGranted ? Icons.check_circle : Icons.info,
                  color: Colors.teal,
                  size: 14,
                ),
                const SizedBox(width: 4),
                const Text(
                  'HUD Active',
                  style: TextStyle(color: Colors.teal, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: Impulse Shield & Work-Hour Converter
  Widget _buildImpulseShieldTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: "Impulse Purchase Work-Hour Converter",
              subtitle: "Before buying online, check how many actual work hours it costs you!",
              icon: Icons.monetization_on,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _itemNameController,
                      decoration: const InputDecoration(
                        labelText: "Item Name / Shopping Link",
                        hintText: "e.g., Wireless Earbuds",
                        prefixIcon: Icon(Icons.shopping_bag, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _itemPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Price (\$) ",
                        hintText: "e.g., 49.99",
                        prefixIcon: Icon(Icons.attach_money, color: Colors.amber),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addImpulseToVault,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.lock_clock),
                        label: const Text(
                          "Lock in 24-Hour Cooloff Vault",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Cooloff Vault (Active Items)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    "${_vaultedItems.length} Items",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Colors.teal.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_vaultedItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white70),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.shield_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "Your Vault is Empty!",
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Add impulse items above to prevent unnecessary purchases.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _vaultedItems.length,
                itemBuilder: (ctx, idx) {
                  final item = _vaultedItems[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: const Color(0xFF1E293B),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.lock, color: Colors.black),
                      ),
                      title: Text(
                        item["name"].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAxisAlignment.center,
                        children: [
                          Text(
                            "\$${(item["price"] as double).toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "= ${(item["hours"] as double).toStringAsFixed(1)} Work Hrs",
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                        tooltip: "I Resisted & Saved!",
                        onPressed: () => _claimSavedMoney(idx),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Micro Decision Matrix
  Widget _buildMicroDecisionTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: "Micro-Decision Resolver",
              subtitle: "Stuck on daily trivial choices? Let OmniHUD resolve decision fatigue instantly.",
              icon: Icons.calculate,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _optionAController,
                      decoration: const InputDecoration(
                        labelText: "Option A",
                        hintText: "e.g., Cook dinner at home",
                        prefixIcon: Icon(Icons.looks_one, color: Colors.teal),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _optionBController,
                      decoration: const InputDecoration(
                        labelText: "Option B",
                        hintText: "e.g., Order takeout food",
                        prefixIcon: Icon(Icons.looks_two, color: Colors.amber),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _makeMicroDecision,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text(
                          "Resolve Micro Decision",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_decisionResult.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      _decisionResult,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              "Quick Preset Matrices",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAxisAlignment.center,
              children: [
                _buildPresetChip("Buy Now vs Wait 24h", "Buy Now", "Wait 24h"),
                _buildPresetChip("Order Takeout vs Cook", "Order Takeout", "Cook Home"),
                _buildPresetChip("Work Out vs Rest", "Work Out", "Rest Today"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, String opt1, String opt2) {
    return ActionChip(
      backgroundColor: const Color(0xFF1E293B),
      avatar: const Icon(Icons.flash_on, size: 16, color: Colors.amber),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      onPressed: () {
        setState(() {
          _optionAController.text = opt1;
          _optionBController.text = opt2;
        });
      },
    );
  }

  // TAB 3: Quick Pinned Scratchpad & Clipboard HUD
  Widget _buildScratchpadTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: "Floating Scratchpad & Snippets",
              subtitle: "Quick notes pinned directly to your screen HUD overlay while using other apps.",
              icon: Icons.widgets,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteInputController,
                    decoration: const InputDecoration(
                      labelText: "Quick Floating Snippet",
                      hintText: "Type note or paste clip...",
                      prefixIcon: Icon(Icons.edit, color: Colors.teal),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addQuickNote,
                  backgroundColor: Colors.teal,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pinnedNotes.length,
              itemBuilder: (ctx, idx) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    leading: const Icon(Icons.push_pin, color: Colors.amber, size: 20),
                    title: Text(
                      _pinnedNotes[idx],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey, size: 18),
                      onPressed: () {
                        setState(() {
                          _pinnedNotes.removeAt(idx);
                        });
                        _showNotification("Note removed!");
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: HUD Settings & Permissions
  Widget _buildHUDSettingsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: "HUD Control Center & Rates",
              subtitle: "Customize your floating companion permissions and hourly work wage.",
              icon: Icons.settings,
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                                "Display Over Other Apps",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Allows floating bubble on device screen",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _overlayPermissionGranted,
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              _overlayPermissionGranted = val;
                            });
                            _showNotification(
                                val ? "Overlay Permission Active" : "Overlay Permission Disabled");
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Colors.white70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "System Push Alerts",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Cooloff vault timers & floating triggers",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notificationsEnabled,
                          activeColor: Colors.teal,
                          onChanged: (val) {
                            setState(() {
                              _notificationsEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hourly Wage / Earnings Rate",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Used to calculate how many labor hours an impulse purchase costs.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _hourlyRate,
                            min: 5.0,
                            max: 150.0,
                            divisions: 145,
                            activeColor: Colors.teal,
                            label: "\$${_hourlyRate.toStringAsFixed(2)}/hr",
                            onChanged: (val) {
                              setState(() {
                                _hourlyRate = val;
                              });
                            },
                          ),
                        ),
                        Text(
                          "\$${_hourlyRate.toStringAsFixed(2)}/hr",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 15),
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

  // Floating Draggable HUD Overlay Widget (Simulator)
  Widget _buildFloatingHUDBubble() {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isHUDExpanded)
            Container(
              width: 220,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal, width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "OmniHUD Quick Bar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHUDExpanded = false;
                          });
                        },
                        child: const Icon(Icons.close, size: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 12),
                  Text(
                    "Active Note: ${_pinnedNotes.isNotEmpty ? _pinnedNotes.first : 'No pinned notes'}",
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          _showNotification("Floating Quick Shield Engaged!");
                        },
                        child: const Text("Shield On", style: TextStyle(fontSize: 10, color: Colors.white)),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: Colors.amber),
                        ),
                        onPressed: () {
                          _showNotification("Hourly wage: \$${_hourlyRate.toStringAsFixed(2)}");
                        },
                        child: const Text("Rate Check", style: TextStyle(fontSize: 10, color: Colors.amber)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHUDExpanded = !_isHUDExpanded;
              });
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.teal, Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.flash_on,
                color: Colors.amber,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}