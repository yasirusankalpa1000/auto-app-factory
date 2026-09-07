import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpoolMateApp());
}

class SpoolMateApp extends StatelessWidget {
  const SpoolMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpoolMate Pro',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF12181B),
        cardTheme: CardTheme(
          color: const Color(0xFF1E272C),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A343B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MaterialPreset {
  final String name;
  final double density; // g/cm3
  final double defaultCostPerKg;

  const MaterialPreset({
    required this.name,
    required this.density,
    required this.defaultCostPerKg,
  });
}

const List<MaterialPreset> kMaterialPresets = [
  MaterialPreset(name: 'PLA', density: 1.24, defaultCostPerKg: 22.0),
  MaterialPreset(name: 'PETG', density: 1.27, defaultCostPerKg: 25.0),
  MaterialPreset(name: 'ABS', density: 1.04, defaultCostPerKg: 20.0),
  MaterialPreset(name: 'TPU (Flex)', density: 1.21, defaultCostPerKg: 32.0),
  MaterialPreset(name: 'ASA', density: 1.07, defaultCostPerKg: 28.0),
  MaterialPreset(name: 'PC (Polycarbonate)', density: 1.20, defaultCostPerKg: 45.0),
  MaterialPreset(name: 'UV Resin (Standard)', density: 1.15, defaultCostPerKg: 30.0),
];

class QuoteItem {
  final String id;
  final String projectName;
  final String materialName;
  final double weightGrams;
  final double printHours;
  final double totalCost;
  final double quotePrice;
  final double profit;
  final DateTime date;

  QuoteItem({
    required this.id,
    required this.projectName,
    required this.materialName,
    required this.weightGrams,
    required this.printHours,
    required this.totalCost,
    required this.quotePrice,
    required this.profit,
    required this.date,
  });
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<QuoteItem> _savedQuotes = [];

  void _addQuote(QuoteItem quote) {
    setState(() {
      _savedQuotes.insert(0, quote);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote saved for "${quote.projectName}"!'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteQuote(String id) {
    setState(() {
      _savedQuotes.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      QuoteCalculatorTab(onSaveQuote: _addQuote),
      const FilamentConverterTab(),
      QuoteHistoryTab(quotes: _savedQuotes, onDeleteQuote: _deleteQuote),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.build, color: Colors.teal),
            SizedBox(width: 10),
            Text(
              'SpoolMate Pro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E272C),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E272C),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarThemeData(
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Job Quoter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Converter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Saved Quotes',
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E272C),
        title: const Text('About SpoolMate Pro'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'SpoolMate Pro is designed to calculate precise production costs and recommended retail prices for 3D printed parts.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                'Formula Highlights:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent),
              ),
              SizedBox(height: 6),
              Text('• Material Cost = (Used Grams / Spool Grams) × Spool Price'),
              Text('• Power Draw = (Printer Watts / 1000) × Hours × Electricity Rate'),
              Text('• Failure Risk = Total Base Cost × Risk Margin %'),
              Text('• Final Quote = (Base + Risk + Labor) × (1 + Markup %)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.tealAccent)),
          ),
        ],
      ),
    );
  }
}

class QuoteCalculatorTab extends StatefulWidget {
  final Function(QuoteItem) onSaveQuote;

  const QuoteCalculatorTab({super.key, required this.onSaveQuote});

  @override
  State<QuoteCalculatorTab> createState() => _QuoteCalculatorTabState();
}

class _QuoteCalculatorTabState extends State<QuoteCalculatorTab> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _projectNameCtrl = TextEditingController(text: 'Custom Bracket');
  final TextEditingController _spoolPriceCtrl = TextEditingController(text: '25.00');
  final TextEditingController _spoolWeightCtrl = TextEditingController(text: '1000');
  final TextEditingController _usedWeightCtrl = TextEditingController(text: '145');
  final TextEditingController _printHoursCtrl = TextEditingController(text: '5.5');
  final TextEditingController _wattageCtrl = TextEditingController(text: '200');
  final TextEditingController _kwhRateCtrl = TextEditingController(text: '0.15');
  final TextEditingController _laborRateCtrl = TextEditingController(text: '15.00');
  final TextEditingController _laborHoursCtrl = TextEditingController(text: '0.5');

