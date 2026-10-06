import 'package:flutter/material.dart';

void main() {
  runApp(const FloatMateApp());
}

class FloatMateApp extends StatelessWidget {
  const FloatMateApp({super.key});

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
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: const Color(0xFPF6F8FC),
        ),
        cardTheme: CardTheme(
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

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  bool _overlayEnabled = true;
  bool _floatingBubbleActive = true;
  bool _autoCaptureClipboard = true;

  // Clipboard Vault State
  final List<String> _clipboardStack = [
    'Meeting ID: 849-201-9923 (Passcode: 4091)',
    'Shipment Address: 742 Evergreen Terrace, Sector 4',
    'Quote: "Simplicity is the soul of efficiency."',
    'Customer Inquiry: Is this item still available for delivery?',
  ];
  final TextEditingController _clipInputController = TextEditingController();

  // Reply Studio State
  final TextEditingController _replyInputController = TextEditingController();
  String _selectedTone = 'Friendly';
  String _generatedReply = '';

  // Decision Matrix State
  final TextEditingController _decisionInputController = TextEditingController();
  final List<String> _decisionOptions = ['Send Message Now', 'Wait 10 Mins', 'Ask Colleague First'];
  String _selectedDecision = '';

  // Quick Tools Splitter State
  final TextEditingController _billAmountController = TextEditingController(text: '45.00');
  int _splitPeople = 2;
  double _tipPercentage = 15.0;

  @override
  void dispose() {
    _clipInputController.dispose();
    _replyInputController.dispose();
    _decisionInputController.dispose();
    _billAmountController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _addClipboardItem(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _clipboardStack.insert(0, text.trim());
      _clipInputController.clear();
    });
    _showToast('Added to Clipboard Stack!');
  }

  void _generateSmartReply() {
    final input = _replyInputController.text.trim();
    if (input.isEmpty) {
      _showToast('Please enter a message or prompt first.');
      return;
    }

    setState(() {
      switch (_selectedTone) {
        case 'Professional':
          _generatedReply = 'Thank you for reaching out regarding "$input". I have noted this and will revert with updates shortly. Best regards.';
          break;
        case 'Friendly':
          _generatedReply = 'Hey there! Thanks for the message about "$input". Sounds great to me! Let us get back to this real quick 😊';
          break;
        case 'Direct':
          _generatedReply = 'Understood regarding "$input". Let us proceed with action immediately.';
          break;
        case 'Urgent':
          _generatedReply = 'High priority note on "$input"! Please review and reply back as soon as possible.';
          break;
        default:
          _generatedReply = 'Regarding "$input": Got it, thanks!';
      }
    });
    _showToast('Reply generated in $_selectedTone tone!');
  }

  void _pickRandomDecision() {
    if (_decisionOptions.isEmpty) {
      _showToast('Add at least one decision choice!');
      return;
    }
    setState(() {
      _decisionOptions.shuffle();
      _selectedDecision = _decisionOptions.first;
    });
    _showToast('Decision made!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.layers, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'FloatMate',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _overlayEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: _overlayEnabled ? Colors.teal : Colors.grey,
            ),
            tooltip: 'Toggle Overlay Mode',
            onPressed: () {
              setState(() {
                _overlayEnabled = !_overlayEnabled;
              });
              _showToast(_overlayEnabled ? 'Floating Dock Activated!' : 'Floating Dock Suspended');
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live Status Header Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: _overlayEnabled ? Colors.indigo.shade50 : Colors.grey.shade200,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _overlayEnabled ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _overlayEnabled
                          ? 'Active Floating Overlay: Ready across all apps'
                          : 'Overlay Paused: Tap icon to enable floating dock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _overlayEnabled ? Colors.indigo.shade900 : Colors.grey.shade700,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      '${_clipboardStack.length} Vault Items',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    backgroundColor: Colors.indigo,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // Tab View Body
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildFloatingDockTab(),
                  _buildClipboardVaultTab(),
                  _buildReplyStudioTab(),
                  _buildDecisionMatrixTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets),
            selectedIcon: Icon(Icons.widgets, color: Colors.indigo),
            label: 'Floating Dock',
          ),
          NavigationDestination(
            icon: Icon(Icons.content_copy),
            selectedIcon: Icon(Icons.content_copy, color: Colors.indigo),
            label: 'Clip Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            selectedIcon: Icon(Icons.chat, color: Colors.indigo),
            label: 'Reply Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            selectedIcon: Icon(Icons.psychology, color: Colors.indigo),
            label: 'Decision Wheel',
          ),
        ],
      ),
    );
  }

  // TAB 1: Floating Dock & Overlay Simulator
  Widget _buildFloatingDockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overlay Simulator Card
          Card(
            color: Colors.indigo.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              style: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Floating Quick Bubble Control',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Switch(
                        value: _floatingBubbleActive,
                        activeColor: Colors.tealAccent,
                        onChanged: (val) {
                          setState(() {
                            _floatingBubbleActive = val;
                          });
                          _showToast(val ? 'Floating Bubble Enabled' : 'Floating Bubble Hidden');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Simulates floating widget permissions over other active apps for zero-friction copy-paste & quick replies.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  if (_floatingBubbleActive)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bolt, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Live Floating Assistant Ready',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Tap floating bubble on any screen to invoke quick stack',
                                  style: TextStyle(color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Quick Settings & Permissions Sandbox
          const Text(
            'Smart Context Permissions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Auto-Capture Clipboard Stack', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Save copied snippets automatically without losing previous text'),
                  value: _autoCaptureClipboard,
                  activeColor: Colors.indigo,
                  onChanged: (val) {
                    setState(() {
                      _autoCaptureClipboard = val;
                    });
                    _showToast('Auto-capture setting updated!');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.splitscreen, color: Colors.indigo),
                  title: const Text('Display Above Other Apps Permission'),
                  subtitle: const Text('Granted (Simulated Active Service)'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                  onTap: () {
                    _showToast('Permission Status: Active & Operational');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tune, color: Colors.teal),
                  title: const Text('Instant Quick Calculator & Tip Splitter'),
                  subtitle: const Text('Quick access calculations for daily sharing'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showQuickSplitterModal(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Clip Pinboard
          const Text(
            'Recent Vault Pins',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          if (_clipboardStack.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('No clips saved yet. Switch to Clip Vault tab to add!'),
                ),
              ),
            )
          else
            Column(
              children: _clipboardStack.take(3).map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.content_copy, color: Colors.indigo),
                    title: Text(
                      item,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, color: Colors.teal),
                      tooltip: 'Copy Now',
                      onPressed: () {
                        _showToast('Copied to Clipboard!');
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // TAB 2: Multi-Clipboard Vault
  Widget _buildClipboardVaultTab() {
    return Column(
      children: [
        // Top Add Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _clipInputController,
                      decoration: const InputDecoration(
                        hintText: 'Paste or type new text snippet to vault...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onPressed: () => _addClipboardItem(_clipInputController.text),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Stack'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAxisAlignment.center,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.text_fields, size: 16),
                    label: const Text('TRIM ALL'),
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < _clipboardStack.length; i++) {
                          _clipboardStack[i] = _clipboardStack[i].trim();
                        }
                      });
                      _showToast('All stack items trimmed!');
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.format_size, size: 16),
                    label: const Text('UPPERCASE'),
                    onPressed: () {
                      setState(() {
                        for (int i = 0; i < _clipboardStack.length; i++) {
                          _clipboardStack[i] = _clipboardStack[i].toUpperCase();
                        }
                      });
                      _showToast('All items converted to uppercase!');
                    },
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.delete_sweep, size: 16, color: Colors.red),
                    label: const Text('CLEAR ALL'),
                    onPressed: () {
                      setState(() {
                        _clipboardStack.clear();
                      });
                      _showToast('Clipboard Vault cleared');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // List of Stacked Items
        Expanded(
          child: _clipboardStack.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.layers_clear, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Clipboard Vault is Empty',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Add text snippets above to build your multi-clip stack',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _clipboardStack.length,
                  itemBuilder: (context, index) {
                    final item = _clipboardStack[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.indigo.shade100,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.chat, size: 16, color: Colors.teal),
                                  label: const Text('Send to Reply Studio', style: TextStyle(color: Colors.teal, fontSize: 12)),
                                  onPressed: () {
                                    setState(() {
                                      _replyInputController.text = item;
                                      _currentIndex = 2; // Navigate to Reply Studio
                                    });
                                    _showToast('Transferred to Reply Studio!');
                                  },
                                ),
                                const SizedBox(width: 4),
                                TextButton.icon(
                                  icon: const Icon(Icons.copy, size: 16, color: Colors.indigo),
                                  label: const Text('Copy', style: TextStyle(color: Colors.indigo, fontSize: 12)),
                                  onPressed: () {
                                    _showToast('Copied item #${index + 1} to clipboard!');
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                  tooltip: 'Delete Item',
                                  onPressed: () {
                                    setState(() {
                                      _clipboardStack.removeAt(index);
                                    });
                                    _showToast('Item deleted');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // TAB 3: Tone & Smart Reply Studio
  Widget _buildReplyStudioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.teal.shade800,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Instant Reply & Tone Studio',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Convert raw ideas or incoming messages into structured, ready-to-send responses instantly.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '1. Target Message / Raw Idea',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _replyInputController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Paste incoming message or key points (e.g., "Can you send the project budget by 4 PM?")...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            '2. Select Response Tone',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Professional', 'Friendly', 'Direct', 'Urgent'].map((tone) {
              final isSelected = _selectedTone == tone;
              return ChoiceChip(
                label: Text(tone),
                selected: isSelected,
                selectedColor: Colors.indigo,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
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

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _generateSmartReply,
              icon: const Icon(Icons.auto_awesome),
              label: const Text(
                'Generate Ready Reply',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (_generatedReply.isNotEmpty) ...[
            const Text(
              '3. Generated Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.indigo, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _generatedReply,
                      style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy to Clipboard'),
                          onPressed: () {
                            _showToast('Generated reply copied!');
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add_to_photos, size: 16),
                          label: const Text('Save to Vault'),
                          onPressed: () {
                            _addClipboardItem(_generatedReply);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // TAB 4: Micro Decision Matrix Wheel
  Widget _buildDecisionMatrixTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.amber.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Micro-Decision Matrix',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Eliminate paralysis on daily choices (e.g. what to prioritize, reply options, or quick task order).',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Choice Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _decisionInputController,
                  decoration: const InputDecoration(
                    hintText: 'Add decision option (e.g., "Option A")...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onPressed: () {
                  final text = _decisionInputController.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _decisionOptions.add(text);
                      _decisionInputController.clear();
                    });
                    _showToast('Added choice option!');
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Options Chips List
          const Text(
            'Active Decision Pool:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _decisionOptions.map((option) {
              return Chip(
                label: Text(option),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    _decisionOptions.remove(option);
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Resolve Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _pickRandomDecision,
              icon: const Icon(Icons.psychology),
              label: const Text(
                'Resolve Micro-Decision Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Picked Result Display
          if (_selectedDecision.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'SELECTED ACTION CHOICE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _selectedDecision,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _addClipboardItem('Chosen Action: $_selectedDecision');
                    },
                    icon: const Icon(Icons.add_to_photos, size: 16),
                    label: const Text('Save Choice to Vault'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Quick Calculator / Splitter Modal
  void _showQuickSplitterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double bill = double.tryParse(_billAmountController.text) ?? 0.0;
            final double tipAmount = bill * (_tipPercentage / 100.0);
            final double total = bill + tipAmount;
            final double perPerson = _splitPeople > 0 ? total / _splitPeople : total;

            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                          'Quick Bill & Split Helper',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _billAmountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Total Bill Amount (\$)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tip Percentage: ${_tipPercentage.toInt()}%',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _tipPercentage,
                      min: 0,
                      max: 30,
                      divisions: 6,
                      activeColor: Colors.indigo,
                      label: '${_tipPercentage.toInt()}%',
                      onChanged: (val) {
                        setModalState(() {
                          _tipPercentage = val;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Split Between People: $_splitPeople', style: const TextStyle(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (_splitPeople > 1) {
                                  setModalState(() {
                                    _splitPeople--;
                                  });
                                }
                              },
                            ),
                            Text('$_splitPeople', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setModalState(() {
                                  _splitPeople++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Per Person Amount:'),
                              Text(
                                '\$${perPerson.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total (Bill + Tip):', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                              Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final summary = 'Split Total: \$${total.toStringAsFixed(2)} (\$${perPerson.toStringAsFixed(2)} each for $_splitPeople people)';
                          _addClipboardItem(summary);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy Breakdown to Vault'),
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
}