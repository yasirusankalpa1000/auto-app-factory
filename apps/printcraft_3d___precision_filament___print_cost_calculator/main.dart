import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PrintCraftApp());
}

class PrintCraftApp extends StatelessWidget {
  const PrintCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrintCraft 3D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121218),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E2A),
          elevation: 3,
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
  final String materialName;
  final double weightGrams;
  final double printHours;
  final double totalCost;
  final double sellingPrice;
  final double netProfit;
  final DateTime date;

  SavedQuote({
    required this.id,
    required this.title,
    required this.materialName,
    required this.weightGrams,
    required this.printHours,
    required this.totalCost,
    required this.sellingPrice,
    required this.netProfit,
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

  // Controllers for input fields
  final TextEditingController _projectNameController =
      TextEditingController(text: 'Custom Drone Frame');
  final TextEditingController _spoolPriceController =
      TextEditingController(text: '24.99');
  final TextEditingController _spoolWeightController =
      TextEditingController(text: '1000');
  final TextEditingController _printWeightController =
      TextEditingController(text: '145');
  final TextEditingController _printHoursController =
      TextEditingController(text: '6.5');
  final TextEditingController _printerPowerController =
      TextEditingController(text: '180');
  final TextEditingController _elecCostController =
      TextEditingController(text: '0.15');
  final TextEditingController _wearCostRateController =
      TextEditingController(text: '0.25');
  final TextEditingController _laborRateController =
      TextEditingController(text: '18.00');
  final TextEditingController _laborMinutesController =
      TextEditingController(text: '20');

  // Sliders
  double _failBufferPercent = 10.0;
  double _markupPercent = 40.0;
  String _selectedMaterial = 'PLA Filament';

  // Saved Quotes
  final List<SavedQuote> _savedQuotes = [];

  @override
  void dispose() {
    _projectNameController.dispose();
    _spoolPriceController.dispose();
    _spoolWeightController.dispose();
    _printWeightController.dispose();
    _printHoursController.dispose();
    _printerPowerController.dispose();
    _elecCostController.dispose();
    _wearCostRateController.dispose();
    _laborRateController.dispose();
    _laborMinutesController.dispose();
    super.dispose();
  }

  // Calculations
  double get spoolPrice => double.tryParse(_spoolPriceController.text) ?? 0.0;
  double get spoolWeight => double.tryParse(_spoolWeightController.text) ?? 1000.0;
  double get printWeight => double.tryParse(_printWeightController.text) ?? 0.0;
  double get printHours => double.tryParse(_printHoursController.text) ?? 0.0;
  double get printerWatts => double.tryParse(_printerPowerController.text) ?? 0.0;
  double get elecRate => double.tryParse(_elecCostController.text) ?? 0.0;
  double get wearRate => double.tryParse(_wearCostRateController.text) ?? 0.0;
  double get laborRate => double.tryParse(_laborRateController.text) ?? 0.0;
  double get laborMinutes => double.tryParse(_laborMinutesController.text) ?? 0.0;

  double get materialCost => (spoolWeight > 0) ? (printWeight / spoolWeight) * spoolPrice : 0.0;
  double get energyCost => (printerWatts / 1000.0) * printHours * elecRate;
  double get wearCost => printHours * wearRate;
  double get laborCost => (laborMinutes / 60.0) * laborRate;

  double get subtotalCost => materialCost + energyCost + wearCost + laborCost;
  double get riskBufferCost => subtotalCost * (_failBufferPercent / 100.0);
  double get totalBaseCost => subtotalCost + riskBufferCost;
  double get sellingPrice => totalBaseCost * (1.0 + (_markupPercent / 100.0));
  double get netProfit => sellingPrice - totalBaseCost;

  void _applyMaterialPreset(String name, double price, double weight) {
    setState(() {
      _selectedMaterial = name;
      _spoolPriceController.text = price.toStringAsFixed(2);
      _spoolWeightController.text = weight.toStringAsFixed(0);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied material preset: $name', overflow: TextOverflow.ellipsis),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyPrinterPreset(String name, double watts, double wear) {
    setState(() {
      _printerPowerController.text = watts.toStringAsFixed(0);
      _wearCostRateController.text = wear.toStringAsFixed(2);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied printer preset: $name', overflow: TextOverflow.ellipsis),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveCurrentQuote() {
    final title = _projectNameController.text.trim().isEmpty
        ? 'Untitled Print'
        : _projectNameController.text.trim();

    final newQuote = SavedQuote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      materialName: _selectedMaterial,
      weightGrams: printWeight,
      printHours: printHours,
      totalCost: totalBaseCost,
      sellingPrice: sellingPrice,
      netProfit: netProfit,
      date: DateTime.now(),
    );

    setState(() {
      _savedQuotes.insert(0, newQuote);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _copyQuoteToClipboard() {
    final buffer = StringBuffer();
    buffer.writeln('=== PRINT CRAFT 3D JOB QUOTE ===');
    buffer.writeln('Project Name: ${_projectNameController.text.trim()}');
    buffer.writeln('Material: $_selectedMaterial');
    buffer.writeln('Filament Weight: ${printWeight.toStringAsFixed(1)} g');
    buffer.writeln('Print Time: ${printHours.toStringAsFixed(1)} hrs');
    buffer.writeln('--------------------------------');
    buffer.writeln('Material Cost: \$${materialCost.toStringAsFixed(2)}');
    buffer.writeln('Energy Cost: \$${energyCost.toStringAsFixed(2)}');
    buffer.writeln('Wear & Tear: \$${wearCost.toStringAsFixed(2)}');
    buffer.writeln('Post-Process Labor: \$${laborCost.toStringAsFixed(2)}');
    buffer.writeln('Failure Buffer (${_failBufferPercent.toStringAsFixed(0)}%): \$${riskBufferCost.toStringAsFixed(2)}');
    buffer.writeln('--------------------------------');
    buffer.writeln('Total Cost: \$${totalBaseCost.toStringAsFixed(2)}');
    buffer.writeln('Suggested Quote: \$${sellingPrice.toStringAsFixed(2)}');
    buffer.writeln('Estimated Profit: \$${netProfit.toStringAsFixed(2)}');
    buffer.writeln('================================');

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clean quote copied to clipboard!'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildCalculatorTab(),
      _buildPresetsTab(),
      _buildHistoryTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.precision_manufacturing, color: Colors.amber),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'PrintCraft 3D',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF181824),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Copy Quote Summary',
            onPressed: _copyQuoteToClipboard,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Quote',
            onPressed: _saveCurrentQuote,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF181824),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Presets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Saved Quotes',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: CALCULATOR TAB ---
  Widget _buildCalculatorTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Project Title Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project / Part Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.build),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Material & Spool Info Section
            _buildSectionHeader('1. Filament & Model Info', Icons.opacity),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _spoolPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Spool Price (\ direction)',
                              prefixText: '\$ ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _spoolWeightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Spool Net Weight',
                              suffixText: 'g',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _printWeightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Model Printed Weight',
                        suffixText: 'g',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.scale),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Printer & Electricity Section
            _buildSectionHeader('2. Printer & Energy Specs', Icons.bolt),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _printHoursController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Print Time',
                              suffixText: 'hrs',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _printerPowerController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Avg Power',
                              suffixText: 'Watts',
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
                            controller: _elecCostController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Elec Rate',
                              prefixText: '\$ ',
                              suffixText: '/kWh',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _wearCostRateController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              labelText: 'Wear & Tear',
                              prefixText: '\$ ',
                              suffixText: '/hr',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Labor & Post Processing
            _buildSectionHeader('3. Post-Processing & Labor', Icons.timer),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _laborMinutesController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Labor Time',
                          suffixText: 'mins',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _laborRateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Labor Rate',
                          prefixText: '\$ ',
                          suffixText: '/hr',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Fail Rate & Profit Sliders
            _buildSectionHeader('4. Risk Buffer & Profit Markup', Icons.settings),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Failure Risk Buffer:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${_failBufferPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: _failBufferPercent,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: Colors.amber,
                      onChanged: (val) {
                        setState(() {
                          _failBufferPercent = val;
                        });
                      },
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'Desired Markup:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${_markupPercent.toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: _markupPercent,
                      min: 0,
                      max: 200,
                      divisions: 40,
                      activeColor: Colors.greenAccent,
                      onChanged: (val) {
                        setState(() {
                          _markupPercent = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // COST BREAKDOWN RESULTS CARD
            Card(
              color: const Color(0xFF262636),
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.amber, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'ITEMIZED FINANCIAL SUMMARY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCostRow('Filament Material', materialCost),
                    _buildCostRow('Electricity Cost', energyCost),
                    _buildCostRow('Printer Wear & Tear', wearCost),
                    _buildCostRow('Labor & Cleanup', laborCost),
                    _buildCostRow('Failure Risk Buffer (${_failBufferPercent.toStringAsFixed(0)}%)', riskBufferCost),
                    const Divider(height: 20, thickness: 1),
                    _buildCostRow('TOTAL BASE COST', totalBaseCost, isBold: true, fontSize: 16),
                    _buildCostRow('NET PROFIT', netProfit, color: Colors.greenAccent, isBold: true, fontSize: 16),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'RECOMMENDED CLIENT QUOTE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\$${sellingPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ACTION BUTTONS
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _copyQuoteToClipboard,
                  icon: const Icon(Icons.content_copy),
                  label: const Text('Copy Text Quote'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saveCurrentQuote,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  // --- TAB 2: PRESETS TAB ---
  Widget _buildPresetsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader('Filament Material Presets', Icons.opacity),
            const Text(
              'Tap a preset to auto-populate spool pricing & specs:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPresetChip('Standard PLA', 22.00, 1000, Colors.blue),
                _buildPresetChip('PETG Durable', 26.50, 1000, Colors.teal),
                _buildPresetChip('ABS / ASA', 28.00, 1000, Colors.orange),
                _buildPresetChip('TPU Flexible', 34.00, 800, Colors.purple),
                _buildPresetChip('Carbon Fiber PLA', 45.00, 750, Colors.grey),
                _buildPresetChip('Standard Resin', 32.00, 1000, Colors.pink),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('3D Printer Hardware Profiles', Icons.precision_manufacturing),
            const Text(
              'Tap a hardware profile to auto-fill power draw & wear:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            _buildPrinterCard('Budget FDM (Ender 3 / Neptune)', 120, 0.15, Icons.build),
            _buildPrinterCard('High-Speed CoreXY (Bambu X1C / K1)', 350, 0.35, Icons.flash_on),
            _buildPrinterCard('Workhorse FDM (Prusa MK4)', 150, 0.20, Icons.precision_manufacturing),
            _buildPrinterCard('SLA Resin Printer (Formlabs / Elegoo)', 70, 0.40, Icons.water_drop),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- TAB 3: HISTORY / SAVED TAB ---
  Widget _buildHistoryTab() {
    return SafeArea(
      child: _savedQuotes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.inventory, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No Saved Quotes Yet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Calculate print costs and tap "Save Project" to keep dynamic records here.',
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
                final item = _savedQuotes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${item.sellingPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Material: ${item.materialName} (${item.weightGrams.toStringAsFixed(0)}g | ${item.printHours.toStringAsFixed(1)} hrs)',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cost: \$${item.totalCost.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            'Profit: \$${item.netProfit.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12, color: Colors.greenAccent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        _savedQuotes.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quote deleted')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, double amount,
      {Color? color, bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.white70,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String name, double price, double weight, Color accentColor) {
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: accentColor,
        radius: 6,
      ),
      label: Text('$name (\$$price)'),
      onPressed: () => _applyMaterialPreset(name, price, weight),
    );
  }

  Widget _buildPrinterCard(String name, double watts, double wear, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Power: ${watts.toStringAsFixed(0)}W | Wear: \$${wear.toStringAsFixed(2)}/hr'),
        trailing: const Icon(Icons.add_circle_outline, color: Colors.amber),
        onTap: () => _applyPrinterPreset(name, watts, wear),
      ),
    );
  }
}