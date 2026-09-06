import 'package:flutter/material.dart';

void main() {
  runApp(const PrintCostApp());
}

class PrintCostApp extends StatelessWidget {
  const PrintCostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Print Cost Lab',
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
      home: const MainCalculatorScreen(),
    );
  }
}

class MaterialPreset {
  final String name;
  final double defaultSpoolCost;
  final double defaultSpoolWeight; // grams
  final Color badgeColor;

  const MaterialPreset({
    required this.name,
    required this.defaultSpoolCost,
    required this.defaultSpoolWeight,
    required this.badgeColor,
  });
}

class SavedJob {
  final String title;
  final double totalCost;
  final double retailPrice;
  final double printTimeHours;
  final String materialName;

  SavedJob({
    required this.title,
    required this.totalCost,
    required this.retailPrice,
    required this.printTimeHours,
    required this.materialName,
  });
}

class MainCalculatorScreen extends StatefulWidget {
  const MainCalculatorScreen({super.key});

  @override
  State<MainCalculatorScreen> createState() => _MainCalculatorScreenState();
}

class _MainCalculatorScreenState extends State<MainCalculatorScreen> {
  int _currentTab = 0;

  // Material Presets
  final List<MaterialPreset> _presets = const [
    MaterialPreset(name: 'PLA', defaultSpoolCost: 22.0, defaultSpoolWeight: 1000, badgeColor: Colors.teal),
    MaterialPreset(name: 'PETG', defaultSpoolCost: 25.0, defaultSpoolWeight: 1000, badgeColor: Colors.blue),
    MaterialPreset(name: 'ABS', defaultSpoolCost: 24.0, defaultSpoolWeight: 1000, badgeColor: Colors.orange),
    MaterialPreset(name: 'TPU', defaultSpoolCost: 32.0, defaultSpoolWeight: 800, badgeColor: Colors.purple),
    MaterialPreset(name: 'Resin', defaultSpoolCost: 38.0, defaultSpoolWeight: 1000, badgeColor: Colors.amber),
  ];

  int _selectedPresetIndex = 0;

  // Form Controllers
  final TextEditingController _jobTitleController = TextEditingController(text: 'Custom Model Part');
  final TextEditingController _spoolCostController = TextEditingController(text: '22.00');
  final TextEditingController _spoolWeightController = TextEditingController(text: '1000');
  final TextEditingController _usedWeightController = TextEditingController(text: '145');
  final TextEditingController _printHoursController = TextEditingController(text: '5');
  final TextEditingController _printMinutesController = TextEditingController(text: '30');
  final TextEditingController _printerWattsController = TextEditingController(text: '200');
  final TextEditingController _electricityRateController = TextEditingController(text: '0.15');
  final TextEditingController _machineDepreciationController = TextEditingController(text: '0.25');
  final TextEditingController _laborMinutesController = TextEditingController(text: '20');
  final TextEditingController _laborRateController = TextEditingController(text: '18.00');

  double _failureMarginPercent = 10.0;
  double _profitMarginPercent = 40.0;

  final List<SavedJob> _savedJobs = [];

  void _applyPreset(int index) {
    setState(() {
      _selectedPresetIndex = index;
      _spoolCostController.text = _presets[index].defaultSpoolCost.toStringAsFixed(2);
      _spoolWeightController.text = _presets[index].defaultSpoolWeight.toStringAsFixed(0);
    });
  }

  // Cost Calculations
  double get _filamentCost {
    final spoolCost = double.tryParse(_spoolCostController.text) ?? 0.0;
    final spoolWeight = double.tryParse(_spoolWeightController.text) ?? 1.0;
    final usedWeight = double.tryParse(_usedWeightController.text) ?? 0.0;
    if (spoolWeight <= 0) return 0.0;
    return (spoolCost / spoolWeight) * usedWeight;
  }

  double get _totalPrintHours {
    final h = double.tryParse(_printHoursController.text) ?? 0.0;
    final m = double.tryParse(_printMinutesController.text) ?? 0.0;
    return h + (m / 60.0);
  }

  double get _energyCost {
    final watts = double.tryParse(_printerWattsController.text) ?? 0.0;
    final rateKwh = double.tryParse(_electricityRateController.text) ?? 0.0;
    final kw = watts / 1000.0;
    return _totalPrintHours * kw * rateKwh;
  }

  double get _machineWearCost {
    final ratePerHour = double.tryParse(_machineDepreciationController.text) ?? 0.0;
    return _totalPrintHours * ratePerHour;
  }

  double get _laborCost {
    final mins = double.tryParse(_laborMinutesController.text) ?? 0.0;
    final hourlyRate = double.tryParse(_laborRateController.text) ?? 0.0;
    return (mins / 60.0) * hourlyRate;
  }

  double get _rawSubtotal {
    return _filamentCost + _energyCost + _machineWearCost + _laborCost;
  }

  double get _failureCost {
    return _rawSubtotal * (_failureMarginPercent / 100.0);
  }

  double get _totalBaseCost {
    return _rawSubtotal + _failureCost;
  }

  double get _suggestedPrice {
    return _totalBaseCost * (1.0 + (_profitMarginPercent / 100.0));
  }

  double get _netProfit {
    return _suggestedPrice - _totalBaseCost;
  }

