import 'package:flutter/material.dart';

void main() {
  runApp(const ShrinkSenseApp());
}

class ShrinkSenseApp extends StatelessWidget {
  const ShrinkSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShrinkSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.dark,
          surface: const Color(0xFF111827),
          primary: const Color(0xFF14B8A6),
          secondary: const Color(0xFFF59E0B),
          error: const Color(0xFFEF4444),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class AuditRecord {
  final String id;
  final String name;
  final double oldPrice;
  final double oldQty;
  final double newPrice;
  final double newQty;
  final String unit;
  final DateTime date;

  AuditRecord({
    required this.id,
    required this.name,
    required this.oldPrice,
    required this.oldQty,
    required this.newPrice,
    required this.newQty,
    required this.unit,
    required this.date,
  });

  double get oldUnitPrice => oldQty > 0 ? oldPrice / oldQty : 0;
  double get newUnitPrice => newQty > 0 ? newPrice / newQty : 0;
  double get unitPriceInflationPct {
    if (oldUnitPrice == 0) return 0;
    return ((newUnitPrice - oldUnitPrice) / oldUnitPrice) * 100;
  }

  double get weightLossPct {
    if (oldQty == 0) return 0;
    return ((oldQty - newQty) / oldQty) * 100;
  }
}

class MatrixItem {
  String name;
  double price;
  double quantity;

  MatrixItem({required this.name, required this.price, required this.quantity});

  double get unitPrice => quantity > 0 ? price / quantity : 0;
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;

  // Controllers for Tab 1 (Shrinkflation Detector)
  final TextEditingController _itemNameController = TextEditingController(text: 'Breakfast Cereal');
  final TextEditingController _oldPriceController = TextEditingController(text: '4.99');
  final TextEditingController _oldQtyController = TextEditingController(text: '450');
  final TextEditingController _newPriceController = TextEditingController(text: '4.99');
  final TextEditingController _newQtyController = TextEditingController(text: '375');
  
  String _selectedUnit = 'g';
  final List<String> _units = ['g', 'ml', 'oz', 'lb', 'pcs'];

  // History Log
  final List<AuditRecord> _history = [];

  // Data for Tab 2 (Shelf Compare Matrix)
  String _matrixUnit = 'g';
  final List<MatrixItem> _matrixItems = [
    MatrixItem(name: 'Option A (Standard)', price: 3.49, quantity: 300),
    MatrixItem(name: 'Option B (Family Pack)', price: 7.99, quantity: 800),
    MatrixItem(name: 'Option C (Bulk Box)', price: 12.50, quantity: 1400),
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _oldPriceController.dispose();
    _oldQtyController.dispose();
    _newPriceController.dispose();
    _newQtyController.dispose();
    super.dispose();
  }

  void _saveCurrentAudit() {
    final oldP = double.tryParse(_oldPriceController.text) ?? 0;
    final oldQ = double.tryParse(_oldQtyController.text) ?? 0;
    final newP = double.tryParse(_newPriceController.text) ?? 0;
    final newQ = double.tryParse(_newQtyController.text) ?? 0;

    if (oldP <= 0 || oldQ <= 0 || newP <= 0 || newQ <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid positive numbers for price and size.')),
      );
      return;
    }

    final record = AuditRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _itemNameController.text.trim().isEmpty ? 'Unnamed Product' : _itemNameController.text.trim(),
      oldPrice: oldP,
      oldQty: oldQ,
      newPrice: newP,
      newQty: newQ,
      unit: _selectedUnit,
      date: DateTime.now(),
    );

