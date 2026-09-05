import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DevCraftApp());
}

class DevCraftApp extends StatefulWidget {
  const DevCraftApp({super.key});

  @override
  State<DevCraftApp> createState() => _DevCraftAppState();
}

class _DevCraftAppState extends State<DevCraftApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.indigo;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _changeSeedColor(Color color) {
    setState(() {
      _seedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevCraft Utility Lab',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: DevCraftHome(
        onToggleTheme: _toggleTheme,
        onChangeSeedColor: _changeSeedColor,
        currentSeedColor: _seedColor,
      ),
    );
  }
}

class DevCraftHome extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ValueChanged<Color> onChangeSeedColor;
  final Color currentSeedColor;

  const DevCraftHome({
    super.key,
    required this.onToggleTheme,
    required this.onChangeSeedColor,
    required this.currentSeedColor,
  });

  @override
  State<DevCraftHome> createState() => _DevCraftHomeState();
}

class _DevCraftHomeState extends State<DevCraftHome> {
  int _selectedIndex = 0;

  final List<Color> _availableColors = const [
    Colors.indigo,
    Colors.teal,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.deepOrange,
  ];

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    final List<Widget> pages = [
      JsonStudioView(onCopy: (txt, name) => _copyToClipboard(context, txt, name)),
      RegexTesterView(onCopy: (txt, name) => _copyToClipboard(context, txt, name)),
      EncoderDecoderView(onCopy: (txt, name) => _copyToClipboard(context, txt, name)),
      ColorStudioView(onCopy: (txt, name) => _copyToClipboard(context, txt, name)),
      MockDataGeneratorView(onCopy: (txt, name) => _copyToClipboard(context, txt, name)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.developer_mode, size: 28),
            SizedBox(width: 10),
            Text(
              'DevCraft Lab',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<Color>(
            tooltip: 'Change Theme Color',
            icon: Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.primary),
            onSelected: widget.onChangeSeedColor,
            itemBuilder: (context) => _availableColors.map((color) {
              return PopupMenuItem<Color>(
                value: color,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(color == widget.currentSeedColor ? 'Active' : 'Theme'),
                  ],
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Light/Dark Theme',
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.code),
                  selectedIcon: Icon(Icons.code, color: Colors.blue),
                  label: Text('JSON'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.find_in_page_outlined),
                  selectedIcon: Icon(Icons.find_in_page),
                  label: Text('Regex'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.transform),
                  selectedIcon: Icon(Icons.transform, color: Colors.teal),
                  label: Text('Encode'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.color_lens_outlined),
                  selectedIcon: Icon(Icons.color_lens),
                  label: Text('Colors'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.data_object),
                  selectedIcon: Icon(Icons.data_object, color: Colors.purple),
                  label: Text('Mock Data'),
                ),
              ],
            ),
          if (isWide) const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (idx) => setState(() => _selectedIndex = idx),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.code),
                  label: 'JSON',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.find_in_page_outlined),
                  label: 'Regex',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.transform),
                  label: 'Encode',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.color_lens_outlined),
                  label: 'Colors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.data_object),
                  label: 'Mock',
                ),
              ],
            ),
    );
  }
}

// ==========================================
// TOOL 1: JSON STUDIO
// ==========================================
class JsonStudioView extends StatefulWidget {
  final Function(String, String) onCopy;

  const JsonStudioView({super.key, required this.onCopy});

  @override
  State<JsonStudioView> createState() => _JsonStudioViewState();
}

class _JsonStudioViewState extends State<JsonStudioView> {
  final TextEditingController _inputController = TextEditingController();
  String _errorMessage = '';
  bool _isValid = true;
  int _keyCount = 0;
  int _byteSize = 0;

  final String _sampleJson = '''{
  "project": "DevCraft Suite",
  "version": "1.0.0",
  "active": true,
  "stats": {
    "users": 1250,
    "rating": 4.9,
    "price": "\$19.99"
  },
  "tags": ["flutter", "dart", "utility", "developer"]
}''';

  @override
  void initState() {
    super.initState();
    _inputController.text = _sampleJson;
    _validateAndProcess();
  }

