import 'package:flutter/material.dart';

void main() {
  runApp(const FloatMateApp());
}

class FloatMateApp extends StatelessWidget {
  const FloatMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const FloatMateHomeScreen(),
    );
  }
}

class QuickSnippet {
  final String id;
  final String title;
  final String text;

  QuickSnippet({required this.id, required this.title, required this.text});
}

class FloatMateHomeScreen extends StatefulWidget {
  const FloatMateHomeScreen({Key? key}) : super(key: key);

  @override
  State<FloatMateHomeScreen> createState() => _FloatMateHomeScreenState();
}

class _FloatMateHomeScreenState extends State<FloatMateHomeScreen> {
  // Service & Permission States
  bool isOverlayActive = true;
  bool hasNotificationPermission = true;
  bool hasDisplayOverAppsPermission = true;

  // Floating Bubble Position
  double bubbleX = 20.0;
  double bubbleY = 220.0;
  bool isBubbleMenuOpen = false;

  // Peek Shield (Privacy Overlay) States
  bool isPeekShieldEnabled = false;
  double peekShieldOpacity = 0.85;
  double peekShieldHeight = 120.0;
  double peekShieldY = 150.0;

  // Selected Dashboard Tab
  int activeTab = 0;

  // Quick Snippets Data
  final List<QuickSnippet> snippets = [
    QuickSnippet(
      id: '1',
      title: 'Bank Details',
      text: 'Commercial Bank | Acc: 8001234567 | Branch: Colombo',
    ),
    QuickSnippet(
      id: '2',
      title: 'Home Address',
      text: 'No 45/2, Temple Road, Nugegoda, Sri Lanka',
    ),
    QuickSnippet(
      id: '3',
      title: 'Quick Reply - Driving',
      text: 'I am currently driving. Will call you back in 15 mins!',
    ),
    QuickSnippet(
      id: '4',
      title: 'Tax / Reg ID',
      text: 'NIC: 199512345678 | Tax ID: 902143-A',
    ),
  ];

  // Micro Splitter State
  final TextEditingController _billAmountController = TextEditingController(text: '4500');
  final TextEditingController _peopleController = TextEditingController(text: '3');
  double splitPerPerson = 1500.00;

  // Discount Lens State
  final TextEditingController _priceController = TextEditingController(text: '12500');
  final TextEditingController _discountController = TextEditingController(text: '20');
  double finalPrice = 10000.00;
  double savedAmount = 2500.00;

  // Floating Quick Note
  final TextEditingController _floatingNoteController =
      TextEditingController(text: 'Buy milk & groceries on way home!');
  bool isNotePinned = true;

  @override
  void initState() {
    super.initState();
    _calculateSplit();
    _calculateDiscount();
  }

  void _calculateSplit() {
    final double bill = double.tryParse(_billAmountController.text) ?? 0;
    final int people = int.tryParse(_peopleController.text) ?? 1;
    setState(() {
      splitPerPerson = people > 0 ? (bill / people) : bill;
    });
  }

  void _calculateDiscount() {
    final double price = double.tryParse(_priceController.text) ?? 0;
    final double discount = double.tryParse(_discountController.text) ?? 0;
    setState(() {
      savedAmount = (price * discount) / 100;
      finalPrice = price - savedAmount;
    });
  }