    setState(() {
      _history.insert(0, record);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Audit saved to consumer defense log!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.scale, color: Color(0xFF14B8A6)),
            SizedBox(width: 8),
            Text(
              'ShrinkSense',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          )
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildShrinkflationDetectorTab(),
            _buildShelfCompareMatrixTab(),
            _buildAuditHistoryTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: const Color(0xFF14B8A6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Shrink Audit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shelf Matrix',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Scan History',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: SHRINKFLATION DETECTOR ---
  Widget _buildShrinkflationDetectorTab() {
    final oldP = double.tryParse(_oldPriceController.text) ?? 0;
    final oldQ = double.tryParse(_oldQtyController.text) ?? 0;
    final newP = double.tryParse(_newPriceController.text) ?? 0;
    final newQ = double.tryParse(_newQtyController.text) ?? 0;

    final oldUnitPrice = oldQ > 0 ? oldP / oldQ : 0.0;
    final newUnitPrice = newQ > 0 ? newP / newQ : 0.0;

    double inflationPct = 0.0;
    if (oldUnitPrice > 0) {
      inflationPct = ((newUnitPrice - oldUnitPrice) / oldUnitPrice) * 100;
    }

    double weightLossPct = 0.0;
    if (oldQ > 0) {
      weightLossPct = ((oldQ - newQ) / oldQ) * 100;
    }

    final isShrinkflation = weightLossPct > 0.1 && inflationPct > 0.1;
    final isDirectInflation = weightLossPct <= 0.1 && inflationPct > 0.1;
    final isGoodDeal = inflationPct < -0.1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unmask Hidden Package Shrinkage',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Compare previous box weight & price against current retail shelf items.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          // Item name input
          TextField(
            controller: _itemNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Product Name / Brand',
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.store, color: Color(0xFF14B8A6)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF14B8A6))),
            ),
          ),
          const SizedBox(height: 16),

          // Unit Selector Row
          Row(
            children: [
              const Text('Measurement Unit: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Wrap(
                spacing: 8,
                children: _units.map((unit) {
                  final isSelected = _selectedUnit == unit;
                  return ChoiceChip(
                    label: Text(unit, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF14B8A6),
                    backgroundColor: const Color(0xFF1F2937),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedUnit = unit);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Input Cards Row
          Row(
            children: [
              // OLD Item Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BEFORE (Original)', style: TextStyle(color: Color(0xFF14B8A6), fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _oldPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _oldQtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Size ($_selectedUnit)',
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // NEW Item Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NOW (Current Shelf)', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _newPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Price (\$)',
                          labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _newQtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Size ($_selectedUnit)',
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- ANALYSIS VERDICT CARD ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isShrinkflation
                  ? const Color(0xFF7F1D1D)
                  : (isDirectInflation
                      ? const Color(0xFF7C2D12)
                      : (isGoodDeal ? const Color(0xFF064E3B) : const Color(0xFF1F2937))),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isShrinkflation
                    ? const Color(0xFFEF4444)
                    : (isDirectInflation ? const Color(0xFFF97316) : Colors.teal),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isShrinkflation
                          ? Icons.warning_amber_rounded
                          : (isGoodDeal ? Icons.check_circle_outline : Icons.trending_up),
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isShrinkflation
                            ? 'SNEAKY SHRINKFLATION DETECTED!'
                            : (isDirectInflation
                                ? 'DIRECT PRICE INCREASE'
                                : (isGoodDeal ? 'GREAT CONSUMER DEAL!' : 'STABLE VALUE')),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),

                // Metrics grid
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('True Unit Inflation', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            '${inflationPct >= 0 ? "+" : ""}${inflationPct.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: inflationPct > 0 ? const Color(0xFFF87171) : const Color(0xFF34D399),
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hidden Size Loss', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            '${weightLossPct >= 0 ? "-" : "+"}${weightLossPct.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: weightLossPct > 0 ? const Color(0xFFF87171) : const Color(0xFF34D399),
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Unit Cost comparison
                Text(
                  'Original Unit Price: \$${oldUnitPrice.toStringAsFixed(4)} / $_selectedUnit\n'
                  'Current Unit Price: \$${newUnitPrice.toStringAsFixed(4)} / $_selectedUnit',
                  style: const TextStyle(color: Colors.white90, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _saveCurrentAudit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                'Save Audit to History',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: SHELF COMPARE MATRIX ---
  Widget _buildShelfCompareMatrixTab() {
    // Determine winner (lowest unit price)
    MatrixItem? bestItem;
    double minUnitPrice = double.infinity;

    for (var item in _matrixItems) {
      if (item.quantity > 0 && item.unitPrice > 0) {
        if (item.unitPrice < minUnitPrice) {
          minUnitPrice = item.unitPrice;
          bestItem = item;
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Multi-Size Shelf Matrix',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Compare 2 to 5 shelf options to uncover which box size gives you maximum real value.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            softWrap: true,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unit Label:', style: TextStyle(color: Colors.white)),
              DropdownButton<String>(
                value: _matrixUnit,
                dropdownColor: const Color(0xFF1F2937),
                style: const TextStyle(color: Color(0xFF14B8A6), fontWeight: FontWeight.bold),
                items: _units.map((u) {
                  return DropdownMenuItem(value: u, child: Text(u));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _matrixUnit = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _matrixItems.length,
            itemBuilder: (context, index) {
              final item = _matrixItems[index];
              final isWinner = bestItem == item && item.unitPrice > 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isWinner ? const Color(0xFF064E3B) : const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isWinner ? const Color(0xFF34D399) : Colors.transparent,
                    width: isWinner ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: item.name),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            onChanged: (val) => item.name = val,
                          ),
                        ),
                        if (isWinner)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF34D399),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'BEST VALUE',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                          onPressed: () {
                            if (_matrixItems.length > 2) {
                              setState(() => _matrixItems.removeAt(index));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Keep at least 2 shelf items to compare.')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            controller: TextEditingController(text: item.price > 0 ? item.price.toString() : ''),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Price (\$)',
                              labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (val) {
                              setState(() {
                                item.price = double.tryParse(val) ?? 0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            controller: TextEditingController(text: item.quantity > 0 ? item.quantity.toString() : ''),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Qty ($_matrixUnit)',
                              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (val) {
                              setState(() {
                                item.quantity = double.tryParse(val) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Unit Price: \$${item.unitPrice.toStringAsFixed(4)} / $_matrixUnit',
                        style: TextStyle(
                          color: isWinner ? const Color(0xFF34D399) : Colors.white70,
                          fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          if (_matrixItems.length < 5)
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _matrixItems.add(MatrixItem(
                    name: 'Option ${String.fromCharCode(65 + _matrixItems.length)}',
                    price: 0,
                    quantity: 0,
                  ));
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF14B8A6),
                side: const BorderSide(color: Color(0xFF14B8A6)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Shelf Package Option'),
            ),
        ],
      ),
    );
  }

  // --- TAB 3: SCAN HISTORY ---
  Widget _buildAuditHistoryTab() {
    if (_history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 16),
              const Text(
                'No Consumer Audits Saved',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Calculations saved from the Shrink Audit tab will appear here so you can track sneaky price hikes over time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Consumer Defense Log',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextButton(
                onPressed: () => setState(() => _history.clear()),
                child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              final isShrink = item.weightLossPct > 0.1 && item.unitPriceInflationPct > 0.1;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isShrink ? const Color(0xFFEF4444) : Colors.teal.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isShrink ? const Color(0xFF7F1D1D) : const Color(0xFF064E3B),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isShrink ? 'SHRINKFLATION' : 'AUDITED',
                            style: TextStyle(
                              color: isShrink ? const Color(0xFFF87171) : const Color(0xFF34D399),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Before: \$${item.oldPrice.toStringAsFixed(2)} / ${item.oldQty.toStringAsFixed(0)}${item.unit}\n'
                      'After: \$${item.newPrice.toStringAsFixed(2)} / ${item.newQty.toStringAsFixed(0)}${item.unit}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Real Unit Hike: ${item.unitPriceInflationPct >= 0 ? "+" : ""}${item.unitPriceInflationPct.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: item.unitPriceInflationPct > 0 ? const Color(0xFFF87171) : const Color(0xFF34D399),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                          onPressed: () {
                            setState(() {
                              _history.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text('About ShrinkSense', style: TextStyle(color: Colors.white)),
        content: const SingleChildScrollView(
          child: Text(
            'ShrinkSense helps shoppers protect their wallet against quiet package size reductions. Manufacturers often maintain price points while dropping product mass, hiding stealth price increases.\n\nUse this tool at grocery and retail stores to instantly calculate true inflation percentages.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It', style: TextStyle(color: Color(0xFF14B8A6))),
          )
        ],
      ),
    );
  }
}