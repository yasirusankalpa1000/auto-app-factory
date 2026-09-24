import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OverlayDockApp());
}

class OverlayDockApp extends StatelessWidget {
  const OverlayDockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlayDock Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainDockScreen(),
    );
  }
}

class MainDockScreen extends StatefulWidget {
  const MainDockScreen({super.key});

  @override
  State<MainDockScreen> createState() => _MainDockScreenState();
}

class _MainDockScreenState extends State<MainDockScreen> {
  int _currentIndex = 0;

  // Floating Overlay State
  bool _isFloatingDockEnabled = true;
  bool _isFloatingMenuExpanded = false;
  Offset _dockPosition = const Offset(20, 200);

  // Stealth Privacy Overlay State
  bool _isStealthGuardActive = false;
  double _stealthOpacity = 0.6;
  double _maskHeight = 120.0;
  Color _guardColor = Colors.black;

  // Floating Notification Toast State
  String? _activeNotificationText;
  String? _activeNotificationTitle;
  IconData _activeNotificationIcon = Icons.notifications_active;
  Timer? _notificationTimer;

  // Session & Engagement State
  int _sessionSeconds = 0;
  late Timer _sessionTimer;
  int _dockPoints = 120;

  @override
  void initState() {
    super.initState();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _sessionSeconds++;
        if (_sessionSeconds % 30 == 0) {
          _dockPoints += 15;
        }
      });
    });
  }

  @override
  void dispose() {
    _sessionTimer.cancel();
    _notificationTimer?.cancel();
    super.dispose();
  }

  void _triggerFloatingNotification(String title, String message, IconData icon) {
    _notificationTimer?.cancel();
    setState(() {
      _activeNotificationTitle = title;
      _activeNotificationText = message;
      _activeNotificationIcon = icon;
    });

    _notificationTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _activeNotificationText = null;
          _activeNotificationTitle = null;
        });
      }
    });
  }

  String _formatSessionTime(int totalSeconds) {
    int mins = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // MAIN NAVIGATION SCREEN
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildPrivacyGuardTab(),
                _buildFloatingNotifierTab(),
                _buildSmartClipTab(),
                _buildDecisionSplitterTab(),
                _buildSessionStatsTab(),
              ],
            ),
          ),

          // STEALTH SCREEN GUARD OVERLAY SIMULATOR
          if (_isStealthGuardActive)
            Positioned(
              left: 0,
              right: 0,
              top: 100,
              child: Container(
                height: _maskHeight,
                color: _guardColor.withOpacity(_stealthOpacity),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Stealth Mask Active (${(_stealthOpacity * 100).toInt()}%)',
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

          // FLOATING NOTIFICATION BANNER (TOP TOAST)
          if (_activeNotificationText != null)
            Positioned(
              top: 45,
              left: 16,
              right: 16,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.tealAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_activeNotificationIcon, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _activeNotificationTitle ?? 'Notification',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            _activeNotificationText!,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 18),
                      onPressed: () {
                        setState(() {
                          _activeNotificationText = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

          // DRAGGABLE FLOATING DOCK HEAD & RADIAL TOOLBAR
          if (_isFloatingDockEnabled)
            Positioned(
              left: _dockPosition.dx,
              top: _dockPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double newX = _dockPosition.dx + details.delta.dx;
                    double newY = _dockPosition.dy + details.delta.dy;
                    newX = newX.clamp(0.0, screenSize.width - 60.0);
                    newY = newY.clamp(40.0, screenSize.height - 120.0);
                    _dockPosition = Offset(newX, newY);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isFloatingMenuExpanded)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.teal, width: 1.5),
                          boxShadow: const [
                            BoxShadow(color: Colors.black87, blurRadius: 10)
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildDockQuickAction(
                              icon: Icons.security,
                              color: Colors.amber,
                              label: 'Stealth',
                              onTap: () {
                                setState(() {
                                  _isStealthGuardActive = !_isStealthGuardActive;
                                });
                                _triggerFloatingNotification(
                                  'Stealth Guard',
                                  _isStealthGuardActive ? 'Privacy screen overlay enabled' : 'Privacy screen overlay disabled',
                                  Icons.security,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildDockQuickAction(
                              icon: Icons.notifications_active,
                              color: Colors.tealAccent,
                              label: 'Banner',
                              onTap: () {
                                _triggerFloatingNotification(
                                  'Quick Dock Trigger',
                                  'You clicked action inside the floating dock!',
                                  Icons.bolt,
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildDockQuickAction(
                              icon: Icons.cleaning_services,
                              color: Colors.deepOrangeAccent,
                              label: 'Clean',
                              onTap: () {
                                setState(() {
                                  _currentIndex = 2;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    FloatingActionButton.small(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      onPressed: () {
                        setState(() {
                          _isFloatingMenuExpanded = !_isFloatingMenuExpanded;
                        });
                      },
                      child: Icon(_isFloatingMenuExpanded ? Icons.close : Icons.widgets),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Privacy'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifier'),
          BottomNavigationBarItem(icon: Icon(Icons.content_copy), label: 'ClipMorph'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Decision'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Rewards'),
        ],
      ),
    );
  }

  Widget _buildDockQuickAction({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: PRIVACY SCREEN GUARD HUD
  Widget _buildPrivacyGuardTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderBadge('STEALTH PRIVACY GUARD', 'Protect private chats & text in public'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _isStealthGuardActive,
                    title: const Text('Enable Stealth Mask Overlay', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Applies a dark tint strip over sensitive chat areas'),
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _isStealthGuardActive = val;
                      });
                    },
                  ),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Opacity Level:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(
                        child: Slider(
                          value: _stealthOpacity,
                          min: 0.2,
                          max: 0.95,
                          activeColor: Colors.tealAccent,
                          onChanged: _isStealthGuardActive
                              ? (val) {
                                  setState(() {
                                    _stealthOpacity = val;
                                  });
                                }
                              : null,
                        ),
                      ),
                      Text('${(_stealthOpacity * 100).toInt()}%'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Mask Height:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(
                        child: Slider(
                          value: _maskHeight,
                          min: 60.0,
                          max: 300.0,
                          activeColor: Colors.tealAccent,
                          onChanged: _isStealthGuardActive
                              ? (val) {
                                  setState(() {
                                    _maskHeight = val;
                                  });
                                }
                              : null,
                        ),
                      ),
                      Text('${_maskHeight.toInt()} px'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Guard Shade Color:', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildColorChip('Stealth Dark', Colors.black),
                      _buildColorChip('Navy Tint', const Color(0xFF0F172A)),
                      _buildColorChip('Matrix Green', const Color(0xFF022C22)),
                      _buildColorChip('Deep Purple', const Color(0xFF3B0764)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'LIVE PRIVACY PREVIEW DEMO',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFakeChatMessage('Hey! Are you sending the banking password now?', true),
                      const SizedBox(height: 8),
                      _buildFakeChatMessage('Yes, my PIN code is 8842-1092', false),
                      const SizedBox(height: 8),
                      _buildFakeChatMessage('Got it! Keep this completely confidential.', true),
                    ],
                  ),
                  if (_isStealthGuardActive)
                    Positioned(
                      top: 40,
                      left: 0,
                      right: 0,
                      height: _maskHeight > 100 ? 100 : _maskHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _guardColor.withOpacity(_stealthOpacity),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'PROTECTED STEALTH ZONE',
                            style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.2),
                          ),
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

  Widget _buildColorChip(String name, Color color) {
    bool isSelected = _guardColor == color;
    return ChoiceChip(
      label: Text(name, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 11)),
      selected: isSelected,
      selectedColor: Colors.tealAccent,
      backgroundColor: const Color(0xFF334155),
      onSelected: (sel) {
        if (sel) {
          setState(() {
            _guardColor = color;
          });
        }
      },
    );
  }

  Widget _buildFakeChatMessage(String text, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF1E293B) : Colors.indigo,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.white)),
      ),
    );
  }

  // TAB 2: FLOATING NOTIFIER & BANNER HUB
  Widget _buildFloatingNotifierTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderBadge('FLOATING BANNER NOTIFIER', 'Simulate overlay floating popups & micro alerts'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Instant Notification Presets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _buildNotificationTriggerTile(
                    title: 'Urgent Simulated Call Alert',
                    subtitle: 'Triggers a floating caller card overlay banner',
                    icon: Icons.phone_in_talk,
                    onTap: () {
                      _triggerFloatingNotification(
                        'Incoming Work Call',
                        'Manager is calling... Tap to handle',
                        Icons.phone_in_talk,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationTriggerTile(
                    title: 'Hydration & Micro-Break Reminder',
                    subtitle: 'Floating health ping every hour',
                    icon: Icons.local_drink,
                    onTap: () {
                      _triggerFloatingNotification(
                        'Hydration Check',
                        'Time to drink 250ml water and relax eyes!',
                        Icons.local_drink,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildNotificationTriggerTile(
                    title: 'VIP Secure Vault Ping',
                    subtitle: 'Simulate confidential text receipt',
                    icon: Icons.lock,
                    onTap: () {
                      _triggerFloatingNotification(
                        'Encrypted Message',
                        'New 2FA security code received: 948-201',
                        Icons.lock,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Floating Dock Head Controls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: _isFloatingDockEnabled,
                    title: const Text('Show Draggable Dock Head'),
                    subtitle: const Text('Keeps a floating widget button visible on screen'),
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _isFloatingDockEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTriggerTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.tealAccent.withOpacity(0.2),
          child: Icon(icon, color: Colors.tealAccent, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          onPressed: onTap,
          child: const Text('Trigger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ),
      ),
    );
  }

  // TAB 3: SMART CLIPBOARD & TEXT MORPH ENGINE
  final TextEditingController _textController = TextEditingController();
  String _cleanedText = '';
  String _cipherText = '';
  int _wordCount = 0;

  Widget _buildSmartClipTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderBadge('CLIPMORPH & LINK CLEANER', 'Strip tracker links, count words, & convert secret ciphers'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Paste messy tracking URL or raw text here...',
                      border: OutlineInputBorder(),
                      fillColor: Color(0xFF0F172A),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.cleaning_services, size: 16),
                        label: const Text('Clean URL & Text'),
                        onPressed: () {
                          String raw = _textController.text;
                          // Remove common tracking params
                          String cleaned = raw.replaceAll(RegExp(r'\?utm_[^&]+'), '');
                          cleaned = cleaned.replaceAll(RegExp(r'&utm_[^&]+'), '');
                          cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

                          // Simple ROT13 / Cipher simulator
                          String cipher = cleaned.split('').map((char) {
                            int code = char.codeUnitAt(0);
                            return String.fromCharCode(code + 1);
                          }).join('');

                          setState(() {
                            _cleanedText = cleaned;
                            _cipherText = cipher;
                            _wordCount = cleaned.isEmpty ? 0 : cleaned.split(RegExp(r'\s+')).length;
                          });

                          _triggerFloatingNotification(
                            'Text Cleaned!',
                            'Stripped tracking queries and formatted text',
                            Icons.check_circle,
                          );
                        },
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.tealAccent),
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear'),
                        onPressed: () {
                          _textController.clear();
                          setState(() {
                            _cleanedText = '';
                            _cipherText = '';
                            _wordCount = 0;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_cleanedText.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.tealAccent.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Cleaned Output', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                        Text('Words: $_wordCount', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _cleanedText,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const Divider(color: Colors.white70, height: 24),
                    const Text('Secret Stealth Cipher', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    const SizedBox(height: 4),
                    SelectableText(
                      _cipherText,
                      style: const TextStyle(fontSize: 12, color: Colors.amberAccent, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // TAB 4: INTERACTIVE BILL SPLITTER & DECISION SPINNER
  double _billAmount = 45.00;
  int _personCount = 3;
  double _tipPercentage = 15.0;

  final List<String> _decisionOptions = ['Pizza Night', 'Healthy Salad', 'Burger Crave', 'Sushi Roll', 'Home Cooking'];
  String _selectedDecision = 'Spin to Decide!';
  bool _isSpinning = false;

  Widget _buildDecisionSplitterTab() {
    double totalTip = _billAmount * (_tipPercentage / 100);
    double grandTotal = _billAmount + totalTip;
    double perPerson = _personCount > 0 ? grandTotal / _personCount : 0.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderBadge('MICRO-DECISION & SPLIT HUD', 'Quick group bill splitter & daily decision spinner'),
            const SizedBox(height: 16),

            // BILL SPLITTER CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Smart Micro Bill Splitter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bill:'),
                      Text('\$${_billAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.tealAccent)),
                    ],
                  ),
                  Slider(
                    value: _billAmount,
                    min: 5.0,
                    max: 300.0,
                    divisions: 59,
                    activeColor: Colors.tealAccent,
                    onChanged: (val) {
                      setState(() {
                        _billAmount = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('People: $_personCount'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.tealAccent),
                            onPressed: _personCount > 1
                                ? () {
                                    setState(() {
                                      _personCount--;
                                    });
                                  }
                                : null,
                          ),
                          Text('$_personCount', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.tealAccent),
                            onPressed: () {
                              setState(() {
                                _personCount++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tip Badge:'),
                      Wrap(
                        spacing: 6,
                        children: [10, 15, 20].map((tip) {
                          bool isSel = _tipPercentage == tip.toDouble();
                          return ChoiceChip(
                            label: Text('$tip%'),
                            selected: isSel,
                            selectedColor: Colors.tealAccent,
                            labelStyle: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 10),
                            onSelected: (sel) {
                              if (sel) {
                                setState(() {
                                  _tipPercentage = tip.toDouble();
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white70, height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Each Person Pays:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '\$${perPerson.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DECISION SPINNER TOOL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                children: [
                  const Text('Daily Micro-Decision Randomizer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  const Text('Stuck on what to eat or do next? Let the dock decide.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: _isSpinning ? Colors.amber.shade900 : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber, width: 1.5),
                    ),
                    child: Text(
                      _selectedDecision,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.amberAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.casino),
                    label: Text(_isSpinning ? 'Spinning...' : 'Spin Decision Wheel'),
                    onPressed: _isSpinning
                        ? null
                        : () {
                            setState(() {
                              _isSpinning = true;
                            });
                            int count = 0;
                            Timer.periodic(const Duration(milliseconds: 100), (timer) {
                              count++;
                              setState(() {
                                _selectedDecision = _decisionOptions[Random().nextInt(_decisionOptions.length)];
                              });
                              if (count >= 12) {
                                timer.cancel();
                                setState(() {
                                  _isSpinning = false;
                                });
                                _triggerFloatingNotification(
                                  'Decision Locked!',
                                  'Your pick is: $_selectedDecision',
                                  Icons.casino,
                                );
                              }
                            });
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 5: SESSION RETENTION STATS & REWARDS HUD
  Widget _buildSessionStatsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderBadge('DOCK REWARDS & SESSION TIME', 'Earn status badges by keeping tools active'),
            const SizedBox(height: 16),

            // LIVE TIMER DISPLAY
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text('Active App Dwell Time', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(
                    _formatSessionTime(_sessionSeconds),
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatMetric('Dock Points', '$_dockPoints PTS'),
                      _buildStatMetric('User Tier', _sessionSeconds > 120 ? 'Master' : 'Novice'),
                      _buildStatMetric('Overlay Status', _isFloatingDockEnabled ? 'Active' : 'Disabled'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ADMOB REVENUE PLACEHOLDER BANNER (SIMULATION)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.monetization_on, color: Colors.black, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AdMob Monetization Ready', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('High retention dwell time guarantees maximum eCPM revenue.', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('\$ Active', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // REWARD BADGES UNLOCKED
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white70),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Utility Badges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _buildBadgeRow('Stealth Master', 'Enabled privacy guard tint', _isStealthGuardActive),
                  const SizedBox(height: 8),
                  _buildBadgeRow('Floating Controller', 'Active floating dock bubble', _isFloatingDockEnabled),
                  const SizedBox(height: 8),
                  _buildBadgeRow('Loyal User', 'Spent over 1 minute in tool HUD', _sessionSeconds >= 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatMetric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }

  Widget _buildBadgeRow(String title, String desc, bool isUnlocked) {
    return Row(
      children: [
        Icon(
          isUnlocked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isUnlocked ? Colors.tealAccent : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isUnlocked ? Colors.white : Colors.grey,
                ),
              ),
              Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderBadge(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}