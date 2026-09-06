import 'package:flutter/material.dart';

void main() {
  runApp(const FlexiQuoteApp());
}

class FlexiQuoteApp extends StatelessWidget {
  const FlexiQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlexiQuote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xF2F4F7FF),
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

// ==========================================
// MODELS
// ==========================================

class EstimateItem {
  String name;
  double hours;
  double hourlyRate;
  double fixedCost;

  EstimateItem({
    required this.name,
    this.hours = 0,
    this.hourlyRate = 0,
    this.fixedCost = 0,
  });

  double get total => fixedCost > 0 ? fixedCost : (hours * hourlyRate);
}

class ProjectEstimate {
  String id;
  String title;
  String clientName;
  DateTime date;
  List<EstimateItem> items;
  double taxRate;
  double contingencyMargin;
  String currency;

  ProjectEstimate({
    required this.id,
    required this.title,
    required this.clientName,
    required this.date,
    required this.items,
    this.taxRate = 10.0,
    this.contingencyMargin = 15.0,
    this.currency = '\$',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => subtotal * (taxRate / 100);
  double get contingencyAmount => subtotal * (contingencyMargin / 100);
  double get total => subtotal + taxAmount + contingencyAmount;
}

class Invoice {
  String id;
  String invoiceNum;
  String clientName;
  DateTime date;
  DateTime dueDate;
  String status; // 'Draft', 'Sent', 'Paid', 'Overdue'
  List<EstimateItem> items;
  double taxRate;
  String currency;

  Invoice({
    required this.id,
    required this.invoiceNum,
    required this.clientName,
    required this.date,
    required this.dueDate,
    required this.status,
    required this.items,
    this.taxRate = 10.0,
    this.currency = '\$',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => subtotal * (taxRate / 100);
  double get total => subtotal + taxAmount;
}

class Client {
  String id;
  String name;
  String company;
  String email;
  String currency;

  Client({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    this.currency = '\$',
  });
}

// ==========================================
// MAIN SCREEN & STATE MANAGEMENT
// ==========================================

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Client> _clients = [
    Client(
      id: 'c1',
      name: 'Sarah Jenkins',
      company: 'Apex Digital Solutions',
      email: 'sarah@apexdigital.com',
      currency: '\$',
    ),
    Client(
      id: 'c2',
      name: 'Marcus Vance',
      company: 'Vance Design Lab',
      email: 'marcus@vancedesign.io',
      currency: '\$',
    ),
    Client(
      id: 'c3',
      name: 'Elena Rostova',
      company: 'Global Tech Ventures',
      email: 'elena@gtv.com',
      currency: '\$',
    ),
  ];

  late List<ProjectEstimate> _estimates;
  late List<Invoice> _invoices;

  @override
  void initState() {
    super.initState();
    _estimates = [
      ProjectEstimate(
        id: 'e1',
        title: 'Mobile App Redesign & API',
        clientName: 'Apex Digital Solutions',
        date: DateTime.now().subtract(const Duration(days: 4)),
        currency: '\$',
        taxRate: 10.0,
        contingencyMargin: 15.0,
        items: [
          EstimateItem(name: 'UI/UX Mobile Design', hours: 25, hourlyRate: 85),
          EstimateItem(name: 'Flutter Development', hours: 60, hourlyRate: 95),
          EstimateItem(name: 'Backend API Integration', hours: 30, hourlyRate: 100),
          EstimateItem(name: 'QA & Deployment', fixedCost: 750),
        ],
      ),
      ProjectEstimate(
        id: 'e2',
        title: 'Brand Portal & CMS',
        clientName: 'Vance Design Lab',
        date: DateTime.now().subtract(const Duration(days: 12)),
        currency: '\$',
        taxRate: 8.0,
        contingencyMargin: 10.0,
        items: [
          EstimateItem(name: 'Custom CMS Theme', hours: 35, hourlyRate: 80),
          EstimateItem(name: 'Content Migration', fixedCost: 500),
        ],
      ),
    ];

    _invoices = [
      Invoice(
        id: 'i1',
        invoiceNum: 'INV-2025-001',
        clientName: 'Apex Digital Solutions',
        date: DateTime.now().subtract(const Duration(days: 10)),
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: 'Sent',
        currency: '\$',
        taxRate: 10.0,
        items: [
          EstimateItem(name: 'Mobile App Wireframes', hours: 20, hourlyRate: 85),
          EstimateItem(name: 'Architecture Setup', hours: 10, hourlyRate: 100),
        ],
      ),
      Invoice(
        id: 'i2',
        invoiceNum: 'INV-2025-002',
        clientName: 'Global Tech Ventures',
        date: DateTime.now().subtract(const Duration(days: 25)),
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'Paid',
        currency: '\$',
        taxRate: 10.0,
        items: [
          EstimateItem(name: 'Security Audit & Patching', fixedCost: 2200),
        ],
      ),
    ];
  }

  void _convertEstimateToInvoice(ProjectEstimate estimate) {
    final newInv = Invoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      invoiceNum: 'INV-2025-00${_invoices.length + 1}',
      clientName: estimate.clientName,
      date: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: 'Sent',
      taxRate: estimate.taxRate,
      currency: estimate.currency,
      items: estimate.items
          .map((i) => EstimateItem(
                name: i.name,
                hours: i.hours,
                hourlyRate: i.hourlyRate,
                fixedCost: i.fixedCost,
              ))
          .toList(),
    );

    setState(() {
      _invoices.add(newInv);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Converted "${estimate.title}" to Invoice ${newInv.invoiceNum}'),
        action: SnackBarAction(
          label: 'View Invoices',
          onPressed: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      EstimatesTab(
        estimates: _estimates,
        clients: _clients,
        onConvertToInvoice: _convertEstimateToInvoice,
        onAddEstimate: (newEst) {
          setState(() => _estimates.add(newEst));
        },
        onDeleteEstimate: (id) {
          setState(() => _estimates.removeWhere((e) => e.id == id));
        },
      ),
      InvoicesTab(
        invoices: _invoices,
        onStatusChange: (inv, newStatus) {
          setState(() => inv.status = newStatus);
        },
        onDeleteInvoice: (id) {
          setState(() => _invoices.removeWhere((i) => i.id == id));
        },
      ),
      const RateCalculatorTab(),
      ClientsTab(
        clients: _clients,
        onAddClient: (newClient) {
          setState(() => _clients.add(newClient));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.monetization_on, color: Colors.indigo),
            SizedBox(width: 8),
            Text(
              'FlexiQuote Studio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => _showAboutAppDialog(context),
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Estimates',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt),
            label: 'Invoices',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Rate Calc',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
        ],
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.indigo),
            SizedBox(width: 8),
            Text('About FlexiQuote'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FlexiQuote is an all-in-one suite for independent contractors, freelancers, and small dev teams.',
              ),
              SizedBox(height: 12),
              Text(
                'Key Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text('• Build itemized project quotes with hourly & fixed pricing.'),
              Text('• One-tap invoice generation with automatic tax calculations.'),
              Text('• Real-time target hourly rate calculator based on overhead & expenses.'),
              Text('• Client directory tracking.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: PROJECT ESTIMATES
// ==========================================

class EstimatesTab extends StatefulWidget {
  final List<ProjectEstimate> estimates;
  final List<Client> clients;
  final Function(ProjectEstimate) onConvertToInvoice;
  final Function(ProjectEstimate) onAddEstimate;
  final Function(String) onDeleteEstimate;

  const EstimatesTab({
    super.key,
    required this.estimates,
    required this.clients,
    required this.onConvertToInvoice,
    required this.onAddEstimate,
    required this.onDeleteEstimate,
  });

  @override
  State<EstimatesTab> createState() => _EstimatesTabState();
}

class _EstimatesTabState extends State<EstimatesTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.estimates.where((e) {
      return e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.clientName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search estimates or clients...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _openCreateEstimateModal(context),
                  icon: const Icon(Icons.add),
                  label: const Text('New'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No Project Estimates Found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final est = filtered[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: const Icon(Icons.calculate, color: Colors.indigo),
                          ),
                          title: Text(
                            est.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${est.clientName} • ${_formatDate(est.date)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: FittedBox(
                            child: Text(
                              '${est.currency}\$${est.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Itemized Breakdown:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...est.items.map((item) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              item.fixedCost > 0
                                                  ? 'Fixed: \$${item.fixedCost.toStringAsFixed(2)}'
                                                  : '${item.hours} hrs @ \$${item.hourlyRate}/hr',
                                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '\$${item.total.toStringAsFixed(2)}',
                                              style: const TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )),
                                  const Divider(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Subtotal:'),
                                      Text('\$${est.subtotal.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Tax (${est.taxRate}%):'),
                                      Text('\$${est.taxAmount.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Contingency (${est.contingencyMargin}%):'),
                                      Text('\$${est.contingencyAmount.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () => widget.onConvertToInvoice(est),
                                        icon: const Icon(Icons.receipt, size: 16),
                                        label: const Text('Convert to Invoice'),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => widget.onDeleteEstimate(est.id),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openCreateEstimateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => CreateEstimateSheet(
        clients: widget.clients,
        onSave: (est) {
          widget.onAddEstimate(est);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

// ==========================================
// CREATE ESTIMATE MODAL SHEET
// ==========================================

class CreateEstimateSheet extends StatefulWidget {
  final List<Client> clients;
  final Function(ProjectEstimate) onSave;

  const CreateEstimateSheet({
    super.key,
    required this.clients,
    required this.onSave,
  });

  @override
  State<CreateEstimateSheet> createState() => _CreateEstimateSheetState();
}

class _CreateEstimateSheetState extends State<CreateEstimateSheet> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _selectedClient = '';
  double _taxRate = 10.0;
  double _contingency = 15.0;
  final List<EstimateItem> _items = [];

  // Temporary controllers for item addition
  final _itemNameCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();
  final _rateCtrl = TextEditingController(text: '85');
  final _fixedCostCtrl = TextEditingController();
  bool _isFixed = false;

  @override
  void initState() {
    super.initState();
    if (widget.clients.isNotEmpty) {
      _selectedClient = widget.clients.first.company;
    }
  }

  void _addItem() {
    final name = _itemNameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() {
      if (_isFixed) {
        final fc = double.tryParse(_fixedCostCtrl.text) ?? 0.0;
        _items.add(EstimateItem(name: name, fixedCost: fc));
      } else {
        final h = double.tryParse(_hoursCtrl.text) ?? 0.0;
        final r = double.tryParse(_rateCtrl.text) ?? 0.0;
        _items.add(EstimateItem(name: name, hours: h, hourlyRate: r));
      }
      _itemNameCtrl.clear();
      _hoursCtrl.clear();
      _fixedCostCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: bottomInset + 20,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Project Estimate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Project Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  onSaved: (v) => _title = v ?? '',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedClient.isEmpty ? null : _selectedClient,
                  decoration: const InputDecoration(
                    labelText: 'Client',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.clients
                      .map((c) => DropdownMenuItem(
                            value: c.company,
                            child: Text(c.company),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedClient = val);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: '10',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tax Rate %',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (v) => _taxRate = double.tryParse(v ?? '10') ?? 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: '15',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Contingency %',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (v) => _contingency = double.tryParse(v ?? '15') ?? 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Line Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                ..._items.map((it) => Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        dense: true,
                        title: Text(it.name),
                        subtitle: Text(
                          it.fixedCost > 0
                              ? 'Fixed: \$${it.fixedCost.toStringAsFixed(2)}'
                              : '${it.hours} hrs @ \$${it.hourlyRate}/hr',
                        ),
                        trailing: Text(
                          '\$${it.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Card(
                  color: Colors.indigo.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _itemNameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Item Name',
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text(_isFixed ? 'Fixed Cost' : 'Hourly'),
                              selected: _isFixed,
                              onSelected: (val) {
                                setState(() => _isFixed = val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isFixed) ...[
                          TextField(
                            controller: _fixedCostCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Fixed Price (\$) ',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _hoursCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Hours',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _rateCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Rate (\$/hr)',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: _addItem,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Item'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Add at least 1 line item!')),
                          );
                          return;
                        }
                        final newEstimate = ProjectEstimate(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _title,
                          clientName: _selectedClient.isEmpty ? 'General Client' : _selectedClient,
                          date: DateTime.now(),
                          items: List.from(_items),
                          taxRate: _taxRate,
                          contingencyMargin: _contingency,
                        );
                        widget.onSave(newEstimate);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save & Generate Estimate'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TAB 2: INVOICES MANAGEMENT
// ==========================================

class InvoicesTab extends StatefulWidget {
  final List<Invoice> invoices;
  final Function(Invoice, String) onStatusChange;
  final Function(String) onDeleteInvoice;

  const InvoicesTab({
    super.key,
    required this.invoices,
    required this.onStatusChange,
    required this.onDeleteInvoice,
  });

  @override
  State<InvoicesTab> createState() => _InvoicesTabState();
}

class _InvoicesTabState extends State<InvoicesTab> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.invoices.where((inv) {
      if (_selectedFilter == 'All') return true;
      return inv.status == _selectedFilter;
    }).toList();

    double totalPaid = widget.invoices
        .where((i) => i.status == 'Paid')
        .fold(0, (sum, item) => sum + item.total);

    double totalPending = widget.invoices
        .where((i) => i.status == 'Sent' || i.status == 'Overdue')
        .fold(0, (sum, item) => sum + item.total);

    return SafeArea(
      child: Column(
        children: [
          // Stat Summary Header Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.indigo.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Total Received',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            child: Text(
                              '\$${totalPaid.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 30, width: 1, color: Colors.white24),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Pending Revenue',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            child: Text(
                              '\$${totalPending.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Draft', 'Sent', 'Paid', 'Overdue'].map((status) {
                final isSelected = _selectedFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedFilter = status);
                    },
                    selectedColor: Colors.indigo.shade100,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Invoices List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'No Invoices Matching Filter',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final inv = filtered[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          onTap: () => _showInvoicePreviewDialog(context, inv),
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(inv.status).withOpacity(0.15),
                            child: Icon(Icons.receipt, color: _getStatusColor(inv.status)),
                          ),
                          title: Text(
                            '${inv.invoiceNum} • ${inv.clientName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('Due: ${_formatDate(inv.dueDate)}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${inv.currency}\$${inv.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(inv.status).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  inv.status,
                                  style: TextStyle(
                                    color: _getStatusColor(inv.status),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Sent':
        return Colors.blue;
      case 'Overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showInvoicePreviewDialog(BuildContext context, Invoice inv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                inv.invoiceNum,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(inv.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                inv.status,
                style: TextStyle(
                  color: _getStatusColor(inv.status),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client: ${inv.clientName}', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('Date: ${_formatDate(inv.date)}'),
              Text('Due Date: ${_formatDate(inv.dueDate)}'),
              const Divider(height: 20),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...inv.items.map((it) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(it.name, overflow: TextOverflow.ellipsis)),
                        Text('\$${it.total.toStringAsFixed(2)}'),
                      ],
                    ),
                  )),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:'),
                  Text('\$${inv.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax (${inv.taxRate}%):'),
                  Text('\$${inv.taxAmount.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    '\$${inv.total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Change Status:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: ['Draft', 'Sent', 'Paid', 'Overdue'].map((st) {
                  return ChoiceChip(
                    label: Text(st, style: const TextStyle(fontSize: 11)),
                    selected: inv.status == st,
                    onSelected: (val) {
                      if (val) {
                        widget.onStatusChange(inv, st);
                        Navigator.pop(ctx);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              widget.onDeleteInvoice(inv.id);
              Navigator.pop(ctx);
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

// ==========================================
// TAB 3: HOURLY RATE CALCULATOR
// ==========================================

class RateCalculatorTab extends StatefulWidget {
  const RateCalculatorTab({super.key});

  @override
  State<RateCalculatorTab> createState() => _RateCalculatorTabState();
}

class _RateCalculatorTabState extends State<RateCalculatorTab> {
  double _targetIncome = 85000;
  double _annualOverhead = 12000;
  double _weeklyHours = 30;
  double _vacationWeeks = 4;
  double _taxPercent = 25;

  @override
  Widget build(BuildContext context) {
    final workWeeks = 52.0 - _vacationWeeks;
    final annualBillableHours = workWeeks * _weeklyHours;
    final totalExpenseAndTarget = _targetIncome + _annualOverhead;
    final requiredGross = annualBillableHours > 0
        ? totalExpenseAndTarget / (1.0 - (_taxPercent / 100.0))
        : 0.0;
    final hourlyRate = annualBillableHours > 0 ? requiredGross / annualBillableHours : 0.0;
    final recommendedRate = hourlyRate * 1.15; // 15% safety buffer
    final dailyRate = hourlyRate * (_weeklyHours / 5.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.indigo.shade700,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Recommended Target Hourly Rate',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        '\$${recommendedRate.toStringAsFixed(2)} / hr',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _summaryMetric('Min Break-Even', '\$${hourlyRate.toStringAsFixed(2)}/hr'),
                        _summaryMetric('Target Daily', '\$${dailyRate.toStringAsFixed(2)}/day'),
                        _summaryMetric('Billable Hrs/Yr', '${annualBillableHours.toInt()} hrs'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Financial Goals & Work Parameters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSliderCard(
              title: 'Target Take-Home Net Income',
              valueDisplay: '\$${_targetIncome.toInt()}',
              value: _targetIncome,
              min: 20000,
              max: 250000,
              divisions: 230,
              onChanged: (val) => setState(() => _targetIncome = val),
            ),
            _buildSliderCard(
              title: 'Annual Overhead (Software, Hardware, Apps)',
              valueDisplay: '\$${_annualOverhead.toInt()}',
              value: _annualOverhead,
              min: 0,
              max: 50000,
              divisions: 100,
              onChanged: (val) => setState(() => _annualOverhead = val),
            ),
            _buildSliderCard(
              title: 'Weekly Billable Hours (Client Work)',
              valueDisplay: '${_weeklyHours.toInt()} hrs/wk',
              value: _weeklyHours,
              min: 10,
              max: 60,
              divisions: 50,
              onChanged: (val) => setState(() => _weeklyHours = val),
            ),
            _buildSliderCard(
              title: 'Vacation & Time Off',
              valueDisplay: '${_vacationWeeks.toInt()} weeks/yr',
              value: _vacationWeeks,
              min: 0,
              max: 12,
              divisions: 12,
              onChanged: (val) => setState(() => _vacationWeeks = val),
            ),
            _buildSliderCard(
              title: 'Estimated Income Tax Reserve',
              valueDisplay: '${_taxPercent.toInt()}%',
              value: _taxPercent,
              min: 10,
              max: 45,
              divisions: 35,
              onChanged: (val) => setState(() => _taxPercent = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryMetric(String title, String val) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard({
    required String title,
    required String valueDisplay,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    valueDisplay,
                    style: TextStyle(
                      color: Colors.indigo.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: Colors.indigo,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// TAB 4: CLIENT MANAGEMENT CRM
// ==========================================

class ClientsTab extends StatelessWidget {
  final List<Client> clients;
  final Function(Client) onAddClient;

  const ClientsTab({
    super.key,
    required this.clients,
    required this.onAddClient,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Client Directory',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openAddClientModal(context),
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Add Client'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: clients.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text('No Clients Recorded Yet', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: clients.length,
                    itemBuilder: (ctx, idx) {
                      final client = clients[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(
                              client.company.isNotEmpty ? client.company[0].toUpperCase() : 'C',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          title: Text(
                            client.company,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Contact: ${client.name}', overflow: TextOverflow.ellipsis),
                              Text('Email: ${client.email}', overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          trailing: const Icon(Icons.business, color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openAddClientModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String company = '';
    String email = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: bottomInset + 20,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Client',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => company = v ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contact Person Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => name = v ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => email = v ?? '',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            final newClient = Client(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: name,
                              company: company,
                              email: email,
                            );
                            onAddClient(newClient);
                            Navigator.pop(ctx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save Client'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}