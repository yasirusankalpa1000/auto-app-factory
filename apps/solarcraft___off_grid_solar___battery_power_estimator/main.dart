import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SolarCraftApp());
}

class SolarCraftApp extends StatelessWidget {
  const SolarCraftApp({super.key});

  @override
  Widget build(BuildContext me) {
    return MaterialApp(
      title: 'SolarCraft',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101418),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
          surface: const Color(0xFF1A2026),
          primary: Colors.amber,
          secondary: Colors.tealAccent,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E2630),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.amber.withOpacity(0.15)),
          ),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class Appliance {
  String id;
  String name;
  double watts;
  double hoursPerDay;
  int quantity;

  Appliance({
    required this.id,
    required this.name,
    required this.watts,
    required this.hoursPerDay,
    this.quantity = 1,
  });

  double get dailyWh => watts * hoursPerDay * quantity;
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> meState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedTabIndex = 0;

  // Appliances state
  final List<Appliance> _appliances = [
    Appliance(id: '1', name: 'LED Bulbs', watts: 10, hoursPerDay: 5, quantity: 4),
    Appliance(id: '2', name: 'Refrigerator', watts: 120, hoursPerDay: 9, quantity: 1),
    Appliance(id: '3', name: 'Laptop Computer', watts: 65, hoursPerDay: 6, quantity: 1),
    Appliance(id: '4', name: 'Wi-Fi Router', watts: 12, hoursPerDay: 24, quantity: 1),
  ];

  // System Sizing Configuration
  double _peakSunHours = 4.5;
  int _systemVoltage = 24; // 12, 24, or 48V
  int _autonomyDays = 2; // Days of backup power
  String _batteryType = 'LiFePO4'; // LiFePO4 (80% DoD) vs Lead-Acid (50% DoD)
  int _panelWattage = 400; // Individual panel wattage

  // Financial Configuration
  double _panelCostPerWatt = 0.75; // \$ per Watt
  double _batteryCostPerKWh = 300.0; // \$ per kWh storage
  double _inverterCost = 450.0; // Fixed inverter/wiring cost
  double _gridElectricRate = 0.18; // \$ per kWh

  // Calculations
  double get _totalDailyWh {
    double total = 0;
    for (var a in _appliances) {
      total += a.dailyWh;
    }
    return total;
  }

  double get _totalPeakWatts {
    double total = 0;
    for (var a in _appliances) {
      total += (a.watts * a.quantity);
    }
    return total;
  }

  // Solar system requirements calculation logic
  double get _systemEfficiencyFactor => 1.25; // 25% efficiency loss fudge factor
  double get _adjustedDailyWh => _totalDailyWh * _systemEfficiencyFactor;

  double get _requiredSolarArrayWatts {
    if (_peakSunHours <= 0) return 0;
    return _adjustedDailyWh / _peakSunHours;
  }

  int get _calculatedPanelCount {
    if (_panelWattage <= 0) return 0;
    return (_requiredSolarArrayWatts / _panelWattage).ceil();
  }

  double get _batteryDepthOfDischarge => _batteryType == 'LiFePO4' ? 0.80 : 0.50;

  double get _requiredBatteryWh {
    return (_totalDailyWh * _autonomyDays) / _batteryDepthOfDischarge;
  }

  double get _requiredBatteryAh {
    return _requiredBatteryWh / _systemVoltage;
  }

  double get _recommendedInverterWatts => _totalPeakWatts * 1.30; // 30% safety margin

  double get _recommendedMpptAmps {
    double totalArrayPower = _calculatedPanelCount * _panelWattage.toDouble();
    return totalArrayPower / _systemVoltage;
  }

  // Financial calculations
  double get _estimatedSolarCost => _calculatedPanelCount * _panelWattage * _panelCostPerWatt;
  double get _estimatedBatteryCost => (_requiredBatteryWh / 1000.0) * _batteryCostPerKWh;
  double get _totalSystemCost => _estimatedSolarCost + _estimatedBatteryCost + _inverterCost;

  double get _annualGridSavings => (_totalDailyWh / 1000.0) * 365 * _gridElectricRate;
  double get _paybackYears => _annualGridSavings > 0 ? (_totalSystemCost / _annualGridSavings) : 0;

  void _addAppliance(String name, double watts, double hours, int quantity) {
    setState(() {
      _appliances.add(Appliance(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        watts: watts,
        hoursPerDay: hours,
        quantity: quantity,
      ));
    });
  }

  void _removeAppliance(String id) {
    setState(() {
      _appliances.removeWhere((item) => item.id == id);
    });
  }

  void _showAddApplianceDialog() {
    final nameController = TextEditingController();
    final wattsController = TextEditingController();
    final hoursController = TextEditingController(text: "4");
    final qtyController = TextEditingController(text: "1");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E2630),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_circle, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Text(
                      'Add Electrical Appliance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Appliance Name (e.g., Mini Fridge)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: wattsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Power Rating (Watts)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: hoursController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Hours / Day',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final name = nameController.text.trim();
                      final watts = double.tryParse(wattsController.text) ?? 0;
                      final hours = double.tryParse(hoursController.text) ?? 0;
                      final qty = int.tryParse(qtyController.text) ?? 1;

                      if (name.isNotEmpty && watts > 0 && hours > 0) {
                        _addAppliance(name, watts, hours, qty);
                        Navigator.of(ctx).pop();
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Add Load to List', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _copySummaryReport() {
    final buffer = StringBuffer();
    buffer.writeln('=== SOLARCRAFT POWER SYSTEM SPECIFICATION ===');
    buffer.writeln('Daily Energy Usage: ${(_totalDailyWh / 1000).toStringAsFixed(2)} kWh/day');
    buffer.writeln('Peak Demand Load: ${_totalPeakWatts.toStringAsFixed(0)} Watts');
    buffer.writeln('-------------------------------------------');
    buffer.writeln('RECOMMENDED SYSTEM PARAMETERS:');
    buffer.writeln('- Solar Array: ${_calculatedPanelCount} x ${_panelWattage}W Panels (Total ${(_calculatedPanelCount * _panelWattage)}W)');
    buffer.writeln('- Peak Sun Hours Assumed: $_peakSunHours hrs/day');
    buffer.writeln('- Battery Storage: ${_requiredBatteryAh.toStringAsFixed(0)} Ah @ ${_systemVoltage}V (${(_requiredBatteryWh / 1000).toStringAsFixed(2)} kWh)');
    buffer.writeln('- Battery Chemistry: $_batteryType (DoD: ${(_batteryDepthOfDischarge * 100).toInt()}%)');
    buffer.writeln('- Autonomy Backup Days: $_autonomyDays Days');
    buffer.writeln('- Minimum Pure Sine Inverter: ${_recommendedInverterWatts.toStringAsFixed(0)} W');
    buffer.writeln('- Minimum MPPT Controller: ${_recommendedMpptAmps.toStringAsFixed(0)} Amps');
    buffer.writeln('-------------------------------------------');
    buffer.writeln('FINANCIAL ESTIMATES:');
    buffer.writeln('- Estimated Solar Array Cost: \$${_estimatedSolarCost.toStringAsFixed(2)}');
    buffer.writeln('- Estimated Battery Cost: \$${_estimatedBatteryCost.toStringAsFixed(2)}');
    buffer.writeln('- Total Setup Investment: \$${_totalSystemCost.toStringAsFixed(2)}');
    buffer.writeln('- Projected Annual Utility Savings: \$${_annualGridSavings.toStringAsFixed(2)}');
    buffer.writeln('- Estimated ROI Payback Period: ${_paybackYears.toStringAsFixed(1)} Years');

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Full System Specification copied to clipboard!'),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.wb_sunny, color: Colors.amber),
            SizedBox(width: 10),
            Text(
              'SolarCraft',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Copy System Specification',
            onPressed: _copySummaryReport,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Appliances',
            onPressed: () {
              setState(() {
                _appliances.clear();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildLoadCalculatorTab(),
            _buildSolarSizingTab(),
            _buildFinancialTab(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.power),
            selectedIcon: Icon(Icons.power, color: Colors.amber),
            label: '1. Loads',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny, color: Colors.amber),
            label: '2. Solar & Battery',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            selectedIcon: Icon(Icons.attach_money, color: Colors.amber),
            label: '3. Cost & ROI',
          ),
        ],
      ),
    );
  }

  // --- TAB 1: DAILY LOAD CALCULATOR ---
  Widget _buildLoadCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Header summary badge
          Card(
            color: const Color(0xFF262F3D),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        const Text(
                          'DAILY ENERGY CONSUMPTION',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${(_totalDailyWh / 1000).toStringAsFixed(2)} kWh/day',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Text(
                          '(${_totalDailyWh.toStringAsFixed(0)} Watt-Hours)',
                          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 48, color: Colors.grey[700]),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        const Text(
                          'PEAK SURGE DEMAND',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${_totalPeakWatts.toStringAsFixed(0)} W',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Text(
                          'Max Concurrent Power',
                          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preset Chips Row
          const Text(
            'Quick Add Presets:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetChip('LED Bulb', 10, 5),
                _buildPresetChip('TV 43"', 80, 4),
                _buildPresetChip('Ceiling Fan', 60, 8),
                _buildPresetChip('Starlink Satellite', 50, 24),
                _buildPresetChip('Portable AC', 900, 4),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Appliances List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appliances (${_appliances.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: _showAddApplianceDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Custom Load'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_appliances.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Icon(Icons.power_off, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 12),
                    const Text(
                      'No appliances added yet.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap "Add Custom Load" or select a preset above.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _appliances.length,
              itemBuilder: (ctx, index) {
                final item = _appliances[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.electric_bolt, color: Colors.amber, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${item.watts.toStringAsFixed(0)}W × ${item.quantity} unit(s)',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAlignment.end,
                              children: [
                                Text(
                                  '${(item.dailyWh / 1000).toStringAsFixed(2)} kWh/day',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                                ),
                                Text(
                                  '${item.dailyWh.toStringAsFixed(0)} Wh/day',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () => _removeAppliance(item.id),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          children: [
                            const Text('Hours/Day:', style: TextStyle(fontSize: 12)),
                            Expanded(
                              child: Slider(
                                value: item.hoursPerDay,
                                min: 0.5,
                                max: 24.0,
                                divisions: 47,
                                label: '${item.hoursPerDay} hrs',
                                activeColor: Colors.amber,
                                onChanged: (val) {
                                  setState(() {
                                    item.hoursPerDay = val;
                                  });
                                },
                              ),
                            ),
                            Text(
                              '${item.hoursPerDay}h',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        setState(() {
                                          item.quantity--;
                                        });
                                      }
                                    },
                                  ),
                                  Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, double watts, double hours) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: const Icon(Icons.add, size: 16, color: Colors.amber),
        label: Text(label),
        backgroundColor: const Color(0xFF1E2630),
        onPressed: () {
          _addAppliance(label, watts, hours, 1);
        },
      ),
    );
  }

  // --- TAB 2: SOLAR ARRAY & BATTERY SIZING ---
  Widget _buildSolarSizingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text(
            'System Parameters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Controls Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  // Peak Sun Hours Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Peak Sun Hours / Day:'),
                      Text(
                        '$_peakSunHours Hours',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  Slider(
                    value: _peakSunHours,
                    min: 1.0,
                    max: 8.0,
                    divisions: 14,
                    label: '$_peakSunHours hrs',
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        _peakSunHours = val;
                      });
                    },
                  ),
                  const Text(
                    'Average daily peak solar hours for your region (typically 3.5 - 5.5 hrs).',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const Divider(height: 24),

                  // System Voltage Dropdown/Segmented
                  const Text('System Battery Voltage:', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [12, 24, 48].map((v) {
                      final selected = _systemVoltage == v;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text('${v}V System', textAlign: TextAlign.center),
                            selected: selected,
                            selectedColor: Colors.amber,
                            labelStyle: TextStyle(
                              color: selected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (bool sel) {
                              if (sel) {
                                setState(() {
                                  _systemVoltage = v;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 24),

                  // Autonomy & Battery Type
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            const Text('Autonomy Days (Backup):', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<int>(
                              value: _autonomyDays,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              items: [1, 2, 3, 4, 5].map((d) {
                                return DropdownMenuItem(value: d, child: Text('$d Day(s)'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _autonomyDays = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            const Text('Battery Chemistry:', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _batteryType,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'LiFePO4', child: Text('LiFePO4 (80% DoD)')),
                                DropdownMenuItem(value: 'Lead-Acid', child: Text('Lead-Acid (50% DoD)')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _batteryType = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Individual Panel Wattage Selection
                  Row(
                    children: [
                      const Text('Single Panel Wattage: '),
                      const Spacer(),
                      DropdownButton<int>(
                        value: _panelWattage,
                        items: [100, 200, 300, 400, 450, 550].map((w) {
                          return DropdownMenuItem(value: w, child: Text('${w}W Panel'));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _panelWattage = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Output Recommendations Section
          const Text(
            'Recommended System Sizing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 1. Solar Panel Requirement Card
          Card(
            color: const Color(0xFF1E2F23),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.wb_sunny, color: Colors.yellow, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Solar Panel Array Requirements',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.yellow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricTile(
                        'Total Solar Power',
                        '${_requiredSolarArrayWatts.toStringAsFixed(0)} Watts',
                        'Includes 25% efficiency factor',
                      ),
                      _buildMetricTile(
                        'Panel Count',
                        '$_calculatedPanelCount × ${_panelWattage}W',
                        'Total: ${(_calculatedPanelCount * _panelWattage)} Watts',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Battery Storage Requirement Card
          Card(
            color: const Color(0xFF1E2B38),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.battery_charging_full, color: Colors.tealAccent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Battery Bank Storage Requirements',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricTile(
                        'Amp-Hour Rating',
                        '${_requiredBatteryAh.toStringAsFixed(0)} Ah',
                        'Rated @ ${_systemVoltage}V System',
                      ),
                      _buildMetricTile(
                        'Capacity Watt-Hours',
                        '${(_requiredBatteryWh / 1000).toStringAsFixed(2)} kWh',
                        '${_autonomyDays} Days Autonomy ($_batteryType)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 3. Hardware Component Sizing Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.build, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Inverter & MPPT Controller Recommendations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              const Text('Pure Sine Inverter:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '≥ ${_recommendedInverterWatts.toStringAsFixed(0)} Watts',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                              ),
                              const SizedBox(height: 2),
                              const Text('30% surge safety headroom', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              const Text('MPPT Charge Controller:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '≥ ${_recommendedMpptAmps.toStringAsFixed(0)} Amps',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.tealAccent),
                              ),
                              const SizedBox(height: 2),
                              Text('Based on ${_systemVoltage}V System', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String mainVal, String subVal) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              mainVal,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 2),
          Text(subVal, style: TextStyle(fontSize: 10, color: Colors.grey[400])),
        ],
      ),
    );
  }

  // --- TAB 3: FINANCIAL & PAYBACK ANALYSIS ---
  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Text(
            'Equipment Cost Estimation Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            const Text('Solar Panel Cost (\$/Watt):', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              controller: TextEditingController(text: _panelCostPerWatt.toString()),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null) setState(() => _panelCostPerWatt = parsed);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            const Text('Battery Cost (\$/kWh):', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              controller: TextEditingController(text: _batteryCostPerKWh.toString()),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null) setState(() => _batteryCostPerKWh = parsed);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            const Text('Inverter & Cables Cost (\$) :', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              controller: TextEditingController(text: _inverterCost.toString()),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null) setState(() => _inverterCost = parsed);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            const Text('Grid Power Cost (\$/kWh):', style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 4),
                            TextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                prefixText: '\$ ',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              controller: TextEditingController(text: _gridElectricRate.toString()),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null) setState(() => _gridElectricRate = parsed);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Financial Investment & ROI Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            color: const Color(0xFF232D38),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCostRow('Solar Panels (${_calculatedPanelCount} x ${_panelWattage}W)', '\$${_estimatedSolarCost.toStringAsFixed(2)}'),
                  const Divider(height: 16),
                  _buildCostRow('Battery Storage (${(_requiredBatteryWh / 1000).toStringAsFixed(2)} kWh)', '\$${_estimatedBatteryCost.toStringAsFixed(2)}'),
                  const Divider(height: 16),
                  _buildCostRow('Inverter, Controller & Hardware', '\$${_inverterCost.toStringAsFixed(2)}'),
                  const Divider(height: 24, thickness: 2, color: Colors.amber),
                  _buildCostRow('ESTIMATED INITIAL SETUP COST', '\$${_totalSystemCost.toStringAsFixed(2)}', isBold: true, fontSize: 16, color: Colors.amber),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Savings & Payback Metrics
          Row(
            children: [
              Expanded(
                child: Card(
                  color: const Color(0xFF1E2E2A),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        const Text('ANNUAL SAVINGS', style: TextStyle(fontSize: 11, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${_annualGridSavings.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('vs utility grid electricity', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  color: const Color(0xFF33291A),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        const Text('ROI PAYBACK PERIOD', style: TextStyle(fontSize: 11, color: Colors.amber, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${_paybackYears.toStringAsFixed(1)} Years',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('100% investment break-even', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Button to Copy Specification Text
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _copySummaryReport,
              icon: const Icon(Icons.copy),
              label: const Text(
                'Copy System Spec Summary',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isBold = false, double fontSize = 14, Color color = Colors.white}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize,
              color: isBold ? color : Colors.grey[300],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: fontSize,
            color: color,
          ),
        ),
      ],
    );
  }
}