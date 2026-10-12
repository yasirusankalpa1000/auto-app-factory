import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
      ),
      home: const FloatDeckHomeScreen(),
    );
  }
}

class FloatDeckHomeScreen extends StatefulWidget {
  const FloatDeckHomeScreen({super.key});

  @override
  State<FloatDeckHomeScreen> createState() => _FloatDeckHomeScreenState();
}

class _FloatDeckHomeScreenState extends State<FloatDeckHomeScreen> {
  int _currentTab = 0;

  // Floating Bubble State
  Offset _bubblePos = const Offset(20, 180);
  bool _isBubbleExpanded = false;
  double _bubbleSize = 58.0;
  Color _bubbleColor = Colors.deepPurple;
  IconData _bubbleIcon = Icons.widgets;
  bool _snapToEdge = true;

  // Privacy Shield State
  bool _isPrivacyShieldActive = false;
  double _privacyOpacity = 0.65;
  Color _privacyMaskColor = Colors.black;
  double _privacyMaskHeight = 160.0;

  // Text Vault State
  final List<Map<String, String>> _textVault = [
    {
      'title': 'Bank Account details',
      'category': 'Finance',
      'content': 'ACC: 8820-192-3301 | SWIFT: EXAMUS33'
    },
    {
      'title': 'Home Address',
      'category': 'Personal',
      'content': '742 Evergreen Terrace, Springfield, OR 97477'
    },
    {
      'title': 'WhatsApp Canned Reply',
      'category': 'Work',
      'content': 'Hi! I am currently in a meeting. Will reply shortly!'
    },
    {
      'title': 'Wi-Fi Password Guest',
      'category': 'Home',
      'content': 'SecureGuestNet2025!'
    },
  ];

  // Quick Calculator State
  double _billAmount = 150.0;
  int _splitPeople = 3;
  double _tipPercentage = 10.0;

