import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MakerCostApp());
}

class MakerCostApp extends StatelessWidget {
  const MakerCostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MakerCost Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainHomeScreen(),
    );
  }
}

class SavedQuote {
  final String title;
  final double totalCost;
  final double sellingPrice;
  final double profit;
  final DateTime date;

  SavedQuote({
    required this.title,
    required this.totalCost,
    required this.sellingPrice,
    required this.profit,
    required this.date,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Form Controllers
  final TextEditingController _projectNameController =
      TextEditingController(text: 'Custom 3D Model Print');
  final TextEditingController _spoolCostController =
      TextEditingController(text: '24.99');
  final TextEditingController _spoolWeightController =
      TextEditingController(text: '1000');
  final TextEditingController _usedWeightController =
      TextEditingController(text: '120');

  final TextEditingController _printHoursController =
      TextEditingController(text: '6');
  final TextEditingController _printMinutesController =
      TextEditingController(text: '30');

  final TextEditingController _powerWattageController =
      TextEditingController(text: '210');
  final TextEditingController _electricityRateController =
      TextEditingController(text: '0.16');

  final TextEditingController _wearRateController =
      TextEditingController(text: '0.40');
  final TextEditingController _laborRateController =
      TextEditingController(text: '18.00');
  final TextEditingController _laborMinutesController =
      TextEditingController(text: '25');

  double _markupPercentage = 80.0;
  double _failRatePercentage = 8.0;

  final List<SavedQuote> _savedQuotes = [
    SavedQuote(
      title: 'Headphone Stand (PLA)',
      totalCost: 6.45,
      sellingPrice: 18.00,
      profit: 11.55,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SavedQuote(
      title: 'Articulated Dragon',
      totalCost: 8.20,
      sellingPrice: 24.99,
      profit: 16.79,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _spoolCostController.dispose();
    _spoolWeightController.dispose();
    _usedWeightController.dispose();
    _printHoursController.dispose();
    _printMinutesController.dispose();
    _powerWattageController.dispose();
    _electricityRateController.dispose();
    _wearRateController.dispose();
    _laborRateController.dispose();
    _laborMinutesController.dispose();
    super.dispose();
  }

  // Calculations
  double get _spoolCost => double.tryParse(_spoolCostController.text) ?? 0.0;
  double get _spoolWeight => double.tryParse(_spoolWeightController.text) ?? 1.0;
  double get _usedWeight => double.tryParse(_usedWeightController.text) ?? 0.0;

  double get _printHours =>
      (double.tryParse(_printHoursController.text) ?? 0.0) +
      ((double.tryParse(_printMinutesController.text) ?? 0.0) / 60.0);

  double get _powerWattage => double.tryParse(_powerWattageController.text) ?? 0.0;
  double get _electricityRate =>
      double.tryParse(_electricityRateController.text) ?? 0.0;

  double get _wearRate => double.tryParse(_wearRateController.text) ?? 0.0;
  double get _laborRate => double.tryParse(_laborRateController.text) ?? 0.0;
  double get _laborHours =>
      (double.tryParse(_laborMinutesController.text) ?? 0.0) / 60.0;

  double get _baseMaterialCost {
    if (_spoolWeight <= 0) return 0.0;
    return (_spoolCost / _spoolWeight) * _usedWeight;
  }

  double get _materialCostWithFailure {
    return _baseMaterialCost * (1.0 + (_failRatePercentage / 100.0));
  }

  double get _electricityCost {
    final kwh = (_powerWattage / 1000.0) * _printHours;
    return kwh * _electricityRate;
  }

  double get _machineWearCost => _printHours * _wearRate;

  double get _laborCost => _laborHours * _laborRate;

  double get _totalDirectCost =>
      _materialCostWithFailure + _electricityCost + _machineWearCost + _laborCost;

  double get _recommendedPrice =>
      _totalDirectCost * (1.0 + (_markupPercentage / 100.0));

  double get _netProfit => _recommendedPrice - _totalDirectCost;

  void _applyPreset(String presetType) {
    setState(() {
      if (presetType == 'PLA Standard') {
        _spoolCostController.text = '22.00';
        _spoolWeightController.text = '1000';
        _powerWattageController.text = '180';
        _wearRateController.text = '0.30';
      } else if (presetType == 'Resin (SLA)') {
        _spoolCostController.text = '38.00';
        _spoolWeightController.text = '1000';
        _powerWattageController.text = '60';
        _wearRateController.text = '0.75';
      } else if (presetType == 'PETG / Tough') {
        _spoolCostController.text = '28.50';
        _spoolWeightController.text = '1000';
        _powerWattageController.text = '240';
        _wearRateController.text = '0.45';
      } else if (presetType == 'Laser / CNC') {
        _spoolCostController.text = '15.00';
        _spoolWeightController.text = '500';
        _powerWattageController.text = '450';
        _wearRateController.text = '1.20';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied preset: $presetType'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _saveCurrentProject() {
    if (_projectNameController.text.trim().isEmpty) return;
    setState(() {
      _savedQuotes.insert(
        0,
        SavedQuote(
          title: _projectNameController.text.trim(),
          totalCost: _totalDirectCost,
          sellingPrice: _recommendedPrice,
          profit: _netProfit,
          date: DateTime.now(),
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project estimate saved successfully!')),
    );
  }

  void _copyCustomerQuote() {
    final sb = StringBuffer();
    sb.writeln('=== QUOTE BREAKDOWN ===');
    sb.writeln('Item: ${_projectNameController.text}');
    sb.writeln('Print/Production Time: ${_printHours.toStringAsFixed(1)} hours');
    sb.writeln('----------------------------------');
    sb.writeln('Estimated Price: \$${_recommendedPrice.toStringAsFixed(2)}');
    sb.writeln('Includes: High-grade material, machine time, & quality check.');
    sb.writeln('Thank you for supporting custom makers!');

    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer quote copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.precision_manufacturing, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'MakerCost Pro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Copy Quote Summary',
            onPressed: _copyCustomerQuote,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Save Project',
            onPressed: _saveCurrentProject,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildCalculatorTab(theme),
          _buildAnalysisTab(theme),
          _buildHistoryTab(theme),
        ],
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
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.donut_large_outlined),
            selectedIcon: Icon(Icons.donut_large),
            label: 'Breakdown',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Saved Quotes',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: CALCULATOR ---
  Widget _buildCalculatorTab(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Summary Header Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _projectNameController.text.isEmpty
                              ? 'Custom Project'
                              : _projectNameController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '+${_markupPercentage.toStringAsFixed(0)}% Margin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        'Production Cost',
                        '\$${_totalDirectCost.toStringAsFixed(2)}',
                        Colors.white70,
                      ),
                      Container(
                        height: 35,
                        width: 1,
                        color: Colors.white30,
                      ),
                      _buildHeaderStat(
                        'Selling Price',
                        '\$${_recommendedPrice.toStringAsFixed(2)}',
                        Colors.amberAccent,
                      ),
                      Container(
                        height: 35,
                        width: 1,
                        color: Colors.white30,
                      ),
                      _buildHeaderStat(
                        'Net Profit',
                        '\$${_netProfit.toStringAsFixed(2)}',
                        Colors.greenAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Material Presets
            Text(
              'Quick Material Presets',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('PLA Standard', Icons.widgets),
                  _buildPresetChip('PETG / Tough', Icons.build),
                  _buildPresetChip('Resin (SLA)', Icons.opacity),
                  _buildPresetChip('Laser / CNC', Icons.precision_manufacturing),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Project Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Project & Material Specs',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _projectNameController,
                      decoration: const InputDecoration(
                        labelText: 'Project / Item Name',
                        prefixIcon: Icon(Icons.edit),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _spoolCostController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Spool/Stock Cost (\$) *',
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _spoolWeightController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Total Spool (g)',
                              prefixIcon: Icon(Icons.scale),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _usedWeightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Model Used Weight (grams)',
                        prefixIcon: Icon(Icons.hardware),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Machine & Power Specs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Machine Time & Energy',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _printHoursController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Print Hours',
                              prefixIcon: Icon(Icons.timer),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _printMinutesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Print Minutes',
                              prefixIcon: Icon(Icons.schedule),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _powerWattageController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Power (Watts)',
                              prefixIcon: Icon(Icons.bolt),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _electricityRateController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Rate (\$/kWh)',
                              prefixIcon: Icon(Icons.power),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Overhead & Labor Specs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Labor & Machine Wear',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _laborRateController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Labor Rate (\$/hr)',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _laborMinutesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Prep/Post Min',
                              prefixIcon: Icon(Icons.handyman),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _wearRateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Machine Wear Overhead (\$/hr)',
                        prefixIcon: Icon(Icons.build_circle),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Profit & Buffer Sliders
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Markup & Failure Safety Buffer',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Desired Profit Markup:'),
                        Text(
                          '${_markupPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _markupPercentage,
                      min: 0,
                      max: 300,
                      divisions: 60,
                      label: '${_markupPercentage.toStringAsFixed(0)}%',
                      onChanged: (val) {
                        setState(() {
                          _markupPercentage = val;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Print Failure Buffer:'),
                        Text(
                          '${_failRatePercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _failRatePercentage,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: Colors.deepOrange,
                      label: '${_failRatePercentage.toStringAsFixed(0)}%',
                      onChanged: (val) {
                        setState(() {
                          _failRatePercentage = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    icon: const Icon(Icons.content_copy),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Copy Customer Quote'),
                    ),
                    onPressed: _copyCustomerQuote,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.bookmark),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Save Project'),
                    ),
                    onPressed: _saveCurrentProject,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(title),
        onPressed: () => _applyPreset(title),
      ),
    );
  }

  // --- TAB 2: BREAKDOWN ANALYSIS ---
  Widget _buildAnalysisTab(ThemeData theme) {
    final double material = _materialCostWithFailure;
    final double power = _electricityCost;
    final double wear = _machineWearCost;
    final double labor = _laborCost;
    final double total = _totalDirectCost == 0 ? 1 : _totalDirectCost;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Cost Distribution',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'See exactly where your production money is spent per unit.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Cost Visual Stack Bar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cost Breakdown Bar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 24,
                        child: Row(
                          children: [
                            if (material > 0)
                              Expanded(
                                flex: (material / total * 100).round(),
                                child: Container(color: Colors.blue),
                              ),
                            if (power > 0)
                              Expanded(
                                flex: (power / total * 100).round(),
                                child: Container(color: Colors.amber),
                              ),
                            if (wear > 0)
                              Expanded(
                                flex: (wear / total * 100).round(),
                                child: Container(color: Colors.purple),
                              ),
                            if (labor > 0)
                              Expanded(
                                flex: (labor / total * 100).round(),
                                child: Container(color: Colors.teal),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCostItem(
                      'Filament/Material (Inc. Buffer)',
                      '\$${material.toStringAsFixed(2)}',
                      '${(material / total * 100).toStringAsFixed(1)}%',
                      Colors.blue,
                    ),
                    const Divider(),
                    _buildCostItem(
                      'Electricity Consumption',
                      '\$${power.toStringAsFixed(2)}',
                      '${(power / total * 100).toStringAsFixed(1)}%',
                      Colors.amber,
                    ),
                    const Divider(),
                    _buildCostItem(
                      'Machine Depreciation & Wear',
                      '\$${wear.toStringAsFixed(2)}',
                      '${(wear / total * 100).toStringAsFixed(1)}%',
                      Colors.purple,
                    ),
                    const Divider(),
                    _buildCostItem(
                      'Prep & Post Labor',
                      '\$${labor.toStringAsFixed(2)}',
                      '${(labor / total * 100).toStringAsFixed(1)}%',
                      Colors.teal,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tier Pricing Table
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sell, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Suggested Retail Pricing Tiers',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPricingTier(
                      'Break-Even (0% Profit)',
                      _totalDirectCost,
                      'Covers raw costs only',
                      Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    _buildPricingTier(
                      'Etsy Friendly (50% Markup)',
                      _totalDirectCost * 1.5,
                      'Good for competitive online listings',
                      Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _buildPricingTier(
                      'Standard Maker (100% Markup)',
                      _totalDirectCost * 2.0,
                      'Recommended for custom maker work',
                      Colors.green,
                    ),
                    const SizedBox(height: 8),
                    _buildPricingTier(
                      'Rush Job / Premium (200% Markup)',
                      _totalDirectCost * 3.0,
                      'High urgency or custom CAD design',
                      Colors.deepOrange,
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

  Widget _buildCostItem(
      String title, String amount, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingTier(
      String title, double price, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: SAVED QUOTES & HISTORY ---
  Widget _buildHistoryTab(ThemeData theme) {
    return SafeArea(
      child: _savedQuotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('No saved projects yet.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    child: const Text('Calculate a Project'),
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _savedQuotes.length,
              itemBuilder: (context, index) {
                final item = _savedQuotes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile,
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Cost: \$${item.totalCost.toStringAsFixed(2)} • Saved ${item.date.day}/${item.date.month}/${item.date.year}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${item.sellingPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '+\$${item.profit.toStringAsFixed(2)} net',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}