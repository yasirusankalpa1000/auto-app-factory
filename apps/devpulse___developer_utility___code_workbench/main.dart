import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math' as math;

void main() {
  runApp(const DevPulseApp());
}

class VaultItem {
  final String id;
  final String title;
  final String category;
  final String content;
  final DateTime createdAt;

  VaultItem({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.createdAt,
  });
}

class DevPulseApp extends StatefulWidget {
  const DevPulseApp({super.key});

  @override
  State<DevPulseApp> createState() => _DevPulseAppState();
}

class _DevPulseAppState extends State<DevPulseApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final List<VaultItem> _vaultItems = [];

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.dark;
      }
    });
  }

  void _addToVault(String title, String category, String content) {
    setState(() {
      _vaultItems.insert(
        0,
        VaultItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          category: category,
          content: content,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _removeFromVault(String id) {
    setState(() {
      _vaultItems.removeWhere((item) => item.id == id);
    });
  }

  void _clearVault() {
    setState(() {
      _vaultItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevPulse Studio',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: MainStudioScreen(
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
        vaultItems: _vaultItems,
        onAddToVault: _addToVault,
        onRemoveFromVault: _removeFromVault,
        onClearVault: _clearVault,
      ),
    );
  }
}

class MainStudioScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  final List<VaultItem> vaultItems;
  final Function(String, String, String) onAddToVault;
  final Function(String) onRemoveFromVault;
  final VoidCallback onClearVault;

  const MainStudioScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
    required this.vaultItems,
    required this.onAddToVault,
    required this.onRemoveFromVault,
    required this.onClearVault,
  });

  @override
  State<MainStudioScreen> createState() => _MainStudioScreenState();
}