  void _saveCurrentJob() {
    final title = _jobTitleController.text.trim().isEmpty ? 'Untitled Print' : _jobTitleController.text.trim();
    setState(() {
      _savedJobs.insert(
        0,
        SavedJob(
          title: title,
          totalCost: _totalBaseCost,
          retailPrice: _suggestedPrice,
          printTimeHours: _totalPrintHours,
          materialName: _presets[_selectedPresetIndex].name,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved "$title" to calculation history!'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _jobTitleController.text = 'Custom Model Part';
      _usedWeightController.text = '100';
      _printHoursController.text = '4';
      _printMinutesController.text = '0';
      _laborMinutesController.text = '15';
      _failureMarginPercent = 10.0;
      _profitMarginPercent = 40.0;
    });
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _spoolCostController.dispose();
    _spoolWeightController.dispose();
    _usedWeightController.dispose();
    _printHoursController.dispose();
    _printMinutesController.dispose();
    _printerWattsController.dispose();
    _electricityRateController.dispose();
    _machineDepreciationController.dispose();
    _laborMinutesController.dispose();
    _laborRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF192227),
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.precision_manufacturing, color: Colors.tealAccent),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '3D Print Cost Lab',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            tooltip: 'Reset Input Fields',
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF192227),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Calculator')),
                        selected: _currentTab == 0,
                        selectedColor: Colors.teal,
                        onSelected: (val) {
                          if (val) setState(() => _currentTab = 0);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: Center(
                          child: Text('Saved History (${_savedJobs.length})'),
                        ),
                        selected: _currentTab == 1,
                        selectedColor: Colors.teal,
                        onSelected: (val) {
                          if (val) setState(() => _currentTab = 1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildCalculatorView(),
                  _buildHistoryView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Print Job Name',
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _jobTitleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'e.g. Mechanical Gear Box Assembly',
                      prefixIcon: Icon(Icons.edit, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preset Material Selector
          const Text(
            '1. Material Type & Spool Cost',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_presets.length, (index) {
                final preset = _presets[index];
                final isSelected = _selectedPresetIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(preset.name),
                    selectedColor: preset.badgeColor.withOpacity(0.8),
                    onSelected: (bool selected) {
                      if (selected) _applyPreset(index);
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          controller: _spoolCostController,
                          label: 'Spool Price (\$) ',
                          prefix: '\$',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberInput(
                          controller: _spoolWeightController,
                          label: 'Spool Weight (g)',
                          suffix: 'g',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNumberInput(
                    controller: _usedWeightController,
                    label: 'Model Usage Weight (g)',
                    suffix: 'g',
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time & Machine Costs
          const Text(
            '2. Print Time & Energy Usage',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          controller: _printHoursController,
                          label: 'Hours',
                          suffix: 'hrs',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberInput(
                          controller: _printMinutesController,
                          label: 'Minutes',
                          suffix: 'min',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          controller: _printerWattsController,
                          label: 'Printer Wattage',
                          suffix: 'W',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberInput(
                          controller: _electricityRateController,
                          label: 'Power Rate (\$/kWh)',
                          prefix: '\$',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Machine Wear & Post Processing Labor
          const Text(
            '3. Wear & Labor Operations',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberInput(
                          controller: _machineDepreciationController,
                          label: 'Machine Wear (\$/hr)',
                          prefix: '\$',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberInput(
                          controller: _laborMinutesController,
                          label: 'Labor Time',
                          suffix: 'min',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNumberInput(
                    controller: _laborRateController,
                    label: 'Labor Rate (\$/hr)',
                    prefix: '\$',
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Margins & Buffer Sliders
          const Text(
            '4. Risk Buffer & Profit Margin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Failure Risk Buffer',
                          style: TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${_failureMarginPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _failureMarginPercent,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    activeColor: Colors.teal,
                    onChanged: (val) {
                      setState(() {
                        _failureMarginPercent = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Target Profit Margin',
                          style: TextStyle(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${_profitMarginPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _profitMarginPercent,
                    min: 0,
                    max: 200,
                    divisions: 40,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _profitMarginPercent = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Cost Breakdown Card
          _buildCostSummaryCard(),
          const SizedBox(height: 16),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                'Save Job Calculation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: _saveCurrentJob,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCostSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3C40), Color(0xFF1B2B34)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Cost & Price Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.analytics, color: Colors.tealAccent),
              ],
            ),
            const Divider(height: 24, color: Colors.white24),

            _buildCostRow('Filament Cost', '\$${_filamentCost.toStringAsFixed(2)}'),
            _buildCostRow('Electricity Cost', '\$${_energyCost.toStringAsFixed(2)}'),
            _buildCostRow('Machine Wear Cost', '\$${_machineWearCost.toStringAsFixed(2)}'),
            _buildCostRow('Labor Cost', '\$${_laborCost.toStringAsFixed(2)}'),
            _buildCostRow('Failure Buffer (${_failureMarginPercent.toStringAsFixed(0)}%)', '\$${_failureCost.toStringAsFixed(2)}'),

            const Divider(height: 20, color: Colors.white24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Total Manufacturing Cost:',
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                ),
                Text(
                  '\$${_totalBaseCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    'Est. Net Profit:',
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                ),
                Text(
                  '+\$${_netProfit.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Suggested Price:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '\$${_suggestedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
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

  Widget _buildCostRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
        prefixText: prefix,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildHistoryView() {
    if (_savedJobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white30),
              SizedBox(height: 16),
              Text(
                'No Saved Calculation History',
                style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Calculate a model print cost and tap "Save Job Calculation" to build your pricing log.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _savedJobs.length,
      itemBuilder: (context, index) {
        final job = _savedJobs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          _savedJobs.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      label: Text(job.materialName, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.teal.withOpacity(0.2),
                      visualDensity: VisualDensity.compact,
                    ),
                    Chip(
                      label: Text('${job.printTimeHours.toStringAsFixed(1)} hrs', style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.blue.withOpacity(0.2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const Divider(height: 16, color: Colors.white12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Unit Cost: \$${job.totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      'Price: \$${job.retailPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}