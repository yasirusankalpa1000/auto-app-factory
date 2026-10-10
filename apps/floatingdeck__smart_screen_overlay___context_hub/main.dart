import 'package:flutter/material.dart';

void main() {
  runApp(const FloatingDeckApp());
}

class FloatingDeckApp extends StatelessWidget {
  const FloatingDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FloatingDeck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
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
  int _selectedTabIndex = 0;

  final List<Widget> _pages = const [
    OverlayHUDTab(),
    CompareDeckTab(),
    StickyClipsTab(),
    DecisionMatrixTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E28),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.widgets, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'FloatingDeck Companion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.amber),
            onPressed: () {
              _showNotificationPreviewDialog(context);
            },
            tooltip: 'Floating Notification Preview',
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E1E28),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Overlay HUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Sticky Clips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Decision',
          ),
        ],
      ),
    );
  }

  void _showNotificationPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF252538),
        title: Row(
          children: const [
            Icon(Icons.notifications_active, color: Colors.amber),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Floating Notification Bar',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Persistent Overlay Banner keeps quick actions available over any app on your screen!',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A24),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bolt, color: Colors.amber, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'FloatingDeck Active Bar',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ready: Clip copied to sticky buffer (\$19.99 Promo applied)',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            minimumSize: const Size(80, 30),
                          ),
                          icon: const Icon(Icons.add, size: 12, color: Colors.white),
                          label: const Text('Quick Note', style: TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(80, 30),
                            side: const BorderSide(color: Colors.amber),
                          ),
                          icon: const Icon(Icons.calculate, size: 12, color: Colors.amber),
                          label: const Text('Split Bill', style: TextStyle(fontSize: 10, color: Colors.amber)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 1: OVERLAY HUD CONTROL ====================
class OverlayHUDTab extends StatefulWidget {
  const OverlayHUDTab({super.key});

  @override
  State<OverlayHUDTab> createState() => _OverlayHUDTabState();
}

class _OverlayHUDTabState extends State<OverlayHUDTab> {
  bool _overlayEnabled = true;
  bool _bubbleMode = true;
  double _opacityValue = 0.85;
  String _selectedPosition = 'Top Right';
  double _bubbleX = 180.0;
  double _bubbleY = 120.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _overlayEnabled
                      ? [Colors.deepPurple, Colors.indigo]
                      : [Colors.grey.shade800, Colors.grey.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _overlayEnabled ? Icons.layers : Icons.layers_clear,
                    size: 36,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _overlayEnabled ? 'Screen Overlay Active' : 'Overlay Disabled',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _overlayEnabled
                              ? 'Display over apps is live. Drag floating bubble below!'
                              : 'Enable screen permission to launch floating dock over other apps.',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _overlayEnabled,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _overlayEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Interactive Overlay Screen Preview',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simulate how your floating bubble behaves on top of other phone apps:',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Simulated Mobile Phone Screen Container
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white70, width: 2),
              ),
              child: Stack(
                children: [
                  // Mock app background
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(6)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              '[ Target App: Online Store / Social Media ]',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text('Product Item A\n\$49.99', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text('Product Item B\n\$39.99', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Draggable Simulated Floating Bubble / Deck
                  if (_overlayEnabled)
                    Positioned(
                      left: _bubbleX,
                      top: _bubbleY,
                      child: GestureDetecorWidget(
                        opacity: _opacityValue,
                        isBubble: _bubbleMode,
                        onDragUpdate: (details) {
                          setState(() {
                            _bubbleX = (_bubbleX + details.delta.dx).clamp(10.0, 240.0);
                            _bubbleY = (_bubbleY + details.delta.dy).clamp(10.0, 200.0);
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Customization Options
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E28),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HUD Controls & Customization',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    main