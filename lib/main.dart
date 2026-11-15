import 'package:flutter/material.dart';

void main() {
  runApp(const StealthBubbleApp());
}

class StealthBubbleApp extends StatelessWidget {
  const StealthBubbleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext meContext) {
    return MaterialApp(
      title: 'StealthBubble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.indigoAccent,
          surface: Color(0xFF1A1D2C),
          background: Color(0xFF0F111A),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1D2C),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class NotificationModel {
  final String id;
  final String appName;
  final String sender;
  final String message;
  final String time;
  final Color appColor;
  final IconData icon;
  final bool isDeletedBySender;
  bool isStarred;

  NotificationModel({
    required this.id,
    required this.appName,
    required this.sender,
    required this.message,
    required this.time,
    required this.appColor,
    required this.icon,
    this.isDeletedBySender = false,
    this.isStarred = false,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Global App States
  bool _isOverlayEnabled = true;
  bool _isNotificationAccessGranted = true;
  bool _isFloatingBubbleActive = true;
  double _curtainOpacity = 0.85;
  double _curtainHeight = 160.0;
  Color _curtainColor = Colors.black;
  String _activeDecoyMode = 'Normal Tint';
  
  // Floating Bubble Screen Position State
  Offset _bubblePosition = const Offset(20, 180);

  // Quick Stealth Notes
  final List<String> _stealthNotes = [
    "Secret ATM PIN note: 9482 (simulated)",
    "Gift idea link: https://example.com/watch",
  ];
  final TextEditingController _noteController = TextEditingController();

  // Notification Inbox Data
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      appName: 'WhatsApp',
      sender: 'Sarah Jenkins',
      message: 'Are you coming to the party tonight? Don\'t mention this to Mark yet!',
      time: '10:42 AM',
      appColor: Colors.green,
      icon: Icons.chat_bubble_outline,
      isStarred: true,
    ),
    NotificationModel(
      id: '2',
      appName: 'Telegram',
      sender: 'Alex Developer',
      message: 'Deleted Message Detected: "The secret server key is root_admin_2025"',
      time: '10:15 AM',
      appColor: Colors.blue,
      icon: Icons.security,
      isDeletedBySender: true,
    ),
    NotificationModel(
      id: '3',
      appName: 'Bank Direct',
      sender: 'Alert Services',
      message: 'Account credited with \$450.00. Ref: Wire Transfer #88219.',
      time: '09:05 AM',
      appColor: Colors.amber,
      icon: Icons.monetization_on,
    ),
    NotificationModel(
      id: '4',
      appName: 'Instagram',
      sender: 'Elena_V',
      message: 'Sent you a private direct photo message.',
      time: 'Yesterday',
      appColor: Colors.purple,
      icon: Icons.star,
    ),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'All';

  void _addSimulatedNotification() {
    setState(() {
      _notifications.insert(
        0,
        NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          appName: 'WhatsApp',
          sender: 'Boss / Manager',
          message: 'Can you review the secret budget report right now? It is urgent!',
          time: 'Just Now',
          appColor: Colors.green,
          icon: Icons.mark_chat_unread,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ Stealth Alert Captured! Read without blue ticks.'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addStealthNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _stealthNotes.insert(0, _noteController.text.trim());
        _noteController.clear();
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildVaultTab(),
                _buildCurtainStudioTab(),
                _buildFloatingSandboxTab(),
                _buildAuditSettingsTab(),
              ],
            ),
            // Floating Stealth Bubble Overlay Simulation inside App
            if (_isFloatingBubbleActive) _buildDraggableFloatingBubble(),
            // Floating Anti-Peeking Curtain Overlay Simulation
            if (_isOverlayEnabled && _activeDecoyMode != 'Hidden') _buildLiveCurtainOverlay(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF141622),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mark_chat_unread),
            label: 'Stealth Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Privacy Curtain',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Audit & Setup',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: STEALTH INBOX (Notification Vault) ---
  Widget _buildVaultTab() {
    final filteredList = _notifications.where((item) {
      final matchesSearch = item.sender.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.message.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.appName.toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedFilter == 'Starred') return matchesSearch && item.isStarred;
      if (_selectedFilter == 'Deleted') return matchesSearch && item.isDeletedBySender;
      return matchesSearch;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                      'Stealth Inbox',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Read notifications secretly without sending receipts',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _addSimulatedNotification,
                icon: const Icon(Icons.add_alert, color: Colors.tealAccent),
                tooltip: 'Simulate Incoming Message',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search box
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search private messages, senders...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1A1D2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          // Quick Filter Chips
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAxisAlignment.center,
            children: [
              _buildFilterChip('All'),
              _buildFilterChip('Starred'),
              _buildFilterChip('Deleted'),
            ],
          ),
          const SizedBox(height: 16),
          if (filteredList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: const [
                    Icon(Icons.mark_email_read, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No stealth notifications found.',
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
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: item.appColor.withOpacity(0.2),
                      child: Icon(item.icon, color: item.appColor),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.sender,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          item.time,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.message,
                          style: TextStyle(
                            color: item.isDeletedBySender ? Colors.redAccent : Colors.white70,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: item.appColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.appName,
                                style: TextStyle(fontSize: 10, color: item.appColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (item.isDeletedBySender) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'SAVED DELETED MSG',
                                  style: TextStyle(fontSize: 9, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        item.isStarred ? Icons.star : Icons.star_border,
                        color: item.isStarred ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          item.isStarred = !item.isStarred;
                        });
                      },
                    ),
                    onTap: () => _showNotificationDetailModal(item),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.tealAccent.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Colors.tealAccent : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: const Color(0xFF1A1D2C),
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = label);
      },
    );
  }

  void _showNotificationDetailModal(NotificationModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: item.appColor.withOpacity(0.2),
                        child: Icon(item.icon, color: item.appColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.sender,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Via ${item.appName} • ${item.time}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white70),
                  const Text(
                    'Stealth Vault Message View:',
                    style: TextStyle(fontSize: 12, color: Colors.tealAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.message,
                    style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied text to secret clipboard!')),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy Text'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Close Privately'),
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

  // --- TAB 2: ANTI-PEEKING CURTAIN STUDIO ---
  Widget _buildCurtainStudioTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anti-Peeking Screen Shield',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Block nosy onlookers in buses or public areas from reading your screen',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Activate Privacy Curtain Overlay', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Displays customizable privacy filter over your screen'),
                    value: _isOverlayEnabled,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _isOverlayEnabled = val),
                  ),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Curtain Opacity:'),
                      Text('${(_curtainOpacity * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    ],
                  ),
                  Slider(
                    value: _curtainOpacity,
                    min: 0.2,
                    max: 0.98,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _curtainOpacity = val),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Curtain Mask Height:'),
                      Text('${_curtainHeight.toInt()} px', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    ],
                  ),
                  Slider(
                    value: _curtainHeight,
                    min: 60.0,
                    max: 350.0,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) => setState(() => _curtainHeight = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Decoy Cover Mode:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildDecoyButton('Normal Tint', Icons.color_lens, Colors.black),
              _buildDecoyButton('Fake Low Battery', Icons.battery_alert, Colors.red),
              _buildDecoyButton('Fake Update', Icons.system_update_tv, Colors.indigo),
              _buildDecoyButton('Hidden', Icons.visibility_off, Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF141622),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb, color: Colors.amber),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tip: You can drag the floating curtain handle on the screen to reposition the privacy shield over sensitive chat areas!',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
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

  Widget _buildDecoyButton(String modeName, IconData icon, Color color) {
    final isSelected = _activeDecoyMode == modeName;
    return InkWell(
      onTap: () => setState(() => _activeDecoyMode = modeName),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : const Color(0xFF1A1D2C),
          border: Border.all(
            color: isSelected ? Colors.tealAccent : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.tealAccent : Colors.grey),
            const SizedBox(width: 8),
            Text(
              modeName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: FLOATING ASSISTANT SANDBOX ---
  Widget _buildFloatingSandboxTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Floating Assistant & Secret Notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Keep secret notes & quick privacy utilities floating over any application',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 20),
          Card(
            child: SwitchListTile(
              title: const Text('Show Draggable Stealth Bubble', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Interactive floating launcher bubble on your screen'),
              value: _isFloatingBubbleActive,
              activeColor: Colors.tealAccent,
              onChanged: (val) => setState(() => _isFloatingBubbleActive = val),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Stealth Quick Notes Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: _showAddNoteDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Note'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _stealthNotes.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.lock, color: Colors.tealAccent),
                  title: Text(
                    _stealthNotes[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _stealthNotes.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1D2C),
          title: const Text('Add Private Stealth Note'),
          content: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Type sensitive info, codes, passwords...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _addStealthNote,
              child: const Text('Save Note', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- TAB 4: AUDIT & SETTINGS ---
  Widget _buildAuditSettingsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Audit & Status',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'System permissions and security status breakdown',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 20),
          // Security Gauge Card
          Card(
            color: const Color(0xFF141622),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.tealAccent, width: 4),
                    ),
                    child: const Center(
                      child: Text(
                        '98%',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Privacy Score: Excellent',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Anti-Peeking active. Read-receipt bypass fully operational.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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
          const Text('System Permissions Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notification Listener Permission'),
                  subtitle: const Text('Allows capturing incoming chats without triggering blue ticks'),
                  value: _isNotificationAccessGranted,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _isNotificationAccessGranted = val),
                ),
                const Divider(color: Colors.white70, height: 1),
                SwitchListTile(
                  title: const Text('Display Over Other Apps'),
                  subtitle: const Text('Required for screen privacy curtain and floating assistant bubble'),
                  value: _isOverlayEnabled,
                  activeColor: Colors.tealAccent,
                  onChanged: (val) => setState(() => _isOverlayEnabled = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Daily Anti-Peeking Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('42', 'Captured Msgs', Colors.blue),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard('3', 'Deleted Msgs', Colors.redAccent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard('4.5 h', 'Shield Active', Colors.tealAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String title, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  // --- FLOATING SIMULATED COMPONENTS ---
  Widget _buildDraggableFloatingBubble() {
    return Positioned(
      left: _bubblePosition.dx,
      top: _bubblePosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _bubblePosition += details.delta;
          });
        },
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚡ Stealth Floating Assistant: Quick Privacy Shield Toggled!'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal,
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.shield, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildLiveCurtainOverlay() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          height: _curtainHeight,
          color: _curtainColor.withOpacity(_curtainOpacity),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_activeDecoyMode == 'Fake Low Battery') ...[
                const Icon(Icons.battery_alert, color: Colors.redAccent, size: 36),
                const SizedBox(height: 4),
                const Text(
                  'Battery Critical: 1% Remaining',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ] else if (_activeDecoyMode == 'Fake Update') ...[
                const CircularProgressIndicator(color: Colors.indigoAccent),
                const SizedBox(height: 8),
                const Text(
                  'System Installing Update (48%)... Do Not Turn Off',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.visibility_off, color: Colors.tealAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ANTI-PEEKING SCREEN MASK ACTIVE',
                      style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}