import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const SpoolCraftApp());
}

class SpoolCraftApp extends StatelessWidget {
  const SpoolCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpoolCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181B),
        cardTheme: CardTheme(
          color: const Color(0xFF1E262C),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const SpoolCraftHomeScreen(),
    );
  }
}

class MaterialPreset {
  final String name;
  final double density; // g/cm³
  final IconData icon;

  const MaterialPreset({
    required this.name,
    required this.density,
    required this.icon,
  });
}

class SpoolCraftHomeScreen extends StatefulWidget {
  const SpoolCraftHomeScreen({super.key});

  @override
  State<SpoolCraftHomeScreen> createState() => _SpoolCraftHomeScreenState();
}

class _SpoolCraftHomeScreenState extends State<SpoolCraftHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Presets
  final List<MaterialPreset> _presets = const [
    MaterialPreset(name: 'PLA', density: 1.24, icon: Icons.layers),
    MaterialPreset(name: 'PETG', density: 1.27, icon: Icons.precision_manufacturing),
    MaterialPreset(name: 'ABS', density: 1.04, icon: Icons.build),
    MaterialPreset(name: 'TPU', density: 1.21, icon: Icons.tune),
  ];

  late MaterialPreset _selectedPreset;
  double _filamentDiameter = 1.75; // mm

  // Controllers
  final _spoolCostController = TextEditingController(text: '24.99');
  final _spoolWeightController = TextEditingController(text: '1000');
  final _printWeightController = TextEditingController(text: '85');
  final _printHoursController = TextEditingController(text: '4');
  final _printMinsController = TextEditingController(text: '30');
  final _printerWattageController = TextEditingController(text: '220');
  final _electricityRateController = TextEditingController(text: '0.15');
  final _laborRateController = TextEditingController(text: '20.00');
  final _laborMinsController = TextEditingController(text: '15');
  final _failMarginController = TextEditingController(text: '10');
  final _batchQtyController = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedPreset = _presets[0];

    // Add listeners to rebuild UI on change
    _spoolCostController.addListener(_updateState);
    _spoolWeightController.addListener(_updateState);
    _printWeightController.addListener(_updateState);
    _printHoursController.addListener(_updateState);
    _printMinsController.addListener(_updateState);
    _printerWattageController.addListener(_updateState);
    _electricityRateController.addListener(_updateState);
    _laborRateController.addListener(_updateState);
    _laborMinsController.addListener(_updateState);
    _failMarginController.addListener(_updateState);
    _batchQtyController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _spoolCostController.dispose();
    _spoolWeightController.dispose();
    _printWeightController.dispose();
    _printHoursController.dispose();
    _printMinsController.dispose();
    _printerWattageController.dispose();
    _electricityRateController.dispose();
    _laborRateController.dispose();
    _laborMinsController.dispose();
    _failMarginController.dispose();
    _batchQtyController.dispose();
    super.dispose();
  }

  void _resetDefaults() {
    setState(() {
      _selectedPreset = _presets[0];
      _filamentDiameter = 1.75;
      _spoolCostController.text = '24.99';
      _spoolWeightController.text = '1000';
      _printWeightController.text = '85';
      _printHoursController.text = '4';
      _printMinsController.text = '30';
      _printerWattageController.text = '220';
      _electricityRateController.text = '0.15';
      _laborRateController.text = '20.00';
      _laborMinsController.text = '15';
      _failMarginController.text = '10';
      _batchQtyController.text = '5';
    });
  }

  // Calculation getters
  double get _spoolCost => double.tryParse(_spoolCostController.text) ?? 0.0;
  double get _spoolWeight => double.tryParse(_spoolWeightController.text) ?? 1.0;
  double get _printWeight => double.tryParse(_printWeightController.text) ?? 0.0;
  double get _printHours => double.tryParse(_printHoursController.text) ?? 0.0;
  double get _printMins => double.tryParse(_printMinsController.text) ?? 0.0;
  double get _printerWattage => double.tryParse(_printerWattageController.text) ?? 0.0;
  double get _electricityRate => double.tryParse(_electricityRateController.text) ?? 0.0;
  double get _laborRate => double.tryParse(_laborRateController.text) ?? 0.0;
  double get _laborMins => double.tryParse(_laborMinsController.text) ?? 0.0;
  double get _failMargin => double.tryParse(_failMarginController.text) ?? 0.0;
  int get _batchQty => math.max(1, int.tryParse(_batchQtyController.text) ?? 1);

  double get _totalPrintTimeHours => _printHours + (_printMins / 60.0);

  // Material cost calculation
  double get _materialCost {
    if (_spoolWeight <= 0) return 0.0;
    return (_printWeight / _spoolWeight) * _spoolCost;
  }

  // Electricity cost
  double get _electricityCost {
    final kwh = (_printerWattage / 1000.0) * _totalPrintTimeHours;
    return kwh * _electricityRate;
  }

  // Labor cost
  double get _laborCost {
    return (_laborMins / 60.0) * _laborRate;
  }

  // Subtotal without risk margin
  double get _subtotalCost => _materialCost + _electricityCost + _laborCost;

  // Fail risk cost addition
  double get _riskCost => _subtotalCost * (_failMargin / 100.0);

  // Total Cost per single unit
  double get _unitTotalCost => _subtotalCost + _riskCost;

  // Total Batch Cost
  double get _batchTotalCost => _unitTotalCost * _batchQty;

  // Estimated Length in Meters
  double get _filamentLengthMeters {
    if (_printWeight <= 0) return 0.0;
    final radiusCm = (_filamentDiameter / 10.0) / 2.0;
    final volumeCm3 = _printWeight / _selectedPreset.density;
    final areaCm2 = math.pi * radiusCm * radiusCm;
    final lengthCm = volumeCm3 / areaCm2;
    return lengthCm / 100.0;
  }

  // Remaining prints from a fresh spool
  int get _printsPerSpool {
    if (_printWeight <= 0) return 0;
    return (_spoolWeight / _printWeight).floor();
  }

  // Percentage of spool used
  double get _spoolUsedPercent {
    if (_spoolWeight <= 0) return 0.0;
    return math.min(100.0, (_printWeight / _spoolWeight) * 100.0);
  }

  void _copyQuoteSummary() {
    final buffer = StringBuffer();
    buffer.writeln('=== SpoolCraft Print Cost Quote ===');
    buffer.writeln('Material: ${_selectedPreset.name} ($_filamentDiameter mm)');
    buffer.writeln('Print Weight: ${_printWeight.toStringAsFixed(1)} g (${_filamentLengthMeters.toStringAsFixed(2)} m)');
    buffer.writeln('Print Time: ${_printHours.toInt()}h ${_printMins.toInt()}m');
    buffer.writeln('-----------------------------------');
    buffer.writeln('Material Cost: \$${_materialCost.toStringAsFixed(2)}');
    buffer.writeln('Electricity Cost: \$${_electricityCost.toStringAsFixed(2)}');
    buffer.writeln('Labor Fee: \$${_laborCost.toStringAsFixed(2)}');
    buffer.writeln('Risk Margin (${_failMargin.toStringAsFixed(0)}%): \$${_riskCost.toStringAsFixed(2)}');
    buffer.writeln('-----------------------------------');
    buffer.writeln('Unit Price: \$${_unitTotalCost.toStringAsFixed(2)}');
    buffer.writeln('Batch Total (${_batchQty}x): \$${_batchTotalCost.toStringAsFixed(2)}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote summary prepared! Total: \$${_batchTotalCost.toStringAsFixed(2)}'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.precision_manufacturing, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'SpoolCraft Studio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset All Fields',
            onPressed: _resetDefaults,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy Quote',
            onPressed: _copyQuoteSummary,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Batch & Breakdowns'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCalculatorTab(colorScheme),
            _buildBreakdownTab(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorTab(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickSummaryCard(colorScheme),
          const SizedBox(height: 16),
          _buildMaterialSection(colorScheme),
          const SizedBox(height: 16),
          _buildSpoolAndPrintSection(colorScheme),
          const SizedBox(height: 16),
          _buildPowerAndLaborSection(colorScheme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickSummaryCard(ColorScheme colorScheme) {
    return Card(
      color: colorScheme.primaryContainer.withAlpha(50),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary.withAlpha(100)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Unit Cost',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${_unitTotalCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Batch (${_batchQty}x) Total',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${_batchTotalCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Colors.white12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildMiniBadge(
                  icon: Icons.straighten,
                  label: '${_filamentLengthMeters.toStringAsFixed(1)} m required',
                ),
                _buildMiniBadge(
                  icon: Icons.inventory_2,
                  label: '$_printsPerSpool prints/spool',
                ),
                _buildMiniBadge(
                  icon: Icons.pie_chart_outline,
                  label: '${_spoolUsedPercent.toStringAsFixed(1)}% spool used',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.tealAccent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialSection(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.layers, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Filament Type & Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: _presets.map((preset) {
                final isSelected = _selectedPreset.name == preset.name;
                return ChoiceChip(
                  avatar: Icon(
                    preset.icon,
                    size: 16,
                    color: isSelected ? Colors.black : Colors.white70,
                  ),
                  label: Text(preset.name),
                  selected: isSelected,
                  selectedColor: colorScheme.primary,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPreset = preset;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filament Diameter',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ),
                SegmentedButton<double>(
                  segments: const [
                    ButtonSegment(value: 1.75, label: Text('1.75 mm')),
                    ButtonSegment(value: 2.85, label: Text('2.85 mm')),
                  ],
                  selected: {_filamentDiameter},
                  onSelectionChanged: (set) {
                    setState(() {
                      _filamentDiameter = set.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Density: ${_selectedPreset.density} g/cm³',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpoolAndPrintSection(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Spool & Model Metrics',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _spoolCostController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Spool Price (\$)',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _spoolWeightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Spool Net (g)',
                      border: OutlineInputBorder(),
                      suffixText: 'g',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _printWeightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Print Weight (g)',
                      border: OutlineInputBorder(),
                      suffixText: 'g',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _batchQtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Batch Quantity',
                      border: OutlineInputBorder(),
                      suffixText: 'pcs',
                    ),
                  ),
                ),
              ],
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
                      border: OutlineInputBorder(),
                      suffixText: 'hrs',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _printMinsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Print Minutes',
                      border: OutlineInputBorder(),
                      suffixText: 'mins',
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

  Widget _buildPowerAndLaborSection(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Power, Labor & Risk Margin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _printerWattageController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Printer Power',
                      border: OutlineInputBorder(),
                      suffixText: 'W',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _electricityRateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Utility Rate',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      suffixText: '/kWh',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _laborRateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Labor Rate',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      suffixText: '/hr',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _laborMinsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Prep/Post Labor',
                      border: OutlineInputBorder(),
                      suffixText: 'mins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _failMarginController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Fail / Risk Margin Allowance (%)',
                border: OutlineInputBorder(),
                suffixText: '%',
                helperText: 'Covers print failures, nozzle purges, and bed adhesive prep',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownTab(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemizedBreakdownCard(colorScheme),
          const SizedBox(height: 16),
          _buildSpoolDepletionCard(colorScheme),
          const SizedBox(height: 16),
          _buildBatchPricingMatrixCard(colorScheme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildItemizedBreakdownCard(ColorScheme colorScheme) {
    final maxCost = math.max(
      _materialCost,
      math.max(_electricityCost, math.max(_laborCost, _riskCost)),
    );
    final safeMaxCost = maxCost <= 0 ? 1.0 : maxCost;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Itemized Single-Unit Cost Split',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCostBarRow('Filament Material', _materialCost, Colors.teal, safeMaxCost),
            const SizedBox(height: 12),
            _buildCostBarRow('Electricity Energy', _electricityCost, Colors.amber, safeMaxCost),
            const SizedBox(height: 12),
            _buildCostBarRow('Prep & Post Labor', _laborCost, Colors.blue, safeMaxCost),
            const SizedBox(height: 12),
            _buildCostBarRow('Failure Margin (${_failMargin.toStringAsFixed(0)}%)', _riskCost, Colors.deepOrange, safeMaxCost),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Single Unit Cost', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '\$${_unitTotalCost.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBarRow(String label, double amount, Color barColor, double maxCost) {
    final ratio = (amount / maxCost).clamp(0.05, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 8,
                  width: constraints.maxWidth * ratio,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpoolDepletionCard(ColorScheme colorScheme) {
    final usedFraction = (_spoolUsedPercent / 100.0).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Spool Usage & Capacity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: usedFraction,
                minHeight: 12,
                backgroundColor: Colors.white12,
                color: usedFraction > 0.9 ? Colors.redAccent : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Per Print: ${_printWeight.toStringAsFixed(1)} g / ${_spoolWeight.toStringAsFixed(0)} g',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${_spoolUsedPercent.toStringAsFixed(1)}% of spool',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatMetric('Max Yield', '$_printsPerSpool pcs', Icons.inventory),
                _buildStatMetric('Wire Length', '${_filamentLengthMeters.toStringAsFixed(1)} m', Icons.straighten),
                _buildStatMetric('Density', '${_selectedPreset.density} g/cm³', Icons.bubble_chart),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.tealAccent),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildBatchPricingMatrixCard(ColorScheme colorScheme) {
    final batchSizes = [1, 5, 10, 25, 50];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grid_on, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Batch Tier Quotation Matrix',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: batchSizes.map((qty) {
                final batchPrice = _unitTotalCost * qty;
                final isCurrent = qty == _batchQty;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCurrent ? colorScheme.primary.withAlpha(40) : Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent ? colorScheme.primary : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCurrent ? Icons.check_circle : Icons.layers_outlined,
                            size: 16,
                            color: isCurrent ? colorScheme.primary : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text('$qty unit${qty > 1 ? "s" : ""} batch'),
                        ],
                      ),
                      Text(
                        '\$${batchPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.tealAccent : Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}