  // Active Overlay Notification State
  bool _showFloatingNotification = true;
  String _notificationMessage = "FloatDeck Active: Drag bubble anywhere on screen!";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Tab View Body
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildCanvasStudioTab(screenSize),
                      _buildTextVaultTab(),
                      _buildPrivacyShieldTab(),
                      _buildQuickCalcTab(),
                      _buildCustomizerTab(),
                    ],
                  ),
                ),
              ],
            ),

            // Privacy Screen Shield Mask Overlay (Simulated)
            if (_isPrivacyShieldActive)
              Positioned(
                left: 0,
                right: 0,
                top: 120,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _privacyMaskHeight = (_privacyMaskHeight + details.delta.dy)
                          .clamp(80.0, screenSize.height - 200.0);
                    });
                  },
                  child: Container(
                    height: _privacyMaskHeight,
                    decoration: BoxDecoration(
                      color: _privacyMaskColor.withOpacity(_privacyOpacity),
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.amber.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.security, color: Colors.amber, size: 28),
                          const SizedBox(height: 4),
                          const Text(
                            "PRIVACY MASK ACTIVE",
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            "Drag top/bottom border to resize screen shield",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Top Floating Notification Banner
            if (_showFloatingNotification)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active, color: Colors.amber, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _notificationMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _showFloatingNotification = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Live Interactive Draggable Floating Bubble
            Positioned(
              left: _bubblePos.dx,
              top: _bubblePos.dy,
              child: GestureDetectingFloatingBubble(
                size: _bubbleSize,
                color: _bubbleColor,
                icon: _bubbleIcon,
                isExpanded: _isBubbleExpanded,
                onDragUpdate: (dragDetails) {
                  setState(() {
                    _bubblePos += dragDetails.delta;
                    // Keep bubble inside screen bounds
                    double maxX = screenSize.width - _bubbleSize - 10;
                    double maxY = screenSize.height - _bubbleSize - 90;
                    _bubblePos = Offset(
                      _bubblePos.dx.clamp(5.0, maxX),
                      _bubblePos.dy.clamp(10.0, maxY),
                    );
                  });
                },
                onDragEnd: () {
                  if (_snapToEdge) {
                    setState(() {
                      double midX = screenSize.width / 2;
                      double targetX = _bubblePos.dx < midX ? 10.0 : screenSize.width - _bubbleSize - 10;
                      _bubblePos = Offset(targetX, _bubblePos.dy);
                    });
                  }
                },
                onTap: () {
                  setState(() {
                    _isBubbleExpanded = !_isBubbleExpanded;
                  });
                },
                onQuickAction: (actionName) {
                  _handleFloatingAction(actionName);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) {
          setState(() {
            _currentTab = idx;
          });
        },
        backgroundColor: const Color(0xFF161524),
        indicatorColor: Colors.deepPurple,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize),
            label: 'Canvas',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste_go),
            label: 'Text Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.security),
            label: 'Privacy Shield',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Quick Math',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'Deck Style',
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF161524),
        border: Border(
          bottom: BorderSide(color: Colors.white70, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FloatDeck Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Floating Screen Utility & Guard',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showFloatingNotification ? Icons.notifications_active : Icons.notifications_off,
              color: _showFloatingNotification ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _showFloatingNotification = !_showFloatingNotification;
                if (_showFloatingNotification) {
                  _notificationMessage = "Floating Overlay Reminders Active!";
                }
              });
            },
            tooltip: "Toggle Sticky Banner",
          ),
        ],
      ),
    );
  }

  // TAB 1: Live Interactive Canvas & Overlay Simulator
  Widget _buildCanvasStudioTab(Size screenSize) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Interactive Screen Overlay Canvas", Icons.touch_app, Colors.deepPurple),
          const SizedBox(height: 12),
          const Text(
            "Test and experience how FloatDeck floats over your phone. Drag the purple floating bubble anywhere on screen or tap it to open instant tools!",
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Control Switches Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildToggleChip(
                label: "Privacy Shield",
                icon: Icons.security,
                isActive: _isPrivacyShieldActive,
                activeColor: Colors.amber,
                onTap: () {
                  setState(() {
                    _isPrivacyShieldActive = !_isPrivacyShieldActive;
                  });
                },
              ),
              _buildToggleChip(
                label: "Snap To Edges",
                icon: Icons.border_outer,
                isActive: _snapToEdge,
                activeColor: Colors.teal,
                onTap: () {
                  setState(() {
                    _snapToEdge = !_snapToEdge;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildCardHeader("Floating Overlay Quick Shortcuts", Icons.widgets, Colors.indigo),
          const SizedBox(height: 12),

          // Simulated Phone Screen Preview Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 14,
                      child: Icon(Icons.phone_android, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Simulated App Background (WhatsApp / Web)",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70, height: 24),
                const Text(
                  "Sensitive Account Info Example:\nCard PIN: 4920 | Account Balance: \$14,850.00",
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isPrivacyShieldActive = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Privacy Shield overlay enabled over screen!")),
                    );
                  },
                  icon: const Icon(Icons.visibility_off, size: 18),
                  label: const Text("Mask Sensitive Area Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _buildCardHeader("Floating Deck Action Logs", Icons.history, Colors.blue),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white70),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• Floating Bubble Position: X: ${_bubblePos.dx.toStringAsFixed(0)}, Y: ${_bubblePos.dy.toStringAsFixed(0)}",
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 4),
                Text(
                  "• Shield State: ${_isPrivacyShieldActive ? 'ACTIVE (${(_privacyOpacity * 100).toStringAsFixed(0)}% Opacity)' : 'INACTIVE'}",
                  style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 4),
                Text(
                  "• Saved Stash Entries: ${_textVault.length} items ready for 1-tap paste",
                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Text & Bank Vault (Quick Paste Stash)
  Widget _buildTextVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Quick Paste Text & Bank Stash", Icons.content_paste_go, Colors.teal),
          const SizedBox(height: 8),
          const Text(
            "Store frequent responses, bank accounts, Wi-Fi codes, or addresses. Tap to copy instantly to clipboard or launch from the floating bubble overlay!",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () => _showAddTextDialog(),
            icon: const Icon(Icons.add),
            label: const Text("Add New Stash Item"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _textVault.length,
            itemBuilder: (context, index) {
              final item = _textVault[index];
              return Card(
                color: const Color(0xFF1E1C2E),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] ?? '',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['category'] ?? 'General',
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      item['content'] ?? '',
                      style: const TextStyle(color: Colors.tealAccent, fontFamily: 'monospace', fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.amber, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item['content'] ?? ''));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied '${item['title']}' to clipboard!")),
                          );
                        },
                        tooltip: "Copy Text",
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _textVault.removeAt(index);
                          });
                        },
                        tooltip: "Delete Stash",
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

  // TAB 3: Privacy Mask & Screen Guard Controls
  Widget _buildPrivacyShieldTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Screen Privacy Shield Control", Icons.security, Colors.amber),
          const SizedBox(height: 8),
          const Text(
            "Prevent shoulder-surfing! Create a customizable tint band over sensitive app regions like bank balances, personal chats, or passwords.",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Enable Toggle Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _isPrivacyShieldActive ? Colors.amber : Colors.white70),
            ),
            child: Row(
              children: [
                Icon(
                  _isPrivacyShieldActive ? Icons.visibility_off : Icons.visibility,
                  color: _isPrivacyShieldActive ? Colors.amber : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Privacy Overlay Shield",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _isPrivacyShieldActive ? "Mask actively shielding screen" : "Mask is currently hidden",
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isPrivacyShieldActive,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _isPrivacyShieldActive = val;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Shield Darkness / Opacity Level:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Slider(
            value: _privacyOpacity,
            min: 0.2,
            max: 0.95,
            activeColor: Colors.amber,
            inactiveColor: Colors.white70,
            onChanged: (val) {
              setState(() {
                _privacyOpacity = val;
              });
            },
          ),
          Text(
            "Opacity: ${(_privacyOpacity * 100).toStringAsFixed(0)}%",
            style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),
          const Text(
            "Choose Mask Tint Color:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: [
              _buildColorChoice(Colors.black),
              _buildColorChoice(Colors.indigo),
              _buildColorChoice(Colors.deepPurple),
              _buildColorChoice(Colors.blueGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorChoice(Color col) {
    bool isSelected = _privacyMaskColor == col;
    return GestureDetector(
      onTap: () {
        setState(() {
          _privacyMaskColor = col;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: col,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.white70,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.amber, size: 20) : null,
      ),
    );
  }

  // TAB 4: Floating Quick Math Splitter
  Widget _buildQuickCalcTab() {
    double totalWithTip = _billAmount + (_billAmount * (_tipPercentage / 100));
    double perPerson = totalWithTip / (_splitPeople > 0 ? _splitPeople : 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Floating Overlay Bill & Split Calculator", Icons.calculate, Colors.green),
          const SizedBox(height: 8),
          const Text(
            "Quick overlay math for restaurant bills, taxis, or shared shopping when chatting in groups!",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Total Calculation Display Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.deepPurple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  "COST PER PERSON",
                  style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "\$${perPerson.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Bill: \$${totalWithTip.toStringAsFixed(2)} (Tip: ${_tipPercentage.toStringAsFixed(0)}%)",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            "Bill Amount (\$${_billAmount.toStringAsFixed(0)}):",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Slider(
            value: _billAmount,
            min: 10,
            max: 1000,
            divisions: 99,
            activeColor: Colors.teal,
            inactiveColor: Colors.white70,
            onChanged: (val) {
              setState(() {
                _billAmount = val;
              });
            },
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Split Between People:", style: TextStyle(color: Colors.white, fontSize: 13)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                    onPressed: () {
                      if (_splitPeople > 1) {
                        setState(() {
                          _splitPeople--;
                        });
                      }
                    },
                  ),
                  Text(
                    "$_splitPeople",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                    onPressed: () {
                      setState(() {
                        _splitPeople++;
                      });
                    },
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: "Split Bill Total: \$${totalWithTip.toStringAsFixed(2)} | \$${perPerson.toStringAsFixed(2)} each for $_splitPeople people.",
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Split calculation summary copied to clipboard!")),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text("Copy Calculation Summary"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 5: Floating Deck Customizer & Style Studio
  Widget _buildCustomizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader("Floating Dock Style & Appearance", Icons.tune, Colors.orange),
          const SizedBox(height: 8),
          const Text(
            "Customize how your active floating deck bubble looks on screen. Change bubble size, accent glow, and standard icon.",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),

          // Bubble Size Slider
          Text(
            "Bubble Size (${_bubbleSize.toStringAsFixed(0)} px):",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Slider(
            value: _bubbleSize,
            min: 44,
            max: 80,
            activeColor: Colors.orange,
            inactiveColor: Colors.white70,
            onChanged: (val) {
              setState(() {
                _bubbleSize = val;
              });
            },
          ),

          const SizedBox(height: 16),
          const Text(
            "Select Bubble Icon:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: [
              _buildIconChoice(Icons.widgets),
              _buildIconChoice(Icons.stars),
              _buildIconChoice(Icons.touch_app),
              _buildIconChoice(Icons.bolt),
              _buildIconChoice(Icons.flash_on),
            ],
          ),

          const SizedBox(height: 20),
          const Text(
            "Select Deck Theme Color:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: [
              _buildBubbleColorChoice(Colors.deepPurple),
              _buildBubbleColorChoice(Colors.indigo),
              _buildBubbleColorChoice(Colors.teal),
              _buildBubbleColorChoice(Colors.orange),
              _buildBubbleColorChoice(Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconChoice(IconData iconData) {
    bool isSelected = _bubbleIcon == iconData;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleIcon = iconData;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : const Color(0xFF1E1C2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.amber : Colors.white70),
        ),
        child: Icon(
          iconData,
          color: isSelected ? Colors.black : Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildBubbleColorChoice(Color col) {
    bool isSelected = _bubbleColor == col;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bubbleColor = col;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: col,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
      ),
    );
  }

  // Helper Card Header Builder
  Widget _buildCardHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper Toggle Chip
  Widget _buildToggleChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.2) : const Color(0xFF1E1C2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? activeColor : Colors.white70),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? activeColor : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add Item Dialog
  void _showAddTextDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1C2E),
          title: const Text("New Stash Snippet", style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Title (e.g. Bank Account)",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Text Content / Number",
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  setState(() {
                    _textVault.add({
                      'title': titleController.text,
                      'category': category,
                      'content': contentController.text,
                    });
                  });
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Save Item", style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  // Handle Floating Overlay Radial Menu Actions
  void _handleFloatingAction(String action) {
    setState(() {
      _isBubbleExpanded = false;
    });

    switch (action) {
      case 'shield':
        setState(() {
          _isPrivacyShieldActive = !_isPrivacyShieldActive;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Privacy Shield Toggled ${_isPrivacyShieldActive ? 'ON' : 'OFF'}")),
        );
        break;

      case 'vault':
        if (_textVault.isNotEmpty) {
          final firstItem = _textVault.first;
          Clipboard.setData(ClipboardData(text: firstItem['content'] ?? ''));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Quick Copied: ${firstItem['title']}")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Stash empty! Add items in Text Vault tab.")),
          );
        }
        break;

      case 'calc':
        setState(() {
          _currentTab = 3;
        });
        break;

      case 'notify':
        setState(() {
          _showFloatingNotification = true;
          _notificationMessage = "Sticky Quick Note pinned over screen!";
        });
        break;
    }
  }
}

// Custom Draggable Floating Action Bubble Widget
class GestureDetectingFloatingBubble extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;
  final bool isExpanded;
  final Function(DragUpdateDetails) onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onTap;
  final Function(String) onQuickAction;

  const GestureDetectingFloatingBubble({
    super.key,
    required this.size,
    required this.color,
    required this.icon,
    required this.isExpanded,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    required this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Radial / Pop-out Action Deck
        if (isExpanded)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1C2E).withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12,
                )
              ],
            ),
            child: Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                _buildRadialIconButton(Icons.security, Colors.amber, () => onQuickAction('shield'), "Shield"),
                _buildRadialIconButton(Icons.content_paste, Colors.teal, () => onQuickAction('vault'), "Paste"),
                _buildRadialIconButton(Icons.calculate, Colors.green, () => onQuickAction('calc'), "Math"),
                _buildRadialIconButton(Icons.push_pin, Colors.purpleAccent, () => onQuickAction('notify'), "Pin"),
              ],
            ),
          ),

        // Main Bubble Action Touch Target
        GestureDetector(
          onPanUpdate: onDragUpdate,
          onPanEnd: (_) => onDragEnd(),
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 14,
                  spreadRadius: 2,
                )
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              isExpanded ? Icons.close : icon,
              color: Colors.white,
              size: size * 0.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadialIconButton(IconData icon, Color bg, VoidCallback onPressed, String tooltip) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: CircleAvatar(
          backgroundColor: bg,
          radius: 18,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}