  void _copyToClipboard(String content, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$title" to clipboard!'),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNewSnippetDialog() {
    final titleCtrl = TextEditingController();
    final textCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Quick Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Label (e.g. Work Email)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Text Content to Copy',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && textCtrl.text.isNotEmpty) {
                setState(() {
                  snippets.add(
                    QuickSnippet(
                      id: DateTime.now().toString(),
                      title: titleCtrl.text,
                      text: textCtrl.text,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Snippet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.widgets, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'FloatMate Overlay Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isOverlayActive ? Icons.notifications_active : Icons.notifications_off,
              color: isOverlayActive ? Colors.amber : Colors.white70,
            ),
            onPressed: () {
              setState(() {
                isOverlayActive = !isOverlayActive;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isOverlayActive ? 'Overlay Service Activated!' : 'Overlay Service Paused.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main App Scrollable Content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Permissions & Active Status Banner
                  _buildStatusBanner(),
                  const SizedBox(height: 16),

                  // Navigation Tabs
                  _buildTabSelector(),
                  const SizedBox(height: 16),

                  // Tab Views
                  if (activeTab == 0) _buildPrivacyShieldTab(),
                  if (activeTab == 1) _buildQuickSnippetsTab(),
                  if (activeTab == 2) _buildMicroSplitterTab(),
                  if (activeTab == 3) _buildDiscountLensTab(),

                  const SizedBox(height: 24),
                  _buildOverlayControlsCard(),
                  const SizedBox(height: 80), // Space for floating button
                ],
              ),
            ),

            // Public Transport Privacy Shield Overlay Simulator
            if (isPeekShieldEnabled)
              Positioned(
                top: peekShieldY,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      peekShieldY = (peekShieldY + details.delta.dy)
                          .clamp(50.0, screenSize.height - 180.0);
                    });
                  },
                  child: Container(
                    height: peekShieldHeight,
                    color: Colors.black.withOpacity(peekShieldOpacity),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.security, color: Colors.amber, size: 20),
                              const SizedBox(height: 4),
                              Text(
                                'PEEK SHIELD ACTIVE (Drag Up/Down)',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isPeekShieldEnabled = false;
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Draggable Floating Bubble Simulator
            if (isOverlayActive)
              Positioned(
                left: bubbleX,
                top: bubbleY,
                child: Draggable(
                  feedback: _buildFloatingBubbleWidget(isDragging: true),
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      // Keep inside screens bounds
                      bubbleX = details.offset.dx.clamp(10.0, screenSize.width - 70.0);
                      bubbleY = details.offset.dy.clamp(60.0, screenSize.height - 120.0);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBubbleMenuOpen = !isBubbleMenuOpen;
                          });
                        },
                        child: _buildFloatingBubbleWidget(isDragging: false),
                      ),
                      if (isBubbleMenuOpen) _buildFloatingQuickMenu(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isOverlayActive ? Colors.indigo.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverlayActive ? Colors.indigo.shade200 : Colors.orange.shade300,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isOverlayActive ? Icons.check_circle : Icons.info,
                color: isOverlayActive ? Colors.indigo : Colors.orange.shade800,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isOverlayActive
                      ? 'FloatMate Service Active - Floating Bubble Running'
                      : 'FloatMate Service Paused - Tap toggle to re-enable',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOverlayActive ? Colors.indigo.shade900 : Colors.orange.shade900,
                    fontSize: 13,
                  ),
                  softWrap: true,
                ),
              ),
              Switch(
                value: isOverlayActive,
                activeColor: Colors.indigo,
                onChanged: (val) {
                  setState(() {
                    isOverlayActive = val;
                  });
                },
              ),
            ],
          ),
          const Divider(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildPermissionChip(
                'Display over apps',
                hasDisplayOverAppsPermission,
                () {
                  setState(() {
                    hasDisplayOverAppsPermission = !hasDisplayOverAppsPermission;
                  });
                },
              ),
              _buildPermissionChip(
                'Floating Alert Notifications',
                hasNotificationPermission,
                () {
                  setState(() {
                    hasNotificationPermission = !hasNotificationPermission;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChip(String label, bool isGranted, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isGranted ? Colors.green.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGranted ? Icons.check : Icons.close,
              size: 14,
              color: isGranted ? Colors.green.shade900 : Colors.black87,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isGranted ? Colors.green.shade900 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    final tabs = [
      {'title': 'Peek Guard', 'icon': Icons.security},
      {'title': 'Snippets', 'icon': Icons.content_copy},
      {'title': 'Bill Split', 'icon': Icons.calculate},
      {'title': 'Discount %', 'icon': Icons.monetization_on},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = activeTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              selected: isSelected,
              showCheckmark: false,
              avatar: Icon(
                tabs[index]['icon'] as IconData,
                size: 16,
                color: isSelected ? Colors.white : Colors.indigo,
              ),
              label: Text(
                tabs[index]['title'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.indigo.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              selectedColor: Colors.indigo,
              backgroundColor: Colors.white,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    activeTab = index;
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // TAB 1: Peek Shield (Public Transport Privacy Mask)
  Widget _buildPrivacyShieldTab() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security, color: Colors.indigo),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Public Transport Peek Shield',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                ),
                Switch(
                  value: isPeekShieldEnabled,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      isPeekShieldEnabled = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Blocks stranger onlookers on crowded buses, trains, or queues from reading your sensitive text chats or banking details.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Divider(height: 24),
            Text(
              'Mask Opacity: ${(peekShieldOpacity * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Slider(
              value: peekShieldOpacity,
              min: 0.3,
              max: 0.98,
              activeColor: Colors.indigo,
              onChanged: (val) {
                setState(() {
                  peekShieldOpacity = val;
                });
              },
            ),
            Text(
              'Mask Height: ${peekShieldHeight.round()}px',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Slider(
              value: peekShieldHeight,
              min: 60.0,
              max: 300.0,
              activeColor: Colors.indigo,
              onChanged: (val) {
                setState(() {
                  peekShieldHeight = val;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPeekShieldEnabled ? Colors.red.shade700 : Colors.indigo,
                minimumSize: const Size(double.infinity, 42),
              ),
              onPressed: () {
                setState(() {
                  isPeekShieldEnabled = !isPeekShieldEnabled;
                });
              },
              icon: Icon(
                isPeekShieldEnabled ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              label: Text(
                isPeekShieldEnabled ? 'Hide Privacy Shield Overlay' : 'Activate Privacy Mask Shield',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Quick Snippets (1-Tap Copy Helper)
  Widget _buildQuickSnippetsTab() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Instant Copy Snippets',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: _addNewSnippetDialog,
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text('Add Snippet', style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snippets.length,
          itemBuilder: (context, index) {
            final item = snippets[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 1,
              child: ListTile(
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text(
                  item.text,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.content_copy, color: Colors.indigo),
                  onPressed: () => _copyToClipboard(item.text, item.title),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // TAB 3: Instant Bill / Meal Splitter Overlay
  Widget _buildMicroSplitterTab() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calculate, color: Colors.indigo),
                SizedBox(width: 8),
                Text('Instant Bill Splitter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Quickly split restaurant or taxi bills on the fly.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _billAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Bill (\$)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateSplit(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _peopleController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'People Count',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateSplit(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Each Person Pays:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  FittedBox(
                    child: Text(
                      '\$${splitPerPerson.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 40),
              ),
              onPressed: () => _copyToClipboard(
                'Each person owes \$${splitPerPerson.toStringAsFixed(2)} for the bill.',
                'Bill Split Result',
              ),
              icon: const Icon(Icons.share, color: Colors.white, size: 16),
              label: const Text('Copy Split Message', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 4: In-App Shopping Discount Lens
  Widget _buildDiscountLensTab() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.indigo),
                SizedBox(width: 8),
                Text('In-App Shopping Discount Lens', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Calculate real prices instantly when browsing online shopping apps.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Original Price (\$)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateDiscount(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discount %',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateDiscount(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text('Final Price:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        FittedBox(
                          child: Text(
                            '\$${finalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text('You Save:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        FittedBox(
                          child: Text(
                            '\$${savedAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Floating Quick Note Card Settings
  Widget _buildOverlayControlsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.edit_note, color: Colors.indigo),
                SizedBox(width: 8),
                Text('Persistent Floating Note', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _floatingNoteController,
              decoration: const InputDecoration(
                labelText: 'Screen Memo Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pin Memo on Floating Head', style: TextStyle(fontWeight: FontWeight.w500)),
                Switch(
                  value: isNotePinned,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      isNotePinned = val;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Floating Bubble View Controller Component
  Widget _buildFloatingBubbleWidget({required bool isDragging}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDragging ? Colors.indigo.shade800 : Colors.indigo,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.bolt, color: Colors.amber, size: 28),
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Colors.greenAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Floating Popup Widget Matrix on Screen
  Widget _buildFloatingQuickMenu() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
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
                  'FloatMate Tools',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.indigo),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isBubbleMenuOpen = false;
                    });
                  },
                  child: const Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 12),
            if (isNotePinned && _floatingNoteController.text.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Text(
                  '📌 ${_floatingNoteController.text}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
            ],
            _buildQuickMenuItem(
              icon: Icons.visibility_off,
              label: isPeekShieldEnabled ? 'Hide Peek Shield' : 'Toggle Peek Shield',
              onTap: () {
                setState(() {
                  isPeekShieldEnabled = !isPeekShieldEnabled;
                  isBubbleMenuOpen = false;
                });
              },
            ),
            _buildQuickMenuItem(
              icon: Icons.content_copy,
              label: 'Copy Bank Info',
              onTap: () {
                if (snippets.isNotEmpty) {
                  _copyToClipboard(snippets[0].text, snippets[0].title);
                }
                setState(() {
                  isBubbleMenuOpen = false;
                });
              },
            ),
            _buildQuickMenuItem(
              icon: Icons.calculate,
              label: 'Quick Split (\$${splitPerPerson.toStringAsFixed(0)})',
              onTap: () {
                _copyToClipboard(
                  'Each person owes \$${splitPerPerson.toStringAsFixed(2)}',
                  'Split Memo',
                );
                setState(() {
                  isBubbleMenuOpen = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.indigo),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}