  void _validateAndProcess() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = '';
        _isValid = true;
        _keyCount = 0;
        _byteSize = 0;
      });
      return;
    }

    try {
      final decoded = jsonDecode(text);
      int count = 0;
      if (decoded is Map) {
        count = _countKeys(decoded);
      } else if (decoded is List) {
        count = decoded.length;
      }

      setState(() {
        _isValid = true;
        _errorMessage = '';
        _keyCount = count;
        _byteSize = utf8.encode(text).length;
      });
    } catch (e) {
      setState(() {
        _isValid = false;
        _errorMessage = e.toString();
        _keyCount = 0;
        _byteSize = utf8.encode(text).length;
      });
    }
  }

  int _countKeys(Map map) {
    int count = map.keys.length;
    for (var val in map.values) {
      if (val is Map) {
        count += _countKeys(val);
      }
    }
    return count;
  }

  void _formatJson() {
    if (_inputController.text.isEmpty) return;
    try {
      final decoded = jsonDecode(_inputController.text);
      final encoder = const JsonEncoder.withIndent('  ');
      setState(() {
        _inputController.text = encoder.convert(decoded);
        _validateAndProcess();
      });
    } catch (_) {
      _validateAndProcess();
    }
  }

  void _minifyJson() {
    if (_inputController.text.isEmpty) return;
    try {
      final decoded = jsonDecode(_inputController.text);
      setState(() {
        _inputController.text = jsonEncode(decoded);
        _validateAndProcess();
      });
    } catch (_) {
      _validateAndProcess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JSON Formatter & Validator',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Chip(
                avatar: Icon(
                  _isValid ? Icons.check_circle : Icons.error,
                  color: _isValid ? Colors.green : Colors.red,
                  size: 18,
                ),
                label: Text(_isValid ? 'Valid JSON' : 'Invalid JSON'),
                backgroundColor: _isValid
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _formatJson,
                icon: const Icon(Icons.format_indent_increase),
                label: const Text('Pretty Format'),
              ),
              OutlinedButton.icon(
                onPressed: _minifyJson,
                icon: const Icon(Icons.compress),
                label: const Text('Minify'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _inputController.text = _sampleJson;
                  _validateAndProcess();
                },
                icon: const Icon(Icons.data_array),
                label: const Text('Load Sample'),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy JSON',
                onPressed: () => widget.onCopy(_inputController.text, 'JSON Text'),
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear',
                onPressed: () {
                  _inputController.clear();
                  _validateAndProcess();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!_isValid && _errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.4)),
              ),
              child: SelectableText(
                'Syntax Error:\n$_errorMessage',
                style: const TextStyle(color: Colors.red, fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          TextField(
            controller: _inputController,
            maxLines: 14,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            onChanged: (_) => _validateAndProcess(),
            decoration: InputDecoration(
              hintText: 'Paste raw JSON here...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('Size: $_byteSize Bytes', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Keys / Items: $_keyCount', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Characters: ${_inputController.text.length}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TOOL 2: REGEX TESTER
// ==========================================
class RegexTesterView extends StatefulWidget {
  final Function(String, String) onCopy;

  const RegexTesterView({super.key, required this.onCopy});

  @override
  State<RegexTesterView> createState() => _RegexTesterViewState();
}

class _RegexTesterViewState extends State<RegexTesterView> {
  final TextEditingController _patternController = TextEditingController(
    text: r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );
  final TextEditingController _testTextController = TextEditingController(
    text: 'Hello team! Contact us at support@devcraft.io or sales@example.org for pricing starting at \$19.99.',
  );

  bool _caseSensitive = true;
  bool _multiLine = false;

  List<RegExpMatch> _matches = [];
  String _regexError = '';

  @override
  void initState() {
    super.initState();
    _testRegex();
  }

  void _testRegex() {
    final pattern = _patternController.text;
    if (pattern.isEmpty) {
      setState(() {
        _matches = [];
        _regexError = '';
      });
      return;
    }

    try {
      final regExp = RegExp(
        pattern,
        caseSensitive: _caseSensitive,
        multiLine: _multiLine,
      );
      final matches = regExp.allMatches(_testTextController.text).toList();
      setState(() {
        _matches = matches;
        _regexError = '';
      });
    } catch (e) {
      setState(() {
        _matches = [];
        _regexError = e.toString();
      });
    }
  }

  void _applyPreset(String name, String pattern) {
    _patternController.text = pattern;
    _testRegex();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Regex Engine & Pattern Tester',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('Presets Quick Selection:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('Email'),
                onPressed: () => _applyPreset('Email', r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
              ),
              ActionChip(
                label: const Text('URL'),
                onPressed: () => _applyPreset('URL', r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
              ),
              ActionChip(
                label: const Text('IPv4 Address'),
                onPressed: () => _applyPreset('IPv4', r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'),
              ),
              ActionChip(
                label: const Text('Date (YYYY-MM-DD)'),
                onPressed: () => _applyPreset('Date', r'\d{4}-\d{2}-\d{2}'),
              ),
              ActionChip(
                label: const Text('Hex Color'),
                onPressed: () => _applyPreset('HexColor', r'#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _patternController,
            onChanged: (_) => _testRegex(),
            style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: 'Regular Expression Pattern',
              prefixText: '/',
              suffixText: '/',
              border: const OutlineInputBorder(),
              errorText: _regexError.isNotEmpty ? _regexError : null,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterChip(
                label: const Text('Case Sensitive'),
                selected: _caseSensitive,
                onSelected: (val) {
                  setState(() => _caseSensitive = val);
                  _testRegex();
                },
              ),
              FilterChip(
                label: const Text('Multiline'),
                selected: _multiLine,
                onSelected: (val) {
                  setState(() => _multiLine = val);
                  _testRegex();
                },
              ),
              Chip(
                avatar: const Icon(Icons.saved_search, size: 18),
                label: Text('${_matches.length} Matches Found'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _testTextController,
            maxLines: 5,
            onChanged: (_) => _testRegex(),
            decoration: const InputDecoration(
              labelText: 'Test Target String',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Matched Expressions (${_matches.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _matches.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('No regex matches found in test string.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _matches.length,
                  itemBuilder: (context, index) {
                    final match = _matches[index];
                    final matchedText = match.group(0) ?? '';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 14,
                          child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                        ),
                        title: SelectableText(
                          matchedText,
                          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Range: [${match.start} - ${match.end}]'),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () => widget.onCopy(matchedText, 'Match #${index + 1}'),
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
// TOOL 3: ENCODER / DECODER
// ==========================================
class EncoderDecoderView extends StatefulWidget {
  final Function(String, String) onCopy;

  const EncoderDecoderView({super.key, required this.onCopy});

  @override
  State<EncoderDecoderView> createState() => _EncoderDecoderViewState();
}

class _EncoderDecoderViewState extends State<EncoderDecoderView> {
  final TextEditingController _inputController = TextEditingController(
    text: 'DevCraft Studio \$2025 :: Key = Flutter & Dart!',
  );
  String _output = '';
  String _mode = 'Base64'; // Base64, URL, HTML
  bool _isEncode = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _process();
  }

  void _process() {
    final input = _inputController.text;
    if (input.isEmpty) {
      setState(() {
        _output = '';
        _error = '';
      });
      return;
    }

    try {
      String res = '';
      if (_mode == 'Base64') {
        if (_isEncode) {
          res = base64Encode(utf8.encode(input));
        } else {
          res = utf8.decode(base64Decode(input.trim()));
        }
      } else if (_mode == 'URL') {
        if (_isEncode) {
          res = Uri.encodeComponent(input);
        } else {
          res = Uri.decodeComponent(input);
        }
      } else if (_mode == 'HTML') {
        if (_isEncode) {
          res = const HtmlEscape().convert(input);
        } else {
          res = input
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>')
              .replaceAll('&quot;', '"')
              .replaceAll('&#39;', "'")
              .replaceAll('&amp;', '&');
        }
      }
      setState(() {
        _output = res;
        _error = '';
      });
    } catch (e) {
      setState(() {
        _output = '';
        _error = 'Processing Error: ${e.toString()}';
      });
    }
  }

  void _swapInputOutput() {
    if (_output.isNotEmpty) {
      _inputController.text = _output;
      _isEncode = !_isEncode;
      _process();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Converter & Encoder Studio',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Base64', label: Text('Base64')),
                  ButtonSegment(value: 'URL', label: Text('URL Encoding')),
                  ButtonSegment(value: 'HTML', label: Text('HTML Escape')),
                ],
                selected: {_mode},
                onSelectionChanged: (set) {
                  setState(() => _mode = set.first);
                  _process();
                },
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Encode')),
                  ButtonSegment(value: false, label: Text('Decode')),
                ],
                selected: {_isEncode},
                onSelectionChanged: (set) {
                  setState(() => _isEncode = set.first);
                  _process();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            maxLines: 4,
            onChanged: (_) => _process(),
            decoration: InputDecoration(
              labelText: 'Input Payload',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _inputController.clear();
                  _process();
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton.icon(
              onPressed: _swapInputOutput,
              icon: const Icon(Icons.swap_vert),
              label: const Text('Swap Input / Output'),
            ),
          ),
          const SizedBox(height: 12),
          if (_error.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_error, style: const TextStyle(color: Colors.red)),
            ),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Converted Result',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy Result',
                        onPressed: _output.isEmpty ? null : () => widget.onCopy(_output, 'Encoded/Decoded Output'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  SelectableText(
                    _output.isEmpty ? 'Output will appear here...' : _output,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TOOL 4: COLOR STUDIO
// ==========================================
class ColorStudioView extends StatefulWidget {
  final Function(String, String) onCopy;

  const ColorStudioView({super.key, required this.onCopy});

  @override
  State<ColorStudioView> createState() => _ColorStudioViewState();
}

class _ColorStudioViewState extends State<ColorStudioView> {
  final TextEditingController _hexController = TextEditingController(text: '6750A4');
  Color _currentColor = const Color(0xFF6750A4);

  final List<String> _palettePresets = const [
    '6750A4',
    '006A60',
    '0061A4',
    '9C4146',
    '6850A4',
    '2E6B27',
  ];

  void _onHexChanged(String val) {
    final clean = val.replaceAll('#', '').trim();
    if (clean.length == 6) {
      final intVal = int.tryParse('FF$clean', radix: 16);
      if (intVal != null) {
        setState(() {
          _currentColor = Color(intVal);
        });
      }
    }
  }

  String _toHex(Color c) => '${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();

  String _toHsl(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    final maxVal = max(r, max(g, b));
    final minVal = min(r, min(g, b));
    final delta = maxVal - minVal;

    double h = 0;
    double s = 0;
    final l = (maxVal + minVal) / 2;

    if (delta != 0) {
      s = l > 0.5 ? delta / (2 - maxVal - minVal) : delta / (maxVal + minVal);
      if (maxVal == r) {
        h = ((g - b) / delta) + (g < b ? 6 : 0);
      } else if (maxVal == g) {
        h = ((b - r) / delta) + 2;
      } else {
        h = ((r - g) / delta) + 4;
      }
      h /= 6;
    }

    return 'hsl(${(h * 360).round()}°, ${(s * 100).round()}%, ${(l * 100).round()}%)';
  }

  @override
  Widget build(BuildContext context) {
    final hexCode = _toHex(_currentColor);
    final flutterCode = 'Color(0xFF$hexCode)';
    final rgbCode = 'rgb(${_currentColor.red}, ${_currentColor.green}, ${_currentColor.blue})';
    final hslCode = _toHsl(_currentColor);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Color Format & Flutter Code Generator',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hexController,
                  maxLength: 6,
                  onChanged: _onHexChanged,
                  decoration: const InputDecoration(
                    labelText: 'HEX Color Code',
                    prefixText: '#',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Preset Seed Palette:', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _palettePresets.map((hex) {
              final col = Color(int.parse('FF$hex', radix: 16));
              return InkWell(
                onTap: () {
                  _hexController.text = hex;
                  _onHexChanged(hex);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: col,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$hex',
                    style: TextStyle(
                      color: ThemeData.estimateBrightnessForColor(col) == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _buildColorCard(context, 'Flutter Code', flutterCode, Icons.code),
          _buildColorCard(context, 'HEX Code', '#$hexCode', Icons.tag),
          _buildColorCard(context, 'RGB Value', rgbCode, Icons.invert_colors),
          _buildColorCard(context, 'HSL Value', hslCode, Icons.tune),
          const SizedBox(height: 16),
          Text(
            'Material 3 Palette Simulation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildShadeBox(_currentColor.withOpacity(0.2), '20%'),
              _buildShadeBox(_currentColor.withOpacity(0.4), '40%'),
              _buildShadeBox(_currentColor.withOpacity(0.6), '60%'),
              _buildShadeBox(_currentColor.withOpacity(0.8), '80%'),
              _buildShadeBox(_currentColor, '100%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(BuildContext context, String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: SelectableText(
          value,
          style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 15),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () => widget.onCopy(value, label),
        ),
      ),
    );
  }

  Widget _buildShadeBox(Color color, String label) {
    return Expanded(
      child: Container(
        height: 60,
        color: color,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TOOL 5: MOCK DATA GENERATOR
// ==========================================
class MockDataGeneratorView extends StatefulWidget {
  final Function(String, String) onCopy;

  const MockDataGeneratorView({super.key, required this.onCopy});

  @override
  State<MockDataGeneratorView> createState() => _MockDataGeneratorViewState();
}

class _MockDataGeneratorViewState extends State<MockDataGeneratorView> {
  int _generatorType = 0; // 0: UUID, 1: Lorem Ipsum, 2: Mock Users
  double _itemCount = 5;
  String _generatedOutput = '';

  final List<String> _firstNames = const ['Alex', 'Jordan', 'Taylor', 'Morgan', 'Sam', 'Chris', 'Pat'];
  final List<String> _lastNames = const ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis'];
  final List<String> _roles = const ['Admin', 'Developer', 'Designer', 'Manager', 'Tester'];

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  String _generateUuidV4() {
    final random = Random();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  void _generateData() {
    final count = _itemCount.toInt();
    final sb = StringBuffer();

    if (_generatorType == 0) {
      // UUID Generator
      for (int i = 0; i < count; i++) {
        sb.writeln(_generateUuidV4());
      }
    } else if (_generatorType == 1) {
      // Lorem Ipsum Paragraphs
      const lorem =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';
      for (int i = 0; i < count; i++) {
        sb.writeln('Paragraph ${i + 1}:');
        sb.writeln(lorem);
        sb.writeln();
      }
    } else {
      // Mock Users JSON
      final random = Random();
      final users = [];
      for (int i = 0; i < count; i++) {
        final fName = _firstNames[random.nextInt(_firstNames.length)];
        final lName = _lastNames[random.nextInt(_lastNames.length)];
        users.add({
          'id': _generateUuidV4(),
          'name': '$fName $lName',
          'email': '${fName.toLowerCase()}.${lName.toLowerCase()}@example.com',
          'role': _roles[random.nextInt(_roles.length)],
          'rate': '\$${(random.nextDouble() * 100 + 20).toStringAsFixed(2)}/hr',
          'createdAt': DateTime.now().subtract(Duration(days: random.nextInt(365))).toIso8601String(),
        });
      }
      sb.write(const JsonEncoder.withIndent('  ').convert(users));
    }

    setState(() {
      _generatedOutput = sb.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mock Data & UUID Generator',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('UUID v4')),
              ButtonSegment(value: 1, label: Text('Lorem Ipsum')),
              ButtonSegment(value: 2, label: Text('Mock Users')),
            ],
            selected: {_generatorType},
            onSelectionChanged: (set) {
              setState(() => _generatorType = set.first);
              _generateData();
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Count / Items: ${_itemCount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Slider(
                  value: _itemCount,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: _itemCount.toInt().toString(),
                  onChanged: (val) {
                    setState(() => _itemCount = val);
                    _generateData();
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: _generateData,
                icon: const Icon(Icons.refresh),
                label: const Text('Regenerate'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Generated Output', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy All Output',
                        onPressed: () => widget.onCopy(_generatedOutput, 'Mock Data'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  SelectableText(
                    _generatedOutput,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}