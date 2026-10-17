import 'package:flutter/material.dart';

void main() {
  runApp(const FloatDeckApp());
}

class FloatDeckApp extends StatelessWidget {
  const FloatDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFAFAFAF) == Colors.grey ? Colors.grey : Colors.white,
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
  bool _overlayPermission = true;
  bool _notificationBannerEnabled = true;
  bool _dockVisible = true;
  String _activeToolTag = 'Quick Clip';
  double _dockOpacity = 0.90;

  // Price overlay calculator state
  final TextEditingController _priceController = TextEditingController(text: '49.99');
  final TextEditingController _discountController = TextEditingController(text: '15');
  final TextEditingController _taxController = TextEditingController(text: '8');
  double _finalCalculatedPrice = 45.89;

  // Clip vault state
  final List<Map<String, dynamic>> _clips = [
    {
      'id': '1',
      'title': 'Main Bank Account Details',
      'content': 'Account: 9876-5432-1098 | Bank: Chase | Swift: CHASEUS33',
      'tag': 'Finance',
      'isPinned': true,
    },
    {
      'id': '2',
      'title': 'Home Delivery Address',
      'content': '742 Evergreen Terrace, Springfield, OR 97477 (Gate code: #4092)',
      'tag': 'Address',
      'isPinned': true,
    },
    {
      'id': '3',
      'title': 'E-Commerce Inquiry Template',
      'content': 'Hello! Is this item still available for immediate shipping to my address?',
      'tag': 'Chat',
      'isPinned': false,
    },
    {
      'id': '4',
      'title': 'Instant 2FA Code Snippet',
      'content': 'OTP Code: 739201 (Expires in 3 mins)',
      'tag': 'Code',
      'isPinned': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _recalculatePrice();
  }

  void _recalculatePrice() {
    final double base = double.tryParse(_priceController.text) ?? 0.0;
    final double discount = double.tryParse(_discountController.text) ?? 0.0;
    final double tax = double.tryParse(_taxController.text) ?? 0.0;

    final double discounted = base * (1.0 - (discount / 100.0));
    final double total = discounted * (1.0 + (tax / 100.0));

    setState(() {
      _finalCalculatedPrice = total < 0 ? 0.0 : total;
    });
  }

  void _togglePin(String id) {
    setState(() {
      final index = _clips.indexWhere((element) => element['id'] == id);
      if (index != -1) {
        _clips[index]['isPinned'] = !(_clips[index]['isPinned'] as bool);
      }
    });
  }

  void _deleteClip(String id) {
    setState(() {
      _clips.removeWhere((element) => element['id'] == id);
    });
  }

  void _addNewClip(String title, String content, String tag) {
    setState(() {
      _clips.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title.isEmpty ? 'Quick Note' : title,
        'content': content,
        'tag': tag,
        'isPinned': true,
      });
    });
  }

  void _showAddClipDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedTag = 'Finance';

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Context Clip', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Label (e.g., Bank Details)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Content to Quick-Paste',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Category: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: selectedTag,
                          items: <String>['Finance', 'Address', 'Chat', 'Code', 'General']
                              .map((String val) => DropdownMenuItem(value: val, child: Text(val)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedTag = val;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (contentController.text.trim().isNotEmpty) {
                      _addNewClip(
                        titleController.text.trim(),
                        contentController.text.trim(),
                        selectedTag,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Clip added & pinned to Floating Dock!')),
                      );
                    }
                  },
                  child: const Text('Save & Pin'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDockHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'FloatDeck Control',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Persistent Screen Micro-Assistant',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Switch(
                value: _dockVisible,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _dockVisible = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              Chip(
                avatar: Icon(
                  _overlayPermission ? Icons.check_circle : Icons.warning,
                  color: _overlayPermission ? Colors.green : Colors.deepOrange,
                  size: 18,
                ),
                label: Text(_overlayPermission ? 'Overlay Active' : 'Overlay Disabled'),
                backgroundColor: Colors.white,
              ),
              Chip(
                avatar: const Icon(Icons.notifications_active, color: Colors.blue, size: 18),
                label: Text(_notificationBannerEnabled ? 'Banners On' : 'Banners Off'),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabFloatingControl() {
    final pinnedCount = _clips.where((e) => e['isPinned'] == true).length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDockHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Permissions Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.layers, color: Colors.indigo),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Display Above Other Apps',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Allows FloatDeck bubble to float over WhatsApp, Amazon, Chrome, and Banking apps for instant 1-tap pasting and price math.',
                            style: TextStyle(color: Colors.black87, fontSize: 13),
                            softWrap: true,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Overlay Permission Status:', style: TextStyle(fontWeight: FontWeight.w500)),
                              Switch(
                                value: _overlayPermission,
                                onChanged: (val) {
                                  setState(() {
                                    _overlayPermission = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Floating Notification Bar:', style: TextStyle(fontWeight: FontWeight.w500)),
                              Switch(
                                value: _notificationBannerEnabled,
                                onChanged: (val) {
                                  setState(() {
                                    _notificationBannerEnabled = val;
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

                  // Interactive Dock Live Preview Box
                  const Text(
                    'Live Screen Overlay Simulator',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigo, width: 2),
                    ),
                    child: Stack(
                      children: [
                        // Background Phone Screen Content Mockup
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 140,
                                  height: 12,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  height: 8,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 200,
                                  height: 8,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Simulated Chat / Web Shop Screen\nItem Price: \$49.99',
                                    style: TextStyle(color: Colors.black87, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Animated Floating Bubble Mockup
                        if (_dockVisible)
                          Positioned(
                            top: 40,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(_dockOpacity),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black87,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bolt, color: Colors.amber, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$pinnedCount Clips Ready',
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

                        // Notification Heads Up Preview Banner
                        if (_notificationBannerEnabled)
                          Positioned(
                            top: 8,
                            left: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.content_paste, color: Colors.teal, size: 16),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'FloatDeck Active: Tap bubble anytime to auto-inject copied text',
                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transparency & Dock Customizer Controls
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Floating Overlay Transparency',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.visibility_off, size: 18, color: Colors.grey),
                              Expanded(
                                child: Slider(
                                  value: _dockOpacity,
                                  min: 0.4,
                                  max: 1.0,
                                  divisions: 6,
                                  label: '${(_dockOpacity * 100).round()}%',
                                  onChanged: (val) {
                                    setState(() {
                                      _dockOpacity = val;
                                    });
                                  },
                                ),
                              ),
                              const Icon(Icons.visibility, size: 18, color: Colors.indigo),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildTabClipVault() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Context Clip Vault',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '1-Tap floating access across all apps',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddClipDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Clip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Clip items list
              if (_clips.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: const [
                        Icon(Icons.content_paste_off, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No context clips saved yet.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _clips.length,
                  itemBuilder: (context, index) {
                    final item = _clips[index];
                    final bool isPinned = item['isPinned'] as bool;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isPinned ? Colors.indigo : Colors.transparent,
                          width: 1.5,
                        ),
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
                                Chip(
                                  label: Text(
                                    item['tag'].toString(),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.indigo.withOpacity(0.1),
                                  padding: EdgeInsets.zero,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isPinned ? Icons.star : Icons.star_border,
                                        color: isPinned ? Colors.amber : Colors.grey,
                                      ),
                                      onPressed: () => _togglePin(item['id'].toString()),
                                      tooltip: 'Pin to Floating Dock',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.grey),
                                      onPressed: () => _deleteClip(item['id'].toString()),
                                      tooltip: 'Delete Clip',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              item['title'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['content'].toString(),
                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                                softWrap: true,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied "${item['title']}" to clipboard!'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.content_copy, size: 16),
                                label: const Text('Quick Copy'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabScreenTools() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Screen Micro-Tools Overlay',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Calculators & generators that work without switching context',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Tool 1: Instant Shopping Price & Tax Splitter
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.shopping_cart, color: Colors.teal),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Instant Price & Tax Net Splitter',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price (\$)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => _recalculatePrice(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Discount (%)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => _recalculatePrice(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _taxController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Tax (%)',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (_) => _recalculatePrice(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.teal),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Final Net Total:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '\$${_finalCalculatedPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tool 2: Chat Quick Reply Snippets Generator
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.chat, color: Colors.indigo),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'E-Commerce & Chat Auto-Replies',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.monetization_on, size: 16),
                            label: const Text('Payment Sent Confirmation'),
                            onPressed: () {
                              _addNewClip(
                                'Payment Confirmation',
                                'Hi! I have just transferred the payment. Please confirm receipt and share tracking details. Thanks!',
                                'Finance',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added Payment Reply to Clip Vault!')),
                              );
                            },
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.local_shipping, size: 16),
                            label: const Text('Address Delivery Query'),
                            onPressed: () {
                              _addNewClip(
                                'Delivery Inquiry',
                                'Hello! What is the estimated delivery time frame for my address?',
                                'Address',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added Delivery Reply to Clip Vault!')),
                              );
                            },
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.local_offer, size: 16),
                            label: const Text('Discount Offer Request'),
                            onPressed: () {
                              _addNewClip(
                                'Discount Negotiation',
                                'Hi! Is there any ongoing promotional discount or bundle offer available for this order?',
                                'General',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added Discount Query to Clip Vault!')),
                              );
                            },
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
      ),
    );
  }

  Widget _buildTabAnalytics() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Productivity & Time Saved',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Real-time engagement stats while using FloatDeck',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Analytics Summary Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard('App Switches Avoided', '348', Icons.swap_horiz, Colors.blue),
                  _buildStatCard('Time Saved Today', '42 mins', Icons.schedule, Colors.green),
                  _buildStatCard('Active Overlay Snippets', '${_clips.length}', Icons.content_paste, Colors.purple),
                  _buildStatCard('Efficiency Rating', '98.4%', Icons.speed, Colors.amber),
                ],
              ),
              const SizedBox(height: 16),

              // Daily Usage Encouragement Banner
              Card(
                color: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.stars, color: Colors.amber, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Daily Power User Status',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Keep FloatDeck overlay enabled during online shopping, messaging, and multi-app tasks to continuously save time and prevent app-switching context loss.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildTabFloatingControl(),
      _buildTabClipVault(),
      _buildTabScreenTools(),
      _buildTabAnalytics(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Floating Deck',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_paste),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            label: 'Overlay Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}