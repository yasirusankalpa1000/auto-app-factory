import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SnapSettleApp());
}

class SnapSettleApp extends StatelessWidget {
  const SnapSettleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapSettle Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
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
  int _currentTabIndex = 0;
  
  // Floating Assistant Dock Position
  Offset _dockPosition = const Offset(20, 120);

  // Bill Splitter State Variables
  final TextEditingController _billAmountController = TextEditingController(text: "45.00");
  double _taxPercent = 10.0;
  double _tipPercent = 15.0;
  int _peopleCount = 3;

  // Text Formatter State Variables
  final TextEditingController _formatTitleController = TextEditingController(text: "Weekend Trip Expenses");
  final TextEditingController _formatItemsController = TextEditingController(text: "Dinner: \$30\nGas: \$25\nSnacks: \$15");
  String _formattedResult = "";
  String _selectedTemplate = "WhatsApp Bill";

  // Micro-IOU State Variables
  final List<Map<String, dynamic>> _iouList = [
    {"from": "Alex", "to": "Sarah", "amount": 15.0, "note": "Lunch"},
    {"from": "Sarah", "to": "David", "amount": 25.0, "note": "Movie Tickets"},
    {"from": "David", "to": "Alex", "amount": 10.0, "note": "Coffee"},
  ];
  final TextEditingController _iouFromController = TextEditingController();
  final TextEditingController _iouToController = TextEditingController();
  final TextEditingController _iouAmountController = TextEditingController();
  final TextEditingController _iouNoteController = TextEditingController();

  // Impulse Evaluator State Variables
  final TextEditingController _monthlyIncomeController = TextEditingController(text: "3000");
  final TextEditingController _itemCostController = TextEditingController(text: "250");
  int _workingHoursPerWeek = 40;

  @override
  void initState() {
    super.initState();
    _generateFormattedText();
  }

  @override
  void dispose() {
    _billAmountController.dispose();
    _formatTitleController.dispose();
    _formatItemsController.dispose();
    _iouFromController.dispose();
    _iouToController.dispose();
    _iouAmountController.dispose();
    _iouNoteController.dispose();
    _monthlyIncomeController.dispose();
    _itemCostController.dispose();
    super.dispose();
  }

  void _generateFormattedText() {
    final title = _formatTitleController.text.trim();
    final items = _formatItemsController.text.trim().split('\n');
    final buffer = StringBuffer();

    if (_selectedTemplate == "WhatsApp Bill") {
      buffer.writeln("🧾 *${title.isEmpty ? 'SUMMARY RECEIPT' : title.toUpperCase()}*");
      buffer.writeln("--------------------------------");
      for (var item in items) {
        if (item.trim().isNotEmpty) {
          buffer.writeln("• ${item.trim()}");
        }
      }
      buffer.writeln("--------------------------------");
      buffer.writeln("📌 *Please settle your share promptly!*");
      buffer.writeln("Sent via SnapSettle Pro 🚀");
    } else if (_selectedTemplate == "Meeting Agenda") {
      buffer.writeln("📅 *AGENDA: ${title.isEmpty ? 'TEAM SYNC' : title.toUpperCase()}*");
      buffer.writeln("--------------------------------");
      int index = 1;
      for (var item in items) {
        if (item.trim().isNotEmpty) {
          buffer.writeln("*$index.* ${item.trim()}");
          index++;
        }
      }
      buffer.writeln("--------------------------------");
      buffer.writeln("💡 _Please arrive 5 minutes early._");
    } else {
      buffer.writeln("📌 *${title.isEmpty ? 'NOTES' : title.toUpperCase()}*");
      for (var item in items) {
        if (item.trim().isNotEmpty) {
          buffer.writeln("▫️ ${item.trim()}");
        }
      }
    }

    setState(() {
      _formattedResult = buffer.toString();
    });
  }

