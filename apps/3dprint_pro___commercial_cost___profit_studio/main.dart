import 'package:flutter/material.dart';

void main() {
  runApp(const PrintCraftApp());
}

class PrintCraftApp extends StatelessWidget {
  const PrintCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3DPrint Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12181B),
        cardTheme: CardTheme(
          color: const Color(0xFF1E282D),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const PrintCraftHomePage(),
    );
  }
}

class PrintJobQuote {
  final String id;
  final String name;
  final String materialName;
  final double totalCost;
  final double sellingPrice;
  final double profit;
  final double printHours;

  PrintJobQuote({
    required this.id,
    required this.name,
    required this.materialName,
    required this.totalCost,
    required this.sellingPrice,
    required this.profit,
    required this.printHours,
  });
}

class PrintCraftHomePage extends StatefulWidget {
  const PrintCraftHomePage({super.key});

  @override
  State<PrintCraftHomePage> createState() => _PrintCraftHomePageState();
}

class _PrintCraftHomePageState extends State<PrintCraftHomePage> {
  // Model & Material Inputs
  String _jobName = "Custom Print Job";
  String _selectedMaterial = "PLA";
  double _spoolPrice = 22.00; // $ per spool
  double _spoolWeightGrams = 1000.0; // grams
  double _printWeightGrams = 145.0; // grams needed for print

  // Machine & Power Inputs
  double _printerPowerWatts = 180.0; // Watts
  double _electricityRateKwh = 0.16; // $ per kWh
  double _printHours = 6.5; // Hours
  double _machineWearRateHour = 0.35; // $ per machine hour

  // Labor & Business Overhead
  double _laborRateHour = 18.00; // $ per hour
  double _prepPostMinutes = 20.0; // Minutes
  double _failureRiskPercent = 10.0; // Risk buffer %
  double _desiredMarginPercent = 35.0; // Target Profit Margin %

  // Saved Quotes
  final List<PrintJobQuote> _savedQuotes = [];

  // Controllers
  late TextEditingController _jobNameController;

  @override
  void initState() {
    super.initState();
    _jobNameController = TextEditingController(text: _jobName);
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    super.dispose();
  }

  // Material Presets
  void _applyMaterialPreset(String material) {
    setState(() {
      _selectedMaterial = material;
      switch (material) {
        case "PLA":
          _spoolPrice = 22.00;
          _spoolWeightGrams = 1000;
          break;
        case "PETG":
          _spoolPrice = 25.00;
          _spoolWeightGrams = 1000;
          break;
        case "ABS":
          _spoolPrice = 24.00;
          _spoolWeightGrams = 1000;
          break;
        case "TPU":
          _spoolPrice = 34.00;
          _spoolWeightGrams = 1000;
          break;
        case "Resin (SLA)":
          _spoolPrice = 38.00;
          _spoolWeightGrams = 1000;
          break;
      }
    });
  }

  // Calculations
  double get _materialCost => (_spoolPrice / _spoolWeightGrams) * _printWeightGrams;
  double get _energyUsedKwh => (_printerPowerWatts / 1000.0) * _printHours;
  double get _energyCost => _energyUsedKwh * _electricityRateKwh;
  double get _wearCost => _machineWearRateHour * _printHours;
  double get _laborCost => _laborRateHour * (_prepPostMinutes / 60.0);
  double get _directCost => _materialCost + _energyCost + _wearCost + _laborCost;
  double get _failureCost => _directCost * (_failureRiskPercent / 100.0);
  double get _totalBaseCost => _directCost + _failureCost;

  // Commercial Pricing: Price = Cost / (1 - Margin%)
  double get _recommendedPrice {
    final marginDecimal = _desiredMarginPercent / 100.0;
    if (marginDecimal >= 1.0) return _totalBaseCost * 2;
    return _totalBaseCost / (1.0 - marginDecimal);
  }

  double get _netProfit => _recommendedPrice - _totalBaseCost;

