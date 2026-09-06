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
      title: 'SpoolCraft 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
          primary: Colors.deepOrange,
          secondary: Colors.teal,
          surface: const Color(0xFFF8F9FA),
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

class SavedQuote {
  final String id;
  final String title;
  final String material;
  final double printWeightGrams;
  final double printHours;
  final double totalCost;
  final double sellPrice;
  final double netProfit;

  SavedQuote({
    required this.id,
    required this.title,
    required this.material,
    required this.printWeightGrams,
    required this.printHours,
    required this.totalCost,
    required this.sellPrice,
    required this.netProfit,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Controllers for Calculator
  final TextEditingController _jobNameController =
      TextEditingController(text: 'Custom Modular Gear');
  final TextEditingController _spoolPriceController =
      TextEditingController(text: '22.00');
  final TextEditingController _spoolMassController =
      TextEditingController(text: '1000');
  final TextEditingController _modelMassController =
      TextEditingController(text: '85');
  final TextEditingController _hoursController =
      TextEditingController(text: '4');
  final TextEditingController _minsController =
      TextEditingController(text: '30');
  final TextEditingController _wattageController =
      TextEditingController(text: '210');
  final TextEditingController _elecRateController =
      TextEditingController(text: '0.15');
  final TextEditingController _wearRateController =
      TextEditingController(text: '0.25');
  final TextEditingController _laborTimeController =
      TextEditingController(text: '0.5');
  final TextEditingController _laborRateController =
      TextEditingController(text: '18.00');

  String _selectedMaterial = 'PLA';
  double _failureBufferPercent = 10.0;
  double _targetMarginPercent = 40.0;

  // Filament Densities (g/cm3)
  final Map<String, double> _materialDensities = {
    'PLA': 1.24,
    'PETG': 1.27,
    'ABS': 1.04,
    'TPU': 1.21,
    'Resin': 1.15,
  };

  // Spool Length Calculator Controllers
  final TextEditingController _calcSpoolMassController =
      TextEditingController(text: '1000');
  final TextEditingController _calcDiameterController =
      TextEditingController(text: '1.75');
  String _calcMaterial = 'PLA';
  double _calculatedLengthMeters = 332.6;

  // Saved Quotes Ledger
  final List<SavedQuote> _savedQuotes = [];

  @override
  void initState() {
    super.initState();
    _recalculateSpoolLength();
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _spoolPriceController.dispose();
    _spoolMassController.dispose();
    _modelMassController.dispose();
    _hoursController.dispose();
    _minsController.dispose();
    _wattageController.dispose();
    _elecRateController.dispose();
    _wearRateController.dispose();
    _laborTimeController.dispose();
    _laborRateController.dispose();
    _calcSpoolMassController.dispose();
    _calcDiameterController.dispose();
    super.dispose();
  }

  void _recalculateSpoolLength() {
    final mass = double.tryParse(_calcSpoolMassController.text) ?? 1000.0;
    final diameterMm = double.tryParse(_calcDiameterController.text) ?? 1.75;
    final density = _materialDensities[_calcMaterial] ?? 1.24;

    final radiusCm = (diameterMm / 10.0) / 2.0;
    final volumeCm3 = mass / density;
    final lengthCm = volumeCm3 / (math.pi * radiusCm * radiusCm);
    
    setState(() {
      _calculatedLengthMeters = lengthCm / 100.0;
    });
  }

  // Cost Computations
  double get _printHoursTotal {
    final h = double.tryParse(_hoursController.text) ?? 0.0;
    final m = double.tryParse(_minsController.text) ?? 0.0;
    return h + (m / 60.0);
  }

  double get _materialCost {
    final spoolPrice = double.tryParse(_spoolPriceController.text) ?? 0.0;
    final spoolMass = double.tryParse(_spoolMassController.text) ?? 1.0;
    final modelMass = double.tryParse(_modelMassController.text) ?? 0.0;
    if (spoolMass <= 0) return 0.0;
    return (modelMass / spoolMass) * spoolPrice;
  }

  double get _electricityCost {
    final watts = double.tryParse(_wattageController.text) ?? 0.0;
    final kwhRate = double.tryParse(_elecRateController.text) ?? 0.0;
    return (_printHoursTotal * (watts / 1000.0)) * kwhRate;
  }

  double get _machineWearCost {
    final wearRate = double.tryParse(_wearRateController.text) ?? 0.0;
    return _printHoursTotal * wearRate;
  }

  double get _laborCost {
    final time = double.tryParse(_laborTimeController.text) ?? 0.0;
    final rate = double.tryParse(_laborRateController.text) ?? 0.0;
    return time * rate;
  }

  double get _subtotalCost =>
      _materialCost + _electricityCost + _machineWearCost + _laborCost;

  double get _failureBufferCost =>
      _subtotalCost * (_failureBufferPercent / 100.0);

  double get _totalCost => _subtotalCost + _failureBufferCost;

  double get _recommendedSellingPrice =>
      _totalCost * (1.0 + (_targetMarginPercent / 100.0));

  double get _netProfit => _recommendedSellingPrice - _totalCost;

  void _saveCurrentQuote() {
    final name = _jobNameController.text.trim().isEmpty
        ? 'Untitled Print'
        : _jobNameController.text.trim();

    final quote = SavedQuote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: name,
      material: _selectedMaterial,
      printWeightGrams: double.tryParse(_modelMassController.text) ?? 0.0,
      printHours: _printHoursTotal,
      totalCost: _totalCost,
      sellPrice: _recommendedSellingPrice,
      netProfit: _netProfit,
    );

    setState(() {
      _savedQuotes.insert(0, quote);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved "$name" quote!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('3D Print Pricing Guide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Material Cost:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Cost of filament or resin consumed by the print.'),
              SizedBox(height: 8),
              Text(
                '2. Energy & Machine Wear:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Depreciation for nozzle, bed, electricity, and maintenance.'),
              SizedBox(height: 8),
              Text(
                '3. Labor & Prep:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Time spent slicing, post-processing, removing supports, and packaging.'),
              SizedBox(height: 8),
              Text(
                '4. Risk Allowance:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Buffer to cover potential bed detachment or filament runout.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.precision_manufacturing, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'SpoolCraft 3D',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog,
            tooltip: 'Pricing Guidelines',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildCalculatorTab(),
          _buildSpoolToolsTab(),
          _buildSavedQuotesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Cost Estimator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Spool Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Quotes Ledger',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: CALCULATOR ---
  Widget _buildCalculatorTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Job Name Input
            TextField(
              controller: _jobNameController,
              decoration: const InputDecoration(
                labelText: 'Job / Model Description',
                prefixIcon: Icon(Icons.build),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Result Hero Card
            Card(
              color: Colors.deepOrange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Estimated Production Cost:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          '\$${_totalCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Target Price',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              '\$${_recommendedSellingPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Estimated Net Profit',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              '+\$${_netProfit.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(42),
                      ),
                      onPressed: _saveCurrentQuote,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Print Quote'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Material Selection Chips
            const Text(
              'Select Material Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _materialDensities.keys.map((mat) {
                final isSelected = _selectedMaterial == mat;
                return ChoiceChip(
                  label: Text(mat),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedMaterial = mat);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Material & Spool Inputs
            _buildSectionHeader('1. Spool & Print Weight'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _spoolPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Spool Price (\ direction)',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _spoolMassController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Spool Weight (g)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _modelMassController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Model Printed Mass (g)',
                prefixIcon: Icon(Icons.scale),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Time & Power Inputs
            _buildSectionHeader('2. Print Time & Power Usage'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hoursController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                      prefixIcon: Icon(Icons.timer),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _minsController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
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
                    controller: _wattageController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Power (Watts)',
                      prefixIcon: Icon(Icons.electric_bolt),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _elecRateController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Elec (\$/kWh)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Labor & Wear Inputs
            _buildSectionHeader('3. Machine Wear & Labor'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _wearRateController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Wear (\$/hr)',
                      prefixIcon: Icon(Icons.precision_manufacturing),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _laborTimeController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Labor Prep (hrs)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _laborRateController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Labor Hourly Rate (\$/hr)',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sliders for Buffer and Profit
            _buildSectionHeader('4. Failure Buffer & Profit Margin'),
            Text(
              'Failure Risk Buffer: ${_failureBufferPercent.round()}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _failureBufferPercent,
              min: 0,
              max: 30,
              divisions: 30,
              activeColor: Colors.deepOrange,
              label: '${_failureBufferPercent.round()}%',
              onChanged: (val) => setState(() => _failureBufferPercent = val),
            ),
            const SizedBox(height: 8),
            Text(
              'Target Profit Markup: ${_targetMarginPercent.round()}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _targetMarginPercent,
              min: 0,
              max: 200,
              divisions: 40,
              activeColor: Colors.teal,
              label: '${_targetMarginPercent.round()}%',
              onChanged: (val) => setState(() => _targetMarginPercent = val),
            ),
            const SizedBox(height: 16),

            // Itemized Cost Breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Itemized Cost Breakdown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(),
                    _buildCostRow('Raw Filament', _materialCost),
                    _buildCostRow('Electricity Energy', _electricityCost),
                    _buildCostRow('Machine Wear / Depreciation', _machineWearCost),
                    _buildCostRow('Prep & Post Labor', _laborCost),
                    _buildCostRow('Failure Allowance Buffer', _failureBufferCost),
                    const Divider(),
                    _buildCostRow('Total Net Production Cost', _totalCost, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: SPOOL LENGTH TOOLS ---
  Widget _buildSpoolToolsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.teal,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spool Length & Density Calculator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Calculate remaining filament length in meters from spool mass and diameter.',
                      style: TextStyle(color: Colors.white70),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Select Material
            const Text(
              'Filament Density Preset',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _materialDensities.keys.map((mat) {
                final isSelected = _calcMaterial == mat;
                return ChoiceChip(
                  label: Text('$mat (${_materialDensities[mat]} g/cm³)'),
                  selected: isSelected,
                  selectedColor: Colors.teal,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _calcMaterial = mat;
                        _recalculateSpoolLength();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _calcSpoolMassController,
              keyboardType: TextInputType.number,
              onChanged: (_) => _recalculateSpoolLength(),
              decoration: const InputDecoration(
                labelText: 'Remaining Spool Mass (Grams)',
                prefixIcon: Icon(Icons.scale),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _calcDiameterController,
              keyboardType: TextInputType.number,
              onChanged: (_) => _recalculateSpoolLength(),
              decoration: const InputDecoration(
                labelText: 'Filament Diameter (mm, e.g. 1.75 or 2.85)',
                prefixIcon: Icon(Icons.straighten),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Result Display Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Estimated Filament Length:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_calculatedLengthMeters.toStringAsFixed(1)} m',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      '~ ${(_calculatedLengthMeters * 3.28084).toStringAsFixed(1)} feet',
                      style: const TextStyle(color: Colors.black54),
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

  // --- TAB 3: SAVED QUOTES LEDGER ---
  Widget _buildSavedQuotesTab() {
    return SafeArea(
      child: _savedQuotes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Print Quotes Saved Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Calculate costs in the Estimator tab and click "Save Print Quote" to build your ledger.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _savedQuotes.length,
              itemBuilder: (context, index) {
                final quote = _savedQuotes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            quote.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${quote.sellPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(quote.material),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Colors.deepOrange.shade50,
                            ),
                            Chip(
                              label: Text('${quote.printWeightGrams.toStringAsFixed(0)}g'),
                              visualDensity: VisualDensity.compact,
                            ),
                            Chip(
                              label: Text('${quote.printHours.toStringAsFixed(1)} hrs'),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cost: \$${quote.totalCost.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            Text(
                              'Profit: +\$${quote.netProfit.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _savedQuotes.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 14 : 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 14 : 13,
              color: isBold ? Colors.deepOrange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}