  void _addIou() {
    final from = _iouFromController.text.trim();
    final to = _iouToController.text.trim();
    final amount = double.tryParse(_iouAmountController.text) ?? 0.0;
    final note = _iouNoteController.text.trim();

    if (from.isNotEmpty && to.isNotEmpty && amount > 0) {
      setState(() {
        _iouList.add({"from": from, "to": to, "amount": amount, "note": note.isEmpty ? "Debt" : note});
        _iouFromController.clear();
        _iouToController.clear();
        _iouAmountController.clear();
        _iouNoteController.clear();
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("IOU Added to Ledger!"), backgroundColor: Colors.teal),
      );
    }
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.teal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("SnapSettle Pro", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _copyToClipboard("Try SnapSettle Pro - The ultimate daily utility app!", "App link copied!");
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildBillSplitterTab(),
                _buildTextFormatterTab(),
                _buildIouLedgerTab(),
                _buildImpulseEvaluatorTab(),
              ],
            ),
          ),
          // Draggable Floating Assistant Dock Overlay
          Positioned(
            left: _dockPosition.dx,
            top: _dockPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  double newX = _dockPosition.dx + details.delta.dx;
                  double newY = _dockPosition.dy + details.delta.dy;
                  // Screen boundary constraints
                  newX = newX.clamp(0.0, size.width - 65.0);
                  newY = newY.clamp(0.0, size.height - 180.0);
                  _dockPosition = Offset(newX, newY);
                });
              },
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(30),
                color: Colors.indigo,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white70, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.drag_handle, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() => _currentTabIndex = 0);
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: _currentTabIndex == 0 ? Colors.teal : Colors.white70,
                          child: const Icon(Icons.receipt, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() => _currentTabIndex = 1);
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: _currentTabIndex == 1 ? Colors.teal : Colors.white70,
                          child: const Icon(Icons.text_fields, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() => _currentTabIndex = 2);
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: _currentTabIndex == 2 ? Colors.teal : Colors.white70,
                          child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Bill Split"),
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: "Formatter"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "IOU Ledger"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Impulse Check"),
        ],
      ),
    );
  }

  // --- TAB 1: BILL SPLITTER ---
  Widget _buildBillSplitterTab() {
    final double rawAmount = double.tryParse(_billAmountController.text) ?? 0.0;
    final double taxAmount = rawAmount * (_taxPercent / 100);
    final double tipAmount = rawAmount * (_tipPercent / 100);
    final double totalAmount = rawAmount + taxAmount + tipAmount;
    final double perPersonAmount = _peopleCount > 0 ? totalAmount / _peopleCount : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.teal.shade50,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("TOTAL PER PERSON", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\$${perPersonAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.payment, size: 16, color: Colors.teal),
                        label: Text("Total: \$${totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.white,
                      ),
                      Chip(
                        avatar: const Icon(Icons.people, size: 16, color: Colors.teal),
                        label: Text("People: $_peopleCount", style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _billAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Base Bill Amount (\$) ",
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tax / VAT: ${_taxPercent.toStringAsFixed(0)}%", style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("+\$${taxAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Slider(
            value: _taxPercent,
            min: 0,
            max: 30,
            divisions: 30,
            activeColor: Colors.teal,
            label: "${_taxPercent.round()}%",
            onChanged: (val) => setState(() => _taxPercent = val),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tip: ${_tipPercent.toStringAsFixed(0)}%", style: const TextStyle(fontWeight: FontWeight.w600)),
              Text("+\$${tipAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Slider(
            value: _tipPercent,
            min: 0,
            max: 35,
            divisions: 35,
            activeColor: Colors.teal,
            label: "${_tipPercent.round()}%",
            onChanged: (val) => setState(() => _tipPercent = val),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Split Between", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _peopleCount > 1 ? () => setState(() => _peopleCount--) : null,
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                      ),
                      Text("$_peopleCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => setState(() => _peopleCount++),
                        icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.copy),
            label: const Text("Copy WhatsApp Receipt Text", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              final receiptText = "🧾 *SPLIT BILL SUMMARY*\n"
                  "Base Amount: \$${rawAmount.toStringAsFixed(2)}\n"
                  "Tax (${_taxPercent.toInt()}%): \$${taxAmount.toStringAsFixed(2)}\n"
                  "Tip (${_tipPercent.toInt()}%): \$${tipAmount.toStringAsFixed(2)}\n"
                  "----------------------------\n"
                  "💰 *Total Bill:* \$${totalAmount.toStringAsFixed(2)}\n"
                  "👥 *Split ($peopleCount people):* \$${perPersonAmount.toStringAsFixed(2)} each\n\n"
                  "Generated via SnapSettle Pro 🚀";
              _copyToClipboard(receiptText, "WhatsApp Receipt Copied!");
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 2: TEXT FORMATTER ---
  Widget _buildTextFormatterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Format Text for Chat Apps", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["WhatsApp Bill", "Meeting Agenda", "Simple Notes"].map((template) {
                final isSelected = _selectedTemplate == template;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(template),
                    selected: isSelected,
                    selectedColor: Colors.teal,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTemplate = template;
                          _generateFormattedText();
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _formatTitleController,
            decoration: const InputDecoration(
              labelText: "Title / Header",
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _generateFormattedText(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _formatItemsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "Items / Notes (One per line)",
              prefixIcon: Icon(Icons.list),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _generateFormattedText(),
          ),
          const SizedBox(height: 16),
          const Text("Live Formatted Output Preview:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              _formattedResult.isEmpty ? "Preview will appear here..." : _formattedResult,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.copy),
            label: const Text("Copy Formatted Text", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () => _copyToClipboard(_formattedResult, "Formatted Text Copied!"),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: MICRO-IOU LEDGER ---
  Widget _buildIouLedgerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Micro-IOU Ledger", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Add Debt"),
                onPressed: () => _showAddIouDialog(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _iouList.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: Text("No active debts in ledger. Add one!")),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _iouList.length,
                  itemBuilder: (context, index) {
                    final item = _iouList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: const Icon(Icons.swap_horiz, color: Colors.teal),
                        ),
                        title: Text("${item['from']} → ${item['to']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${item['note']} • \$${(item['amount'] as double).toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              _iouList.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("IOU Marked as Settled!"), backgroundColor: Colors.green),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(height: 16),
          Card(
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.indigo, size: 20),
                      SizedBox(width: 8),
                      Text("Smart Settlement Summary", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _calculateSmartSettlement(),
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateSmartSettlement() {
    if (_iouList.isEmpty) return "No active debts to calculate.";
    Map<String, double> balances = {};
    for (var item in _iouList) {
      final from = item['from'] as String;
      final to = item['to'] as String;
      final amount = item['amount'] as double;
      balances[from] = (balances[from] ?? 0) - amount;
      balances[to] = (balances[to] ?? 0) + amount;
    }

    final buffer = StringBuffer();
    balances.forEach((person, balance) {
      if (balance > 0) {
        buffer.writeln("• $person should RECEIVE \$${balance.toStringAsFixed(2)}");
      } else if (balance < 0) {
        buffer.writeln("• $person needs to PAY \$${(-balance).toStringAsFixed(2)}");
      }
    });

    return buffer.toString().trim();
  }

  void _showAddIouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New IOU"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _iouFromController,
                decoration: const InputDecoration(labelText: "Who Owes? (Debtor)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _iouToController,
                decoration: const InputDecoration(labelText: "Owed To? (Creditor)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _iouAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount (\$)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _iouNoteController,
                decoration: const InputDecoration(labelText: "Note (e.g., Dinner, Fuel)", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            onPressed: _addIou,
            child: const Text("Save Debt"),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: IMPULSE BUYER WORK-HOUR EVALUATOR ---
  Widget _buildImpulseEvaluatorTab() {
    final double income = double.tryParse(_monthlyIncomeController.text) ?? 0.0;
    final double cost = double.tryParse(_itemCostController.text) ?? 0.0;

    // Assuming 4.33 weeks per month
    final double totalMonthlyHours = _workingHoursPerWeek * 4.33;
    final double hourlyWage = totalMonthlyHours > 0 ? income / totalMonthlyHours : 0.0;
    final double requiredHours = hourlyWage > 0 ? cost / hourlyWage : 0.0;
    final double requiredDays = requiredHours / 8.0;

    String recommendation = "Looks Reasonable!";
    Color recColor = Colors.green;

    if (requiredHours > 40) {
      recommendation = "🚨 High Risk! Costs over 1 FULL WEEK of your life!";
      recColor = Colors.red;
    } else if (requiredHours > 16) {
      recommendation = "⚠️ Think Twice! Wait 48 hours before buying.";
      recColor = Colors.orange;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: recColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: recColor, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("WORK TIME COST EQUIVALENT", style: TextStyle(color: recColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${requiredHours.toStringAsFixed(1)} Work Hours",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: recColor),
                    ),
                  ),
                  Text("≈ ${requiredDays.toStringAsFixed(1)} Working Days", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Text(
                    recommendation,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: recColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _monthlyIncomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Your Monthly Net Income (\$)",
              prefixIcon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _itemCostController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Item Price (\$)",
              prefixIcon: Icon(Icons.shopping_cart),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text("Weekly Work Hours: $_workingHoursPerWeek hrs", style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _workingHoursPerWeek.toDouble(),
            min: 10,
            max: 80,
            divisions: 70,
            activeColor: Colors.teal,
            label: "$_workingHoursPerWeek hrs",
            onChanged: (val) => setState(() => _workingHoursPerWeek = val.round()),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Estimated Hourly Wage:"),
                      Text("\$${hourlyWage.toStringAsFixed(2)}/hr", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  const Text(
                    "💡 Tip: Before impulse buying, ask yourself: 'Would I spend X hours at my desk directly in exchange for this item?'",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About SnapSettle Pro"),
        content: const SingleChildScrollView(
          child: Text(
            "SnapSettle Pro is designed for high dynamic usage:\n\n"
            "• Split complex group bills with live tax and tip calculation.\n"
            "• Format social chat messages cleanly.\n"
            "• Track IOUs and simplify debts automatically.\n"
            "• Evaluate impulse purchases based on work time.\n"
            "• Use the draggable floating dock to navigate swiftly!",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Got It")),
        ],
      ),
    );
  }
}