  void _saveCurrentQuote() {
    final newQuote = PrintJobQuote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _jobNameController.text.trim().isEmpty ? "Print Job" : _jobNameController.text.trim(),
      materialName: _selectedMaterial,
      totalCost: _totalBaseCost,
      sellingPrice: _recommendedPrice,
      profit: _netProfit,
      printHours: _printHours,
    );

    setState(() {
      _savedQuotes.insert(0, newQuote);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote saved successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showQuoteSummaryDialog() {
    final sb = StringBuffer();
    sb.writeln('--- 3D PRINT COST QUOTE ---');
    sb.writeln('Job Name: ${_jobNameController.text}');
    sb.writeln('Material: $_selectedMaterial (${_printWeightGrams.toStringAsFixed(1)} g)');
    sb.writeln('Print Time: ${_printHours.toStringAsFixed(1)} hrs');
    sb.writeln('---------------------------');
    sb.writeln('Material Cost: \$${_materialCost.toStringAsFixed(2)}');
    sb.writeln('Energy Cost: \$${_energyCost.toStringAsFixed(2)}');
    sb.writeln('Machine Wear: \$${_wearCost.toStringAsFixed(2)}');
    sb.writeln('Labor Cost: \$${_laborCost.toStringAsFixed(2)}');
    sb.writeln('Failure Buffer: \$${_failureCost.toStringAsFixed(2)}');
    sb.writeln('---------------------------');
    sb.writeln('Total Base Cost: \$${_totalBaseCost.toStringAsFixed(2)}');
    sb.writeln('Target Selling Price: \$${_recommendedPrice.toStringAsFixed(2)}');
    sb.writeln('Estimated Profit: \$${_netProfit.toStringAsFixed(2)}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.precision_manufacturing, color: Colors.teal),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Commercial Quote Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              sb.toString(),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quote details ready to share!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.precision_manufacturing, color: Colors.tealAccent),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '3DPrint Pro Estimator',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E282D),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Export Quote Summary',
            onPressed: _showQuoteSummaryDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Selling Price & Margin Highlight Card
              _buildPriceHighlightCard(),

              const SizedBox(height: 20),

              // Job Title Input
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _jobNameController,
                    decoration: const InputDecoration(
                      labelText: 'Print Job / Project Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit_note, color: Colors.teal),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _jobName = val;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Filament / Material Section
              _buildSectionCard(
                title: '1. Material & Spool Settings',
                icon: Icons.layers,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Material Type Preset:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ["PLA", "PETG", "ABS", "TPU", "Resin (SLA)"].map((material) {
                        final isSelected = _selectedMaterial == material;
                        return ChoiceChip(
                          label: Text(material),
                          selected: isSelected,
                          selectedColor: Colors.teal,
                          onSelected: (bool selected) {
                            if (selected) _applyMaterialPreset(material);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberInput(
                            label: 'Spool Cost (\$) ',
                            value: _spoolPrice,
                            onChanged: (val) => setState(() => _spoolPrice = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberInput(
                            label: 'Spool Net (g)',
                            value: _spoolWeightGrams,
                            onChanged: (val) => setState(() => _spoolWeightGrams = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSliderTile(
                      label: 'Model Print Weight',
                      value: _printWeightGrams,
                      unit: 'g',
                      min: 1,
                      max: 1000,
                      divisions: 999,
                      onChanged: (val) => setState(() => _printWeightGrams = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Time, Energy & Machine Depreciation Section
              _buildSectionCard(
                title: '2. Printer, Time & Electricity',
                icon: Icons.bolt,
                child: Column(
                  children: [
                    _buildSliderTile(
                      label: 'Print Duration',
                      value: _printHours,
                      unit: 'hrs',
                      min: 0.5,
                      max: 48.0,
                      divisions: 95,
                      onChanged: (val) => setState(() => _printHours = val),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberInput(
                            label: 'Power (Watts)',
                            value: _printerPowerWatts,
                            onChanged: (val) => setState(() => _printerPowerWatts = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberInput(
                            label: 'Electric (\$/kWh)',
                            value: _electricityRateKwh,
                            onChanged: (val) => setState(() => _electricityRateKwh = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildNumberInput(
                      label: 'Machine Wear/Depreciation (\$/hour)',
                      value: _machineWearRateHour,
                      onChanged: (val) => setState(() => _machineWearRateHour = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Labor, Risk & Margin Section
              _buildSectionCard(
                title: '3. Labor, Risk & Profit Margin',
                icon: Icons.attach_money,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberInput(
                            label: 'Labor Rate (\$/hr)',
                            value: _laborRateHour,
                            onChanged: (val) => setState(() => _laborRateHour = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberInput(
                            label: 'Prep/Post (Mins)',
                            value: _prepPostMinutes,
                            onChanged: (val) => setState(() => _prepPostMinutes = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSliderTile(
                      label: 'Failure Risk Buffer',
                      value: _failureRiskPercent,
                      unit: '%',
                      min: 0,
                      max: 30,
                      divisions: 30,
                      onChanged: (val) => setState(() => _failureRiskPercent = val),
                    ),
                    const SizedBox(height: 16),
                    _buildSliderTile(
                      label: 'Target Profit Margin',
                      value: _desiredMarginPercent,
                      unit: '%',
                      min: 5,
                      max: 80,
                      divisions: 75,
                      onChanged: (val) => setState(() => _desiredMarginPercent = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Detailed Itemized Cost Breakdown Card
              _buildCostBreakdownCard(),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveCurrentQuote,
                      icon: const Icon(Icons.bookmark_add, color: Colors.white),
                      label: const FittedBox(
                        child: Text(
                          'Save Quote',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.teal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _showQuoteSummaryDialog,
                      icon: const Icon(Icons.receipt_long, color: Colors.tealAccent),
                      label: const FittedBox(
                        child: Text(
                          'View Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Saved Quotes History
              if (_savedQuotes.isNotEmpty) _buildSavedQuotesSection(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildPriceHighlightCard() {
    return Card(
      color: const Color(0xFF163832),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'RECOMMENDED SELLING PRICE',
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: Text(
                '\$${_recommendedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.extrabold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriceStat('Total Base Cost', '\$${_totalBaseCost.toStringAsFixed(2)}'),
                Container(height: 30, width: 1, color: Colors.white24),
                _buildPriceStat('Net Profit', '\$${_netProfit.toStringAsFixed(2)}', isHighlight: true),
                Container(height: 30, width: 1, color: Colors.white24),
                _buildPriceStat('Margin', '${_desiredMarginPercent.toStringAsFixed(0)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceStat(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.tealAccent : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.tealAccent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1)} $unit',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: Colors.teal,
          inactiveColor: Colors.white12,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNumberInput({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      onChanged: (val) {
        final parsed = double.tryParse(val);
        if (parsed != null && parsed >= 0) {
          onChanged(parsed);
        }
      },
    );
  }

  Widget _buildCostBreakdownCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.analytics, color: Colors.tealAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Itemized Cost Distribution',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildCostRow('Filament Material Cost', _materialCost),
            _buildCostRow('Power Electricity Cost', _energyCost),
            _buildCostRow('Machine Wear & Tear', _wearCost),
            _buildCostRow('Operator Labor Cost', _laborCost),
            _buildCostRow('Failure Risk Buffer (${_failureRiskPercent.toStringAsFixed(0)}%)', _failureCost),
            const Divider(height: 20),
            _buildCostRow('Total Base Cost', _totalBaseCost, isBold: true),
            _buildCostRow('Profit Margin Added', _netProfit, isBold: true, textColor: Colors.tealAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedQuotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saved Quotes History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _savedQuotes.length,
          itemBuilder: (ctx, idx) {
            final quote = _savedQuotes[idx];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.print, color: Colors.white, size: 20),
                ),
                title: Text(
                  quote.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${quote.materialName} • ${quote.printHours.toStringAsFixed(1)} hrs',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${quote.sellingPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Cost: \$${quote.totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 11, color: Colors.white54),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          _savedQuotes.removeAt(idx);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}