class _MainStudioScreenState extends State<MainStudioScreen> {
  int _selectedIndex = 0;

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openVaultModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VaultBottomSheet(
        items: widget.vaultItems,
        onRemove: widget.onRemoveFromVault,
        onClear: widget.onClearVault,
        onCopy: (text) => _copyToClipboard(context, text, 'Snippet'),
      ),
    );
  }

  Widget _buildActiveTab() {
    switch (_selectedIndex) {
      case 0:
        return JsonStudioView(
          onSave: widget.onAddToVault,
          onCopy: (text) => _copyToClipboard(context, text, 'JSON Output'),
        );
      case 1:
        return RegexWorkbenchView(
          onSave: widget.onAddToVault,
          onCopy: (text) => _copyToClipboard(context, text, 'RegEx Pattern'),
        );
      case 2:
        return ColorInspectorView(
          onSave: widget.onAddToVault,
          onCopy: (text) => _copyToClipboard(context, text, 'Color Value'),
        );
      case 3:
        return EncoderStudioView(
          onSave: widget.onAddToVault,
          onCopy: (text) => _copyToClipboard(context, text, 'Converted Output'),
        );
      case 4:
        return TokenStudioView(
          onSave: widget.onAddToVault,
          onCopy: (text) => _copyToClipboard(context, text, 'Generated Key'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.developer_mode, color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                const Text(
                  'DevPulse Studio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  widget.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: widget.onToggleTheme,
                tooltip: 'Toggle Dark/Light Mode',
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.bookmark_outline),
                    onPressed: _openVaultModal,
                    tooltip: 'Saved Vault',
                  ),
                  if (widget.vaultItems.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${widget.vaultItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: isWide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (idx) {
                        setState(() {
                          _selectedIndex = idx;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.code),
                          selectedIcon: Icon(Icons.code, color: Colors.indigo),
                          label: Text('JSON'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.find_in_page_outlined),
                          selectedIcon: Icon(Icons.find_in_page),
                          label: Text('RegEx'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.palette_outlined),
                          selectedIcon: Icon(Icons.palette),
                          label: Text('Color & WCAG'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.transform),
                          selectedIcon: Icon(Icons.transform),
                          label: Text('Encoder'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.key),
                          selectedIcon: Icon(Icons.key),
                          label: Text('UUID/Keys'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: _buildActiveTab()),
                  ],
                )
              : _buildActiveTab(),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (idx) {
                    setState(() {
                      _selectedIndex = idx;
                    });
                  },
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.code), label: 'JSON'),
                    NavigationDestination(
                      icon: Icon(Icons.find_in_page_outlined),
                      label: 'RegEx',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.palette_outlined),
                      label: 'Color',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.transform),
                      label: 'Encoder',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.key),
                      label: 'UUID/Keys',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// ==========================================
// 1. JSON STUDIO VIEW
// ==========================================
class JsonStudioView extends StatefulWidget {
  final Function(String, String, String) onSave;
  final Function(String) onCopy;

  const JsonStudioView({
    super.key,
    required this.onSave,
    required this.onCopy,
  });

  @override
  State<JsonStudioView> createState() => _JsonStudioViewState();
}

class _JsonStudioViewState extends State<JsonStudioView> {
  final TextEditingController _inputController = TextEditingController();
  String _formattedOutput = '';
  String? _errorMessage;
  int _keysCount = 0;
  int _arrayCount = 0;
  int _maxDepth = 0;
  double _byteSizeKB = 0.0;

  final String _sampleJson =
      '{\n  "appName": "DevPulse Studio",\n  "version": 1.2,\n  "features": ["JSON Inspector", "RegEx Workbench", "Color Studio"],\n  "settings": {\n    "theme": "dark",\n    "offlineMode": true,\n    "pricing": "\$0.00"\n  }\n}';

  @override
  void initState() {
    super.initState();
    _inputController.text = _sampleJson;
    _processJson();
  }

  void _processJson([bool minify = false]) {
    final raw = _inputController.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _formattedOutput = '';
        _errorMessage = null;
        _keysCount = 0;
        _arrayCount = 0;
        _maxDepth = 0;
        _byteSizeKB = 0.0;
      });
      return;
    }

    try {
      final parsed = jsonDecode(raw);
      final encoder = minify
          ? const JsonEncoder()
          : const JsonEncoder.withIndent('  ');
      final formatted = encoder.convert(parsed);

      final stats = _analyzeJson(parsed, 1);

      setState(() {
        _formattedOutput = formatted;
        _errorMessage = null;
        _keysCount = stats['keys']!;
        _arrayCount = stats['arrays']!;
        _maxDepth = stats['depth']!;
        _byteSizeKB = utf8.encode(formatted).length / 1024.0;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _formattedOutput = '';
      });
    }
  }

  Map<String, int> _analyzeJson(dynamic parsed, int depth) {
    int keys = 0;
    int arrays = 0;
    int maxDepth = depth;

    if (parsed is Map) {
      keys += parsed.length;
      for (var val in parsed.values) {
        if (val is Map || val is List) {
          final res = _analyzeJson(val, depth + 1);
          keys += res['keys']!;
          arrays += res['arrays']!;
          maxDepth = math.max(maxDepth, res['depth']!);
        }
      }
    } else if (parsed is List) {
      arrays += 1;
      for (var val in parsed) {
        if (val is Map || val is List) {
          final res = _analyzeJson(val, depth + 1);
          keys += res['keys']!;
          arrays += res['arrays']!;
          maxDepth = math.max(maxDepth, res['depth']!);
        }
      }
    }

    return {'keys': keys, 'arrays': arrays, 'depth': maxDepth};
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JSON Formatter & Inspector',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Format, minify, inspect depth and key statistics.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            maxLines: 8,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Raw JSON Input',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _processJson(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _processJson(false),
                icon: const Icon(Icons.format_align_left),
                label: const Text('Prettify'),
              ),
              OutlinedButton.icon(
                onPressed: () => _processJson(true),
                icon: const Icon(Icons.compress),
                label: const Text('Minify'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _inputController.text = _sampleJson;
                  _processJson();
                },
                icon: const Icon(Icons.sample_base),
                label: const Text('Load Sample'),
              ),
              IconButton(
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear Input',
                onPressed: () {
                  _inputController.clear();
                  _processJson();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_errorMessage != null)
            Card(
              color: Colors.red.shade50,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Invalid JSON Syntax:\n$_errorMessage',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_errorMessage == null && _formattedOutput.isNotEmpty) ...[
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildStatBadge('Keys', '$_keysCount', Colors.blue),
                _buildStatBadge('Arrays', '$_arrayCount', Colors.teal),
                _buildStatBadge('Max Depth', '$_maxDepth', Colors.purple),
                _buildStatBadge(
                  'Size',
                  '${_byteSizeKB.toStringAsFixed(2)} KB',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Formatted Output',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              tooltip: 'Copy Output',
                              onPressed: () => widget.onCopy(_formattedOutput),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_add, size: 20),
                              tooltip: 'Save to Vault',
                              onPressed: () {
                                widget.onSave(
                                  'JSON Snippet (${_keysCount} keys)',
                                  'JSON',
                                  _formattedOutput,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved to Vault!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          _formattedOutput,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.9)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. REGEX WORKBENCH VIEW
// ==========================================
class RegexWorkbenchView extends StatefulWidget {
  final Function(String, String, String) onSave;
  final Function(String) onCopy;

  const RegexWorkbenchView({
    super.key,
    required this.onSave,
    required this.onCopy,
  });

  @override
  State<RegexWorkbenchView> createState() => _RegexWorkbenchViewState();
}

class _RegexWorkbenchViewState extends State<RegexWorkbenchView> {
  final TextEditingController _patternController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  bool _caseInsensitive = true;
  bool _multiLine = false;
  List<RegExpMatch> _matches = [];
  String? _error;

  final List<Map<String, String>> _presets = [
    {
      'name': 'Email Address',
      'pattern': r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}',
      'sample':
          'Contact support@devpulse.io or john.doe@company.com for queries.',
    },
    {
      'name': 'URL / Links',
      'pattern': r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b',
      'sample': 'Visit https://flutter.dev or http://example.com/api/v1.',
    },
    {
      'name': 'Price / USD',
      'pattern': r'\$?\d+(?:\.\d{2})?',
      'sample': 'Items cost \$12.99, \$45.00, and \$100 during sales.',
    },
    {
      'name': 'IPv4 Address',
      'pattern': r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b',
      'sample': 'Server running at 192.168.1.1 and 10.0.0.254.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _applyPreset(_presets[0]);
  }

  void _applyPreset(Map<String, String> preset) {
    _patternController.text = preset['pattern']!;
    _textController.text = preset['sample']!;
    _runRegex();
  }

  void _runRegex() {
    final pattern = _patternController.text;
    final text = _textController.text;

    if (pattern.isEmpty) {
      setState(() {
        _matches = [];
        _error = null;
      });
      return;
    }

    try {
      final regExp = RegExp(
        pattern,
        caseSensitive: !_caseInsensitive,
        multiLine: _multiLine,
      );
      final found = regExp.allMatches(text).toList();
      setState(() {
        _matches = found;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _matches = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visual RegEx Workbench',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Test regular expressions with real-time capture groups.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          const Text(
            'Presets:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _presets.map((p) {
              return ActionChip(
                label: Text(p['name']!),
                avatar: const Icon(Icons.auto_awesome, size: 16),
                onPressed: () => _applyPreset(p),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _patternController,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Regular Expression Pattern',
              prefixText: '/',
              suffixText: '/',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => widget.onCopy(_patternController.text),
              ),
            ),
            onChanged: (_) => _runRegex(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterChip(
                label: const Text('Case Insensitive (i)'),
                selected: _caseInsensitive,
                onSelected: (val) {
                  setState(() {
                    _caseInsensitive = val;
                  });
                  _runRegex();
                },
              ),
              FilterChip(
                label: const Text('MultiLine (m)'),
                selected: _multiLine,
                onSelected: (val) {
                  setState(() {
                    _multiLine = val;
                  });
                  _runRegex();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 4,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Target Text to Match',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _runRegex(),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Invalid RegEx: $_error',
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            ),
          if (_error == null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Matches (${_matches.length} found)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_add, size: 20),
                  tooltip: 'Save Pattern to Vault',
                  onPressed: () {
                    widget.onSave(
                      'RegEx Pattern',
                      'RegEx',
                      _patternController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved to Vault!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_matches.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No matches found for the pattern.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final match = _matches[index];
                  final matchedStr = match.group(0) ?? '';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Chip(
                                label: Text('Match #${index + 1}'),
                                backgroundColor: Colors.indigo.withOpacity(0.1),
                                visualDensity: VisualDensity.compact,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Index: [${match.start}..${match.end}]',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            matchedStr,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          if (match.groupCount > 0) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Capture Groups:',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...List.generate(match.groupCount, (gIdx) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                                child: Text(
                                  '  Group \$${gIdx + 1}: "${match.group(gIdx + 1) ?? ''}"',
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// 3. COLOR & WCAG INSPECTOR VIEW
// ==========================================
class ColorInspectorView extends StatefulWidget {
  final Function(String, String, String) onSave;
  final Function(String) onCopy;

  const ColorInspectorView({
    super.key,
    required this.onSave,
    required this.onCopy,
  });

  @override
  State<ColorInspectorView> createState() => _ColorInspectorViewState();
}

class _ColorInspectorViewState extends State<ColorInspectorView> {
  final TextEditingController _hexController =
      TextEditingController(text: '#3F51B5');
  Color _currentColor = Colors.indigo;

  @override
  void initState() {
    super.initState();
    _parseColor('#3F51B5');
  }

  void _parseColor(String value) {
    String cleanHex = value.replaceAll('#', '').trim();
    if (cleanHex.length == 6) {
      final intValue = int.tryParse('FF$cleanHex', radix: 16);
      if (intValue != null) {
        setState(() {
          _currentColor = Color(intValue);
        });
      }
    }
  }

  double _computeContrast(Color c1, Color c2) {
    final l1 = c1.computeLuminance();
    final l2 = c2.computeLuminance();
    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  String _toHex(Color c) {
    return '#${c.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final hexString = _toHex(_currentColor);
    final contrastWhite = _computeContrast(_currentColor, Colors.white);
    final contrastBlack = _computeContrast(_currentColor, Colors.black);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color Studio & WCAG Inspector',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Analyze color contrast compliance and generate shade scales.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hexController,
                  decoration: const InputDecoration(
                    labelText: 'Hex Color Code',
                    hintText: '#RRGGBB',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _parseColor,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: _currentColor,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Sample Text Preview',
                    style: TextStyle(
                      color: contrastWhite > contrastBlack
                          ? Colors.white
                          : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ensure readable visual hierarchy in software user interfaces.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (contrastWhite > contrastBlack
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Color Metrics ($hexString)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_add),
                onPressed: () {
                  widget.onSave('Color Palette', 'Color', hexString);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved to Vault!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildMetricCard(
                'RGB',
                'rgb(${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue})',
                widget.onCopy,
              ),
              _buildMetricCard('HEX', hexString, widget.onCopy),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'WCAG 2.1 Contrast Ratio Analysis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildContrastCard(
                  'On White Text',
                  contrastWhite,
                  Colors.white,
                  _currentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContrastCard(
                  'On Black Text',
                  contrastBlack,
                  Colors.black,
                  _currentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Shade Scale Generator',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: Row(
              children: List.generate(10, (idx) {
                final factor = (idx + 1) * 0.09;
                final shade = Color.alphaBlend(
                  Colors.black.withOpacity(factor),
                  _currentColor,
                );
                final shadeHex = _toHex(shade);
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      _hexController.text = shadeHex;
                      _parseColor(shadeHex);
                      widget.onCopy(shadeHex);
                    },
                    child: Container(
                      color: shade,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${(idx + 1) * 100}',
                        style: TextStyle(
                          fontSize: 10,
                          color: shade.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String label, String value, Function(String) onCopy) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => onCopy(value),
            child: const Icon(Icons.copy, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContrastCard(
      String label, double ratio, Color textColor, Color bgColor) {
    final aaNormal = ratio >= 4.5;
    final aaaNormal = ratio >= 7.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              '${ratio.toStringAsFixed(2)} : 1',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _buildComplianceChip('AA Normal', aaNormal),
                _buildComplianceChip('AAA Normal', aaaNormal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceChip(String label, bool pass) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: pass
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: ${pass ? "PASS" : "FAIL"}',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: pass ? Colors.green.shade800 : Colors.red.shade800,
        ),
      ),
    );
  }
}

// ==========================================
// 4. ENCODER & METRICS STUDIO VIEW
// ==========================================
enum ConvMode { base64Encode, base64Decode, urlEncode, urlDecode, jwtInspect }

class EncoderStudioView extends StatefulWidget {
  final Function(String, String, String) onSave;
  final Function(String) onCopy;

  const EncoderStudioView({
    super.key,
    required this.onSave,
    required this.onCopy,
  });

  @override
  State<EncoderStudioView> createState() => _EncoderStudioViewState();
}

class _EncoderStudioViewState extends State<EncoderStudioView> {
  final TextEditingController _inputController = TextEditingController(
    text: 'Hello DevPulse Studio! Welcome to developer utilities.',
  );
  ConvMode _mode = ConvMode.base64Encode;
  String _output = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _convert();
  }

  void _convert() {
    final text = _inputController.text;
    if (text.isEmpty) {
      setState(() {
        _output = '';
        _error = null;
      });
      return;
    }

    try {
      String res = '';
      switch (_mode) {
        case ConvMode.base64Encode:
          res = base64Encode(utf8.encode(text));
          break;
        case ConvMode.base64Decode:
          res = utf8.decode(base64Decode(text.trim()));
          break;
        case ConvMode.urlEncode:
          res = Uri.encodeComponent(text);
          break;
        case ConvMode.urlDecode:
          res = Uri.decodeComponent(text);
          break;
        case ConvMode.jwtInspect:
          final parts = text.split('.');
          if (parts.length != 3) {
            throw FormatException('JWT must contain 3 dot-separated parts');
          }
          String payload = parts[1];
          while (payload.length % 4 != 0) {
            payload += '=';
          }
          final decoded = utf8.decode(base64Decode(payload));
          final parsedJson = jsonDecode(decoded);
          res = const JsonEncoder.withIndent('  ').convert(parsedJson);
          break;
      }
      setState(() {
        _output = res;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _output = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawText = _inputController.text;
    final charCount = rawText.length;
    final wordCount =
        rawText.trim().isEmpty ? 0 : rawText.trim().split(RegExp(r'\s+')).length;
    final lineCount = rawText.isEmpty ? 0 : rawText.split('\n').length;
    final byteSize = utf8.encode(rawText).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Encoder, Decoder & Text Metrics',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Base64, URL encoding, JWT payload extraction, and string analysis.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Base64 Encode'),
                selected: _mode == ConvMode.base64Encode,
                onSelected: (s) {
                  if (s) {
                    setState(() => _mode = ConvMode.base64Encode);
                    _convert();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('Base64 Decode'),
                selected: _mode == ConvMode.base64Decode,
                onSelected: (s) {
                  if (s) {
                    setState(() => _mode = ConvMode.base64Decode);
                    _convert();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('URL Encode'),
                selected: _mode == ConvMode.urlEncode,
                onSelected: (s) {
                  if (s) {
                    setState(() => _mode = ConvMode.urlEncode);
                    _convert();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('URL Decode'),
                selected: _mode == ConvMode.urlDecode,
                onSelected: (s) {
                  if (s) {
                    setState(() => _mode = ConvMode.urlDecode);
                    _convert();
                  }
                },
              ),
              ChoiceChip(
                label: const Text('JWT Inspector'),
                selected: _mode == ConvMode.jwtInspect,
                onSelected: (s) {
                  if (s) {
                    setState(() => _mode = ConvMode.jwtInspect);
                    _convert();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            maxLines: 4,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Source Text',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _convert(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildMetricBadge('Chars', '$charCount'),
              _buildMetricBadge('Words', '$wordCount'),
              _buildMetricBadge('Lines', '$lineCount'),
              _buildMetricBadge('Bytes', '$byteSize B'),
            ],
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Conversion Error: $_error',
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            ),
          if (_error == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Converted Result',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () => widget.onCopy(_output),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_add, size: 20),
                              onPressed: () {
                                widget.onSave(
                                  'Converted Payload',
                                  'Encoder',
                                  _output,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Saved to Vault!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    SelectableText(
                      _output.isEmpty ? '(Empty output)' : _output,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricBadge(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $val',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ==========================================
// 5. UUID & TOKEN GENERATOR STUDIO VIEW
// ==========================================
class TokenStudioView extends StatefulWidget {
  final Function(String, String, String) onSave;
  final Function(String) onCopy;

  const TokenStudioView({
    super.key,
    required this.onSave,
    required this.onCopy,
  });

  @override
  State<TokenStudioView> createState() => _TokenStudioViewState();
}

class _TokenStudioViewState extends State<TokenStudioView> {
  int _generatorMode = 0; // 0 = UUID v4, 1 = Password / API Key
  int _uuidCount = 5;
  bool _uppercaseUuid = true;
  bool _includeHyphens = true;

  double _keyLength = 16;
  bool _incUpper = true;
  bool _incLower = true;
  bool _incNumbers = true;
  bool _incSymbols = true;

  List<String> _generatedResults = [];

  @override
  void initState() {
    super.initState();
    _generateTokens();
  }

  String _generateUuidV4() {
    final rand = math.Random();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1

    final sb = StringBuffer();
    for (int i = 0; i < bytes.length; i++) {
      if (_includeHyphens && (i == 4 || i == 6 || i == 8 || i == 10)) {
        sb.write('-');
      }
      sb.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }

    final res = sb.toString();
    return _uppercaseUuid ? res.toUpperCase() : res.toLowerCase();
  }

  String _generateKey() {
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String pool = '';
    if (_incUpper) pool += upper;
    if (_incLower) pool += lower;
    if (_incNumbers) pool += numbers;
    if (_incSymbols) pool += symbols;

    if (pool.isEmpty) return 'Select at least one character type!';

    final rand = math.Random.secure();
    final sb = StringBuffer();
    for (int i = 0; i < _keyLength.toInt(); i++) {
      sb.write(pool[rand.nextInt(pool.length)]);
    }
    return sb.toString();
  }

  void _generateTokens() {
    final List<String> list = [];
    if (_generatorMode == 0) {
      for (int i = 0; i < _uuidCount; i++) {
        list.add(_generateUuidV4());
      }
    } else {
      for (int i = 0; i < _uuidCount; i++) {
        list.add(_generateKey());
      }
    }
    setState(() {
      _generatedResults = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'UUID & Secure Key Generator',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Generate compliant UUID v4 strings and secure API keys.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                label: Text('UUID v4 Generator'),
                icon: Icon(Icons.fingerprint),
              ),
              ButtonSegment(
                value: 1,
                label: Text('Secret / Password Key'),
                icon: Icon(Icons.key),
              ),
            ],
            selected: {_generatorMode},
            onSelectionChanged: (val) {
              setState(() {
                _generatorMode = val.first;
              });
              _generateTokens();
            },
          ),
          const SizedBox(height: 16),
          if (_generatorMode == 0) ...[
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('UPPERCASE'),
                  selected: _uppercaseUuid,
                  onSelected: (v) {
                    setState(() => _uppercaseUuid = v);
                    _generateTokens();
                  },
                ),
                FilterChip(
                  label: const Text('Include Hyphens (-)'),
                  selected: _includeHyphens,
                  onSelected: (v) {
                    setState(() => _includeHyphens = v);
                    _generateTokens();
                  },
                ),
              ],
            ),
          ] else ...[
            Text('Length: ${_keyLength.toInt()} characters'),
            Slider(
              value: _keyLength,
              min: 8,
              max: 64,
              divisions: 56,
              label: '${_keyLength.toInt()}',
              onChanged: (v) {
                setState(() => _keyLength = v);
                _generateTokens();
              },
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('A-Z'),
                  selected: _incUpper,
                  onSelected: (v) {
                    setState(() => _incUpper = v);
                    _generateTokens();
                  },
                ),
                FilterChip(
                  label: const Text('a-z'),
                  selected: _incLower,
                  onSelected: (v) {
                    setState(() => _incLower = v);
                    _generateTokens();
                  },
                ),
                FilterChip(
                  label: const Text('0-9'),
                  selected: _incNumbers,
                  onSelected: (v) {
                    setState(() => _incNumbers = v);
                    _generateTokens();
                  },
                ),
                FilterChip(
                  label: const Text('!@#\$'),
                  selected: _incSymbols,
                  onSelected: (v) {
                    setState(() => _incSymbols = v);
                    _generateTokens();
                  },
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Batch Quantity: $_uuidCount'),
              Expanded(
                child: Slider(
                  value: _uuidCount.toDouble(),
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: '$_uuidCount',
                  onChanged: (v) {
                    setState(() => _uuidCount = v.toInt());
                    _generateTokens();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _generateTokens,
                icon: const Icon(Icons.refresh),
                label: const Text('Regenerate Tokens'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  final allText = _generatedResults.join('\n');
                  widget.onCopy(allText);
                },
                icon: const Icon(Icons.copy_all),
                label: const Text('Copy All Batch'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _generatedResults.length,
            itemBuilder: (context, index) {
              final token = _generatedResults[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: SelectableText(
                    token,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () => widget.onCopy(token),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_add, size: 18),
                        onPressed: () {
                          widget.onSave(
                            _generatorMode == 0 ? 'UUID v4' : 'Secret Key',
                            'Keys',
                            token,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved to Vault!')),
                          );
                        },
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
}

// ==========================================
// SAVED VAULT BOTTOM SHEET
// ==========================================
class VaultBottomSheet extends StatelessWidget {
  final List<VaultItem> items;
  final Function(String) onRemove;
  final VoidCallback onClear;
  final Function(String) onCopy;

  const VaultBottomSheet({
    super.key,
    required this.items,
    required this.onRemove,
    required this.onClear,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Snippets Vault',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (items.isNotEmpty)
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.delete_sweep, color: Colors.red),
                  label: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          const Divider(),
          if (items.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No saved snippets in vault.\nBookmark outputs from any tool!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(
                                label: Text(item.category),
                                visualDensity: VisualDensity.compact,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 18),
                                    onPressed: () => onCopy(item.content),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => onRemove(item.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: SelectableText(
                              item.content,
                              maxLines: 4,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
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
}