  MaterialPreset _selectedMaterial = kMaterialPresets[0];
  double _failureMarginPercent = 10.0;
  double _profitMarginPercent = 35.0;

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _spoolPriceCtrl.dispose();
    _spoolWeightCtrl.dispose();
    _usedWeightCtrl.dispose();
    _printHoursCtrl.dispose();
    _wattageCtrl.dispose();
    _kwhRateCtrl.dispose();
    _laborRateCtrl.dispose();
    _laborHoursCtrl.dispose();
    super.dispose();
  }

  void _applyMaterialDefaults(MaterialPreset preset) {
    setState(() {
      _selectedMaterial = preset;
      _spoolPriceCtrl.text = preset.defaultCostPerKg.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spoolPrice = double.tryParse(_spoolPriceCtrl.text) ?? 0.0;
    final spoolWeight = double.tryParse(_spoolWeightCtrl.text) ?? 1000.0;
    final usedWeight = double.tryParse(_usedWeightCtrl.text) ?? 0.0;
    final printHours = double.tryParse(_printHoursCtrl.text) ?? 0.0;
    final wattage = double.tryParse(_wattageCtrl.text) ?? 0.0;
    final kwhRate = double.tryParse(_kwhRateCtrl.text) ?? 0.0;
    final laborRate = double.tryParse(_laborRateCtrl.text) ?? 0.0;
    final laborHours = double.tryParse(_laborHoursCtrl.text) ?? 0.0;

    // Calculations
    final costPerGram = spoolWeight > 0 ? (spoolPrice / spoolWeight) : 0.0;
    final materialCost = usedWeight * costPerGram;
    final kwhConsumed = (wattage / 1000.0) * printHours;
    final electricityCost = kwhConsumed * kwhRate;
    final laborCost = laborRate * laborHours;

    final subtotalCost = materialCost + electricityCost + laborCost;
    final failureBuffer = subtotalCost * (_failureMarginPercent / 100.0);
    final totalProductionCost = subtotalCost + failureBuffer;

    final profitAmount = totalProductionCost * (_profitMarginPercent / 100.0);
    final finalQuotePrice = totalProductionCost + profitAmount;

    final remainingSpoolPercent = spoolWeight > 0 ? max(0.0, ((spoolWeight - usedWeight) / spoolWeight) * 100) : 0.0;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.calculate, color: Colors.tealAccent, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '3D Print Quoter',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Calculate exact costs & markup prices',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Project Name Input
              TextFormField(
                controller: _projectNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Project / Part Name',
                  prefixIcon: Icon(Icons.edit, color: Colors.tealAccent),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Material Selection Dropdown / Chips
              const Text(
                'Select Material',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.tealAccent),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: kMaterialPresets.map((preset) {
                    final isSelected = _selectedMaterial.name == preset.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(preset.name),
                        selected: isSelected,
                        selectedColor: Colors.teal,
                        backgroundColor: const Color(0xFF2A343B),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade300,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) _applyMaterialDefaults(preset);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Spool Details Section
              _buildSectionTitle('1. Filament & Material Cost'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _spoolPriceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Spool Cost (\$) ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _spoolWeightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Spool Size (g)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usedWeightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Used Weight for Part (g)',
                  prefixIcon: Icon(Icons.layers, color: Colors.tealAccent),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Printer & Power Section
              _buildSectionTitle('2. Machine Time & Power Consumption'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _printHoursCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Print Time (hrs)',
                        prefixIcon: Icon(Icons.timer, color: Colors.tealAccent),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _wattageCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Printer Watts',
                        prefixIcon: Icon(Icons.bolt, color: Colors.amber),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kwhRateCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Electricity Rate (\$/kWh)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Labor Section
              _buildSectionTitle('3. Setup & Post-Processing Labor'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _laborRateCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Labor Rate (\$/hr)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _laborHoursCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Labor Hours',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Margins & Buffer Sliders
              _buildSectionTitle('4. Risk & Profit Margins'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Failure Buffer Rate: ${_failureMarginPercent.toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '+\$${failureBuffer.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Slider(
                        value: _failureMarginPercent,
                        min: 0,
                        max: 30,
                        divisions: 30,
                        activeColor: Colors.orangeAccent,
                        onChanged: (val) => setState(() => _failureMarginPercent = val),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Target Profit Margin: ${_profitMarginPercent.toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '+\$${profitAmount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Slider(
                        value: _profitMarginPercent,
                        min: 0,
                        max: 150,
                        divisions: 30,
                        activeColor: Colors.greenAccent,
                        onChanged: (val) => setState(() => _profitMarginPercent = val),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // LIVE SUMMARY CARD
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4D4F), Color(0xFF1E3A42)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Text(
                            'RECOMMENDED QUOTE',
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.tealAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Rem. Spool: ${remainingSpoolPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${finalQuotePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.extrabold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    _buildCostRow('Raw Material Cost', materialCost),
                    _buildCostRow('Power Consumption (${kwhConsumed.toStringAsFixed(2)} kWh)', electricityCost),
                    _buildCostRow('Labor Setup Cost', laborCost),
                    _buildCostRow('Failure Buffer Risk Allowance', failureBuffer, isHighlight: false),
                    const Divider(color: Colors.white24),
                    _buildCostRow('Total Production Cost', totalProductionCost, isBold: true),
                    _buildCostRow('Estimated Net Profit', profitAmount, isBold: true, color: Colors.greenAccent),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.teal),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.share, color: Colors.tealAccent),
                      label: const Text('Export Quote', style: TextStyle(color: Colors.tealAccent)),
                      onPressed: () {
                        final summary = _generateQuoteSummaryText(
                          projectName: _projectNameCtrl.text,
                          materialName: _selectedMaterial.name,
                          weightGrams: usedWeight,
                          hours: printHours,
                          materialCost: materialCost,
                          electricityCost: electricityCost,
                          laborCost: laborCost,
                          totalCost: totalProductionCost,
                          quotePrice: finalQuotePrice,
                          profit: profitAmount,
                        );
                        Clipboard.setData(ClipboardData(text: summary));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Detailed Quote copied to clipboard!'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text('Save Quote', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final name = _projectNameCtrl.text.trim().isEmpty ? 'Untitled Project' : _projectNameCtrl.text.trim();
                        final newQuote = QuoteItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          projectName: name,
                          materialName: _selectedMaterial.name,
                          weightGrams: usedWeight,
                          printHours: printHours,
                          totalCost: totalProductionCost,
                          quotePrice: finalQuotePrice,
                          profit: profitAmount,
                          date: DateTime.now(),
                        );
                        widget.onSaveQuote(newQuote);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.tealAccent,
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isBold = false, bool isHighlight = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? (isBold ? Colors.white : Colors.white70),
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isBold ? Colors.white : Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  String _generateQuoteSummaryText({
    required String projectName,
    required String materialName,
    required double weightGrams,
    required double hours,
    required double materialCost,
    required double electricityCost,
    required double laborCost,
    required double totalCost,
    required double quotePrice,
    required double profit,
  }) {
    final sb = StringBuffer();
    sb.writeln('=== 3D PRINTING QUOTATION ===');
    sb.writeln('Project: $projectName');
    sb.writeln('Material: $materialName (${weightGrams.toStringAsFixed(1)}g)');
    sb.writeln('Print Time: ${hours.toStringAsFixed(1)} hrs');
    sb.writeln('-----------------------------');
    sb.writeln('Material Cost: \$${materialCost.toStringAsFixed(2)}');
    sb.writeln('Energy Cost: \$${electricityCost.toStringAsFixed(2)}');
    sb.writeln('Labor & Setup: \$${laborCost.toStringAsFixed(2)}');
    sb.writeln('Production Cost: \$${totalCost.toStringAsFixed(2)}');
    sb.writeln('-----------------------------');
    sb.writeln('ESTIMATED TOTAL QUOTE: \$${quotePrice.toStringAsFixed(2)}');
    sb.writeln('Thank you for your business!');
    return sb.toString();
  }
}

class FilamentConverterTab extends StatefulWidget {
  const FilamentConverterTab({super.key});

  @override
  State<FilamentConverterTab> createState() => _FilamentConverterTabState();
}

class _FilamentConverterTabState extends State<FilamentConverterTab> {
  MaterialPreset _selectedPreset = kMaterialPresets[0];
  double _diameterMm = 1.75;
  
  final TextEditingController _weightCtrl = TextEditingController(text: '250');
  final TextEditingController _lengthCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateLengthFromWeight();
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    super.dispose();
  }

  void _calculateLengthFromWeight() {
    final weightGrams = double.tryParse(_weightCtrl.text) ?? 0.0;
    if (weightGrams <= 0) {
      _lengthCtrl.text = '0.0';
      return;
    }

    // Volume in cm3 = weight(g) / density(g/cm3)
    final volumeCm3 = weightGrams / _selectedPreset.density;
    
    // Radius in cm
    final radiusCm = (_diameterMm / 10.0) / 2.0;
    
    // Length in cm = Volume / (pi * r^2)
    final lengthCm = volumeCm3 / (pi * pow(radiusCm, 2));
    
    // Length in meters
    final lengthMeters = lengthCm / 100.0;

    _lengthCtrl.text = lengthMeters.toStringAsFixed(2);
  }

  void _calculateWeightFromLength() {
    final lengthMeters = double.tryParse(_lengthCtrl.text) ?? 0.0;
    if (lengthMeters <= 0) {
      _weightCtrl.text = '0.0';
      return;
    }

    final lengthCm = lengthMeters * 100.0;
    final radiusCm = (_diameterMm / 10.0) / 2.0;
    final volumeCm3 = lengthCm * pi * pow(radiusCm, 2);
    final weightGrams = volumeCm3 * _selectedPreset.density;

    _weightCtrl.text = weightGrams.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.straighten, color: Colors.amberAccent, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Filament Dimensional Converter',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Convert weight (grams) to meters & vice versa',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Material Dropdown & Diameter selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Material Density Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<MaterialPreset>(
                      value: _selectedPreset,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: kMaterialPresets.map((preset) {
                        return DropdownMenuItem(
                          value: preset,
                          child: Text('${preset.name} (${preset.density} g/cm³)'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPreset = val;
                            _calculateLengthFromWeight();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Filament Diameter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('1.75 mm Standard')),
                            selected: _diameterMm == 1.75,
                            selectedColor: Colors.teal,
                            backgroundColor: const Color(0xFF2A343B),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _diameterMm = 1.75;
                                  _calculateLengthFromWeight();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('2.85 mm / 3.0 mm')),
                            selected: _diameterMm == 2.85,
                            selectedColor: Colors.teal,
                            backgroundColor: const Color(0xFF2A343B),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _diameterMm = 2.85;
                                  _calculateLengthFromWeight();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bi-directional Converter Inputs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight (Grams)',
                        prefixIcon: Icon(Icons.scale, color: Colors.tealAccent),
                        suffixText: 'g',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculateLengthFromWeight(),
                    ),
                    const SizedBox(height: 16),
                    const Icon(Icons.swap_vert, color: Colors.amberAccent, size: 32),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lengthCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Filament Length (Meters)',
                        prefixIcon: Icon(Icons.straighten, color: Colors.amberAccent),
                        suffixText: 'm',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _calculateWeightFromLength(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Density Quick Reference
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Material Density Table Reference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.tealAccent)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: kMaterialPresets.map((mat) {
                        return Chip(
                          backgroundColor: const Color(0xFF2A343B),
                          label: Text('${mat.name}: ${mat.density} g/cm³', style: const TextStyle(fontSize: 11)),
                        );
                      }).toList(),
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
}

class QuoteHistoryTab extends StatelessWidget {
  final List<QuoteItem> quotes;
  final Function(String) onDeleteQuote;

  const QuoteHistoryTab({
    super.key,
    required this.quotes,
    required this.onDeleteQuote,
  });

  @override
  Widget build(BuildContext context) {
    final totalRevenue = quotes.fold<double>(0.0, (sum, item) => sum + item.quotePrice);
    final totalProfit = quotes.fold<double>(0.0, (sum, item) => sum + item.profit);

    return SafeArea(
      child: Column(
        children: [
          // Header Total Stats Banner
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF1E272C),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Quoted Revenue', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${totalRevenue.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 30, width: 1, color: Colors.white24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Projected Total Profit', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '\$${totalProfit.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List body
          Expanded(
            child: quotes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'No Saved Quotes Yet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Calculate a 3D print quote and tap "Save Quote" to keep history here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: quotes.length,
                    itemBuilder: (ctx, index) {
                      final item = quotes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.withOpacity(0.2),
                            child: const Icon(Icons.view_in_ar, color: Colors.tealAccent),
                          ),
                          title: Text(
                            item.projectName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '${item.materialName} • ${item.weightGrams.toStringAsFixed(0)}g • ${item.printHours.toStringAsFixed(1)}h',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${item.quotePrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.tealAccent),
                              ),
                              Text(
                                '+\$${item.profit.toStringAsFixed(2)} profit',
                                style: const TextStyle(fontSize: 11, color: Colors.greenAccent),
                              ),
                            ],
                          ),
                          onTap: () => _showQuoteDetailModal(context, item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showQuoteDetailModal(BuildContext context, QuoteItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E272C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.projectName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        onDeleteQuote(item.id);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                _buildModalDetailRow('Material Type', item.materialName),
                _buildModalDetailRow('Used Weight', '${item.weightGrams.toStringAsFixed(1)} grams'),
                _buildModalDetailRow('Print Duration', '${item.printHours.toStringAsFixed(1)} hours'),
                _buildModalDetailRow('Base Production Cost', '\$${item.totalCost.toStringAsFixed(2)}'),
                _buildModalDetailRow('Final Retail Quote', '\$${item.quotePrice.toStringAsFixed(2)}', isBold: true, color: Colors.tealAccent),
                _buildModalDetailRow('Net Profit Margin', '\$${item.profit.toStringAsFixed(2)}', isBold: true, color: Colors.greenAccent),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.copy, color: Colors.white),
                    label: const Text('Copy Quick Summary', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      final summaryText = 'Quote for ${item.projectName}: \$${item.quotePrice.toStringAsFixed(2)} (${item.materialName}, ${item.weightGrams.toStringAsFixed(0)}g)';
                      Clipboard.setData(ClipboardData(text: summaryText));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quote summary copied!'), backgroundColor: Colors.teal),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 15 : 13,
              color: color ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}