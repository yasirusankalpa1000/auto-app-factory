import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  runApp(const PocketHUDApp());
}

class PocketHUDApp extends StatelessWidget {
  const PocketHUDApp({Key? key}) : super(key:Key? key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketHUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainHUDPage(),
    );
  }
}

class MainHUDPage extends StatefulWidget {
  const MainHUDPage({Key? key}) : super(key: key);

  @override
  State<MainHUDPage> createState() => _MainHUDPageState();
}

class _MainHUDPageState extends State<MainHUDPage> {
  int _currentIndex = 0;
  bool _isFloatingOverlayEnabled = true;
  bool _isPrivacyShieldActive = false;

  final List<Widget> _pages = const [
    DashboardHUDTab(),
    MicroFixerTab(),
    PixelRepairTab(),
    LevelAndAudioTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _pages[_currentIndex],
            if (_isPrivacyShieldActive)
              IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: const Center(
                    child: Text(
                      'PRIVACY SHIELD ACTIVE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            if (_isFloatingOverlayEnabled)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.indigoAccent, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.flash_on, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'HUD ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPrivacyShieldActive = !_isPrivacyShieldActive;
                          });
                        },
                        child: Icon(
                          _isPrivacyShieldActive ? Icons.visibility_off : Icons.visibility,
                          color: _isPrivacyShieldActive ? Colors.amber : Colors.white70,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
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
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: Colors.indigo.shade600,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label: 'Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.build, color: Colors.white),
            label: 'Micro-Fixer',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.cleaning_services, color: Colors.white),
            label: 'Screen Clean',
          ),
          NavigationDestination(
            icon: Icon(Icons.straighten_outlined, color: Colors.white70),
            selectedIcon: Icon(Icons.straighten, color: Colors.white),
            label: 'Level & Sound',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: DASHBOARD HUD
// -----------------------------------------------------------------------------
class DashboardHUDTab extends StatelessWidget {
  const DashboardHUDTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.widgets, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'PocketHUD Suite',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Everyday Practical Micro-Tools',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Alert / Tip Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade900, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Daily Quick Tip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Dropped phone in water? Do NOT charge! Wipe surface, turn off immediately, and check Micro-Fixer guide.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Instant Utility Quick-Launch',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Grid of Micro Tools
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildToolCard(
                context,
                title: 'Stain & Fix Guide',
                subtitle: '12 Emergency Fixes',
                icon: Icons.local_fire_department,
                color: Colors.deepOrange,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switch to "Micro-Fixer" tab below for guides!')),
                  );
                },
              ),
              _buildToolCard(
                context,
                title: 'Screen Repair',
                subtitle: 'Fix Burn-In & Pixels',
                icon: Icons.cleaning_services,
                color: Colors.purple,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switch to "Screen Clean" tab below!')),
                  );
                },
              ),
              _buildToolCard(
                context,
                title: 'Surface Level',
                subtitle: 'Precision Gauge',
                icon: Icons.crop_free,
                color: Colors.blue,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switch to "Level & Sound" tab below!')),
                  );
                },
              ),
              _buildToolCard(
                context,
                title: 'Audio Noise Meter',
                subtitle: 'Decibel Safety Check',
                icon: Icons.volume_up,
                color: Colors.green,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switch to "Level & Sound" tab below!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dynamic Screen Reader / Contrast Inspector Micro Tool
          const Text(
            'Quick Contrast & Visual Inspector',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const ContrastInspectorWidget(),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final double width = (MediaQuery.of(context).size.width - 44) / 2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 20,
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CONTRAST INSPECTOR WIDGET
// -----------------------------------------------------------------------------
class ContrastInspectorWidget extends StatefulWidget {
  const ContrastInspectorWidget({Key? key}) : super(key: key);

  @override
  State<ContrastInspectorWidget> createState() => _ContrastInspectorWidgetState();
}

class _ContrastInspectorWidgetState extends State<ContrastInspectorWidget> {
  Color _bgColor = Colors.blue.shade900;
  Color _textColor = Colors.white;

  final List<Color> _colors = [
    Colors.white,
    Colors.black,
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate estimated contrast score
    final double bgLuminance = _bgColor.computeLuminance();
    final double textLuminance = _textColor.computeLuminance();
    final double ratio = (math.max(bgLuminance, textLuminance) + 0.05) /
        (math.min(bgLuminance, textLuminance) + 0.05);

    final bool isPass = ratio >= 4.5;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Readable Text Preview',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contrast Ratio: ${ratio.toStringAsFixed(2)}:1',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPass ? Colors.green.shade800 : Colors.red.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPass ? 'PASS (WCAG AAA)' : 'POOR READABILITY',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Background Color:', style: TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _colors.map((c) {
                return GestureDetector(
                  onTap: () => setState(() => _bgColor = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _bgColor == c ? Colors.amber : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Text Color:', style: TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _colors.map((c) {
                return GestureDetector(
                  onTap: () => setState(() => _textColor = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _textColor == c ? Colors.amber : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: MICRO-FIXER EMERGENCY MATRIX
// -----------------------------------------------------------------------------
class MicroFixerTab extends StatefulWidget {
  const MicroFixerTab({Key? key}) : super(key: key);

  @override
  State<MicroFixerTab> createState() => _MicroFixerTabState();
}

class _MicroFixerTabState extends State<MicroFixerTab> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _guides = [
    {
      'title': 'Wet Phone Emergency',
      'category': 'Electronics',
      'icon': Icons.phonelink_erase,
      'color': Colors.blue,
      'urgency': 'CRITICAL (First 5 mins)',
      'steps': [
        'Turn off phone immediately. Do NOT push volume buttons.',
        'Remove phone case, SIM tray, and SD card.',
        'Dab moisture off exterior using lint-free cloth.',
        'Place in front of a cool air fan (Do NOT use hot blowdryer!).',
        'Leave in dry area with silica gel packets for 24-48 hrs.',
      ],
    },
    {
      'title': 'Red Wine on Carpet / Fabric',
      'category': 'Stains',
      'icon': Icons.local_bar,
      'color': Colors.red,
      'urgency': 'HIGH (Act quickly)',
      'steps': [
        'Blot liquid immediately with paper towel. Do NOT rub!',
        'Pour generous amount of table salt or baking soda over wet stain.',
        'Let salt absorb red wine for 10-15 minutes until dry.',
        'Vacuum up salt completely.',
        'Dab remaining residue with mixture of dish soap and cold water.',
      ],
    },
    {
      'title': 'Stuck Ring on Swollen Finger',
      'category': 'Body',
      'icon': Icons.pan_tool,
      'color': Colors.amber,
      'urgency': 'MEDIUM',
      'steps': [
        'Elevate hand above heart level for 3-5 minutes to reduce swelling.',
        'Submerge hand in ice cold water for 2 minutes.',
        'Apply liquid soap, olive oil, or petroleum jelly around finger.',
        'Twist ring slowly back and forth while pulling gently.',
        'If blood circulation stops, seek medical emergency cutting.',
      ],
    },
    {
      'title': 'Superglue Stuck on Skin',
      'category': 'Body',
      'icon': Icons.back_hand,
      'color': Colors.teal,
      'urgency': 'HIGH',
      'steps': [
        'Do NOT force skin apart or yank violently.',
        'Soak affected skin in warm soapy water for 5 minutes.',
        'Apply acetone nail polish remover with cotton swab to dissolve bond.',
        'Peel skin gently from edge once glue softens.',
        'Apply hand cream or lotion to restore skin moisture.',
      ],
    },
    {
      'title': 'Chewing Gum in Hair or Shoes',
      'category': 'Stains',
      'icon': Icons.cleaning_services,
      'color': Colors.pink,
      'urgency': 'MEDIUM',
      'steps': [
        'Apply peanut butter or vegetable oil directly to gum.',
        'Massage oil into gum; fats break down gum polymer base.',
        'Alternatively, rub ice cube on gum for 5 minutes until rock hard.',
        'Slide hardened gum off hair strands or shoe sole.',
        'Wash hair with standard shampoo.',
      ],
    },
    {
      'title': 'Grease & Oil Spill on Clothes',
      'category': 'Stains',
      'icon': Icons.opacity,
      'color': Colors.deepOrange,
      'urgency': 'HIGH',
      'steps': [
        'Cover fresh oil stain completely with cornstarch or baby powder.',
        'Let sit for 15 minutes to pull oil out of cotton fibers.',
        'Brush powder away.',
        'Apply concentrated liquid dish soap directly to stain.',
        'Wash under warmest water garment care label allows.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _guides.where((guide) {
      final matchesCat = _selectedCategory == 'All' || guide['category'] == _selectedCategory;
      final matchesSearch = guide['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Emergency Micro-Fixer Matrix',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Step-by-step solutions for daily unexpected mini-crises',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Search Box
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search problem (e.g. wine, phone, glue)...',
              hintStyle: const TextStyle(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Electronics', 'Stains', 'Body'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedCategory = cat);
                    },
                    selectedColor: Colors.indigo,
                    backgroundColor: const Color(0xFF1E293B),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Guide Cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final guide = filtered[index];
              return _buildGuideCard(guide);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Map<String, dynamic> guide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (guide['color'] as Color).withOpacity(0.3), width: 1),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: (guide['color'] as Color).withOpacity(0.2),
          child: Icon(guide['icon'] as IconData, color: guide['color'] as Color),
        ),
        title: Text(
          guide['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
        subtitle: Text(
          'Urgency: ${guide['urgency']}',
          style: TextStyle(fontSize: 11, color: guide['color'] as Color, fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Action Steps:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ...List.generate((guide['steps'] as List<String>).length, (idx) {
            final stepText = (guide['steps'] as List<String>)[idx];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2, right: 10),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${idx + 1}',
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      stepText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: SCREEN PIXEL & BURN-IN REPAIR (High Engagement Screen Time Feature)
// -----------------------------------------------------------------------------
class PixelRepairTab extends StatefulWidget {
  const PixelRepairTab({Key? key}) : super(key: key);

  @override
  State<PixelRepairTab> createState() => _PixelRepairTabState();
}

class _PixelRepairTabState extends State<PixelRepairTab> {
  bool _isRunning = false;
  int _secondsRemaining = 300; // 5 minute default treatment cycle
  Timer? _timer;
  int _colorIndex = 0;

  final List<Color> _flashColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.black,
    Colors.yellow,
    Colors.cyan,
    Colors.magenta,
  ];

  void _startTreatment() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_secondsRemaining <= 0) {
        _stopTreatment();
      } else {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _flashColors.length;
          if (timer.tick % 6 == 0) {
            _secondsRemaining--;
          }
        });
      }
    });
  }

  void _stopTreatment() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isRunning) {
      return GestureDetector(
        onTap: _stopTreatment,
        child: Container(
          color: _flashColors[_colorIndex],
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'PIXEL REPAIR ACTIVE',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Time Left: ${_secondsRemaining ~/ 60}m ${_secondsRemaining % 60}s',
                          style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tap anywhere to pause cycle',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Screen Pixel & Burn-In Fixer',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Exercises RGB sub-pixels to revive stuck pixels and reduce image retention',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // Status & Control Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.shade400, width: 1.5),
            ),
            child: Column(
              children: [
                const Icon(Icons.cleaning_services, size: 48, color: Colors.purpleAccent),
                const SizedBox(height: 12),
                const Text(
                  'Recommended Cycle: 5 to 15 Mins',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text(
                  'High-frequency color cycling stimulates sub-pixel transistors to clear residual ghosting on AMOLED and LCD displays.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Duration Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 5, 10, 15].map((mins) {
                    final isSel = (_secondsRemaining == mins * 60);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text('${mins}m'),
                        selected: isSel,
                        onSelected: (val) {
                          setState(() {
                            _secondsRemaining = mins * 60;
                          });
                        },
                        selectedColor: Colors.purple,
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _startTreatment,
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: const Text(
                      'START PIXEL REPAIR CYCLE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Diagnostic Checklist
          const Text(
            'Display Diagnostic Checks',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          _buildDiagnosticItem(
            title: 'Ghosting Test',
            desc: 'Check for lingering shadows of keyboard or social app icons.',
            icon: Icons.visibility,
          ),
          _buildDiagnosticItem(
            title: 'Stuck Pixel Check',
            desc: 'Look closely for single static green, red, or white dots.',
            icon: Icons.filter_center_focus,
          ),
          _buildDiagnosticItem(
            title: 'Uniformity Inspection',
            desc: 'Inspect background consistency on full red/blue screens.',
            icon: Icons.grid_view,
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticItem({required String title, required String desc, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 4: SURFACE BUBBLE LEVEL & AUDIO NOISE METER
// -----------------------------------------------------------------------------
class LevelAndAudioTab extends StatefulWidget {
  const LevelAndAudioTab({Key? key}) : super(key: key);

  @override
  State<LevelAndAudioTab> createState() => _LevelAndAudioTabState();
}

class _LevelAndAudioTabState extends State<LevelAndAudioTab> {
  // Interactive bubble level positions
  double _bubbleX = 0.0; // -1.0 to 1.0
  double _bubbleY = 0.0; // -1.0 to 1.0

  // Sound meter simulation state
  bool _isMeasuringSound = false;
  double _currentDecibels = 42.0;
  Timer? _soundTimer;
  final List<double> _dbHistory = [35, 40, 42, 38, 45, 50, 42];

  @override
  void initState() {
    super.initState();
    _startSoundSimulation();
  }

  void _startSoundSimulation() {
    _soundTimer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      if (_isMeasuringSound) {
        setState(() {
          // Generate realistic ambient sound level fluctuations
          final rand = math.Random();
          _currentDecibels = 38.0 + rand.nextDouble() * 32.0; // Range 38 to 70 dB
          _dbHistory.add(_currentDecibels);
          if (_dbHistory.length > 15) {
            _dbHistory.removeAt(0);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _soundTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate angle in degrees
    final double tiltAngle = math.sqrt(_bubbleX * _bubbleX + _bubbleY * _bubbleY) * 15.0;
    final bool isLevel = tiltAngle < 1.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Level & Acoustic Suite',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Precision alignment gauge and ambient decibel noise monitor',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // SECTION 1: BUBBLE LEVEL
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isLevel ? Colors.green : Colors.blue.shade400, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.crop_free, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          'Surface Level Target',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLevel ? Colors.green.shade800 : Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isLevel ? 'PERFECT LEVEL' : '${tiltAngle.toStringAsFixed(1)}° TILT',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Interactive Level Canvas (Touch to simulate tilting phone)
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _bubbleX = (_bubbleX + details.delta.dx / 100).clamp(-1.0, 1.0);
                      _bubbleY = (_bubbleY + details.delta.dy / 100).clamp(-1.0, 1.0);
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0F172A),
                      border: Border.all(
                        color: isLevel ? Colors.green : Colors.blueAccent,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Crosshair lines
                        const Divider(color: Colors.white70, thickness: 1),
                        const VerticalDivider(color: Colors.white70, thickness: 1),
                        // Inner bullseye ring
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white70, width: 1),
                          ),
                        ),
                        // Moving Bubble Indicator
                        Transform.translate(
                          offset: Offset(_bubbleX * 70, _bubbleY * 70),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isLevel ? Colors.green : Colors.amber,
                              boxShadow: [
                                BoxShadow(
                                  color: isLevel ? Colors.green.withOpacity(0.6) : Colors.amber.withOpacity(0.6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.circle, size: 10, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _bubbleX = 0.0;
                          _bubbleY = 0.0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      child: const Text('CALIBRATE / RESET', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Drag inside target to simulate surface slope',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECTION 2: AUDIO NOISE METER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade400, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.volume_up, color: Colors.greenAccent),
                        SizedBox(width: 8),
                        Text(
                          'Acoustic Decibel Monitor',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isMeasuringSound,
                      activeColor: Colors.greenAccent,
                      onChanged: (val) {
                        setState(() {
                          _isMeasuringSound = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _isMeasuringSound ? _currentDecibels.toStringAsFixed(1) : '--',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'dB (SPL)',
                      style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDecibelSafetyColor(_currentDecibels),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getDecibelSafetyLabel(_currentDecibels),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Visual Sound Bar Graph
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _dbHistory.map((val) {
                      final double heightFactor = (val / 100.0).clamp(0.1, 1.0);
                      return Container(
                        width: 14,
                        height: 60 * heightFactor,
                        decoration: BoxDecoration(
                          color: val > 75 ? Colors.red : (val > 60 ? Colors.amber : Colors.green),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Safe Exposure Threshold: Under 70 dB for prolonged listening.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDecibelSafetyColor(double db) {
    if (db < 55) return Colors.green.shade800;
    if (db < 75) return Colors.amber.shade900;
    return Colors.red.shade900;
  }

  String _getDecibelSafetyLabel(double db) {
    if (db < 55) return 'QUIET & SAFE';
    if (db < 75) return 'MODERATE NOISE';
    return 'HIGH NOISE HAZARD';
  }
}