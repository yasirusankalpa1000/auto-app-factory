import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DevPulseApp());
}

class HistoryItem {
  final String title;
  final String content;
  final DateTime timestamp;

  HistoryItem({
    required this.title,
    required this.content,
    required this.timestamp,
  });
}

class DevPulseApp extends StatefulWidget {
  const DevPulseApp({super.key});

  @override
  State<DevPulseApp> createState() => _DevPulseAppState();
}

class _DevPulseAppState extends State<DevPulseApp> {
  bool _isDarkMode = true;
  final List<HistoryItem> _history = [];

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _addHistory(String title, String content) {
    if (content.trim().isEmpty) return;
    setState(() {
      _history.insert(
        0,
        HistoryItem(
          title: title,
          content: content,
          timestamp: DateTime.now(),
        ),
      );
      if (_history.length > 50) {
        _history.removeLast();
      }
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevPulse',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: MainHomeScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
        history: _history,
        onAddHistory: _addHistory,
        onClearHistory: _clearHistory,
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final List<HistoryItem> history;
  final Function(String, String) onAddHistory;
  final VoidCallback onClearHistory;

  const MainHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.history,
    required this.onAddHistory,
    required this.onClearHistory,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  void _copyToClipboard(BuildContext context, String text, String label) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DataConverterView(
        onSaveHistory: widget.onAddHistory,
        onCopy: (text, label) => _copyToClipboard(context, text, label),
      ),
      TextAndRegexView(
        onSaveHistory: widget.onAddHistory,
        onCopy: (text, label) => _copyToClipboard(context, text, label),
      ),
      GeneratorsView(
        onSaveHistory: widget.onAddHistory,
        onCopy: (text, label) => _copyToClipboard(context, text, label),
      ),
      HistoryView(
        history: widget.history,
        onClearHistory: widget.onClearHistory,
        onCopy: (text, label) => _copyToClipboard(context, text, label),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.terminal, color: Colors.indigoAccent),
            SizedBox(width: 10),
            Text(
              'DevPulse',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle Light/Dark Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.transform),
            selectedIcon: Icon(Icons.transform, color: Colors.indigo),
            label: 'Converters',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            selectedIcon: Icon(Icons.text_fields, color: Colors.indigo),
            label: 'Text & Regex',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.indigo),
            label: 'Generators',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history, color: Colors.indigo),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TAB 1: DATA CONVERTERS (JSON, Base64, URL)
// ==========================================
class DataConverterView extends StatefulWidget {
  final Function(String, String) onSaveHistory;
  final Function(String, String) onCopy;

  const DataConverterView({
    super.key,
    required this.onSaveHistory,
    required this.onCopy,
  });

  @override
  State<DataConverterView> createState() => _DataConverterViewState();
}

class _DataConverterViewState extends State<DataConverterView> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _errorMessage = '';

  void _formatJson() {
    setState(() => _errorMessage = '');
    try {
      if (_inputController.text.trim().isEmpty) return;
      final parsed = jsonDecode(_inputController.text);
      final pretty = const JsonEncoder.withIndent('  ').convert(parsed);
      _outputController.text = pretty;
      widget.onSaveHistory('JSON Format', pretty);
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid JSON: ${e.toString()}';
      });
    }
  }

  void _minifyJson() {
    setState(() => _errorMessage = '');
    try {
      if (_inputController.text.trim().isEmpty) return;
      final parsed = jsonDecode(_inputController.text);
      final minified = jsonEncode(parsed);
      _outputController.text = minified;
      widget.onSaveHistory('JSON Minify', minified);
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid JSON: ${e.toString()}';
      });
    }
  }

  void _encodeBase64() {
    setState(() => _errorMessage = '');
    try {
      final bytes = utf8.encode(_inputController.text);
      final encoded = base64Encode(bytes);
      _outputController.text = encoded;
      widget.onSaveHistory('Base64 Encode', encoded);
    } catch (e) {
      setState(() {
        _errorMessage = 'Encoding Error: ${e.toString()}';
      });
    }
  }

  void _decodeBase64() {
    setState(() => _errorMessage = '');
    try {
      final bytes = base64Decode(_inputController.text.trim());
      final decoded = utf8.decode(bytes);
      _outputController.text = decoded;
      widget.onSaveHistory('Base64 Decode', decoded);
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid Base64 string';
      });
    }
  }

  void _encodeUrl() {
    setState(() => _errorMessage = '');
    final encoded = Uri.encodeComponent(_inputController.text);
    _outputController.text = encoded;
    widget.onSaveHistory('URL Encode', encoded);
  }

  void _decodeUrl() {
    setState(() => _errorMessage = '');
    try {
      final decoded = Uri.decodeComponent(_inputController.text);
      _outputController.text = decoded;
      widget.onSaveHistory('URL Decode', decoded);
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid URL Encoded string';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Input Text / Payload',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('Clear'),
                        onPressed: () {
                          _inputController.clear();
                          _outputController.clear();
                          setState(() => _errorMessage = '');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputController,
                    maxLines: 5,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Paste raw JSON, plain text, Base64, or URL encoded string...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _formatJson,
                icon: const Icon(Icons.code),
                label: const Text('Format JSON'),
              ),
              ElevatedButton.icon(
                onPressed: _minifyJson,
                icon: const Icon(Icons.compress),
                label: const Text('Minify JSON'),
              ),
              OutlinedButton.icon(
                onPressed: _encodeBase64,
                icon: const Icon(Icons.lock_outline),
                label: const Text('Base64 Encode'),
              ),
              OutlinedButton.icon(
                onPressed: _decodeBase64,
                icon: const Icon(Icons.lock_open),
                label: const Text('Base64 Decode'),
              ),
              OutlinedButton.icon(
                onPressed: _encodeUrl,
                icon: const Icon(Icons.link),
                label: const Text('URL Encode'),
              ),
              OutlinedButton.icon(
                onPressed: _decodeUrl,
                icon: const Icon(Icons.link_off),
                label: const Text('URL Decode'),
              ),
            ],
          ),
          if (_errorMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Processed Output',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy Output',
                        onPressed: () => widget.onCopy(
                          _outputController.text,
                          'Output text',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _outputController,
                    readOnly: true,
                    maxLines: 8,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Result will appear here...',
                      border: OutlineInputBorder(),
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
}

// ==========================================
// TAB 2: TEXT & REGEX INSPECTOR TOOL
// ==========================================
class TextAndRegexView extends StatefulWidget {
  final Function(String, String) onSaveHistory;
  final Function(String, String) onCopy;

  const TextAndRegexView({
    super.key,
    required this.onSaveHistory,
    required this.onCopy,
  });

  @override
  State<TextAndRegexView> createState() => _TextAndRegexViewState();
}

class _TextAndRegexViewState extends State<TextAndRegexView> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _regexController = TextEditingController(text: r'\b\w+\b');
  List<String> _regexMatches = [];
  String _regexError = '';

  int get _charCount => _textController.text.length;
  int get _wordCount {
    final trimmed = _textController.text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }
  int get _lineCount {
    if (_textController.text.isEmpty) return 0;
    return _textController.text.split('\n').length;
  }

  void _applyCaseTransformation(String type) {
    final raw = _textController.text;
    if (raw.isEmpty) return;

    String result = raw;
    switch (type) {
      case 'UPPERCASE':
        result = raw.toUpperCase();
        break;
      case 'lowercase':
        result = raw.toLowerCase();
        break;
      case 'Title Case':
        result = raw.split(' ').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }).join(' ');
        break;
      case 'camelCase':
        final words = raw.trim().split(RegExp(r'[\s_\-]+'));
        if (words.isNotEmpty) {
          final first = words.first.toLowerCase();
          final rest = words.skip(1).map((w) {
            if (w.isEmpty) return '';
            return w[0].toUpperCase() + w.substring(1).toLowerCase();
          }).join('');
          result = '$first$rest';
        }
        break;
      case 'snake_case':
        result = raw
            .trim()
            .replaceAll(RegExp(r'[\s\-]+'), '_')
            .toLowerCase();
        break;
      case 'kebab-case':
        result = raw
            .trim()
            .replaceAll(RegExp(r'[\s_]+'), '-')
            .toLowerCase();
        break;
    }

    setState(() {
      _textController.text = result;
    });
    widget.onSaveHistory('Case Convert ($type)', result);
  }

  void _testRegex() {
    setState(() {
      _regexError = '';
      _regexMatches.clear();
    });

    if (_regexController.text.isEmpty || _textController.text.isEmpty) return;

    try {
      final regExp = RegExp(_regexController.text);
      final matches = regExp.allMatches(_textController.text);
      setState(() {
        _regexMatches = matches.map((m) => m.group(0) ?? '').toList();
      });
    } catch (e) {
      setState(() {
        _regexError = 'Invalid Regex Pattern';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Text Analyzer & Transformer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    onChanged: (_) {
                      setState(() {});
                      _testRegex();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type or paste text to analyze...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.short_text, size: 16),
                        label: Text('Chars: $_charCount'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.notes, size: 16),
                        label: Text('Words: $_wordCount'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.wrap_text, size: 16),
                        label: Text('Lines: $_lineCount'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quick Transformations',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ActionChip(
                        label: const Text('UPPERCASE'),
                        onPressed: () => _applyCaseTransformation('UPPERCASE'),
                      ),
                      ActionChip(
                        label: const Text('lowercase'),
                        onPressed: () => _applyCaseTransformation('lowercase'),
                      ),
                      ActionChip(
                        label: const Text('Title Case'),
                        onPressed: () => _applyCaseTransformation('Title Case'),
                      ),
                      ActionChip(
                        label: const Text('camelCase'),
                        onPressed: () => _applyCaseTransformation('camelCase'),
                      ),
                      ActionChip(
                        label: const Text('snake_case'),
                        onPressed: () => _applyCaseTransformation('snake_case'),
                      ),
                      ActionChip(
                        label: const Text('kebab-case'),
                        onPressed: () => _applyCaseTransformation('kebab-case'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Regex Tester',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _regexController,
                          onChanged: (_) => _testRegex(),
                          style: const TextStyle(fontFamily: 'monospace'),
                          decoration: const InputDecoration(
                            labelText: 'Regular Expression Pattern',
                            prefixText: 'r/ ',
                            suffixText: ' /g',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.search),
                        onPressed: _testRegex,
                        tooltip: 'Match',
                      ),
                    ],
                  ),
                  if (_regexError.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _regexError,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Matches (${_regexMatches.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_regexMatches.isNotEmpty)
                        TextButton.icon(
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy All Matches'),
                          onPressed: () => widget.onCopy(
                            _regexMatches.join(', '),
                            'Regex matches',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _regexMatches.isEmpty
                      ? const Text(
                          'No matches found for the given pattern.',
                          style: TextStyle(color: Colors.grey),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: _regexMatches.map((m) {
                            return Chip(
                              backgroundColor: Colors.teal.withAlpha(40),
                              label: Text(
                                m,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            );
                          }).toList(),
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
// TAB 3: GENERATORS (UUID & PASSWORD)
// ==========================================
class GeneratorsView extends StatefulWidget {
  final Function(String, String) onSaveHistory;
  final Function(String, String) onCopy;

  const GeneratorsView({
    super.key,
    required this.onSaveHistory,
    required this.onCopy,
  });

  @override
  State<GeneratorsView> createState() => _GeneratorsViewState();
}

class _GeneratorsViewState extends State<GeneratorsView> {
  // UUID Config
  int _uuidCount = 3;
  bool _uuidUppercase = false;
  bool _uuidRemoveHyphens = false;
  List<String> _generatedUuids = [];

  // Password Config
  double _passwordLength = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _generateUuids();
    _generatePassword();
  }

  String _generateSingleUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    // Variant and version bit tuning for UUID v4 compliance
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String hex(int byte) => byte.toRadixString(16).padLeft(2, '0');

    final sb = StringBuffer();
    sb.write(hex(bytes[0]));
    sb.write(hex(bytes[1]));
    sb.write(hex(bytes[2]));
    sb.write(hex(bytes[3]));
    sb.write('-');
    sb.write(hex(bytes[4]));
    sb.write(hex(bytes[5]));
    sb.write('-');
    sb.write(hex(bytes[6]));
    sb.write(hex(bytes[7]));
    sb.write('-');
    sb.write(hex(bytes[8]));
    sb.write(hex(bytes[9]));
    sb.write('-');
    sb.write(hex(bytes[10]));
    sb.write(hex(bytes[11]));
    sb.write(hex(bytes[12]));
    sb.write(hex(bytes[13]));
    sb.write(hex(bytes[14]));
    sb.write(hex(bytes[15]));

    String result = sb.toString();
    if (_uuidRemoveHyphens) {
      result = result.replaceAll('-', '');
    }
    if (_uuidUppercase) {
      result = result.toUpperCase();
    }
    return result;
  }

  void _generateUuids() {
    final list = <String>[];
    for (int i = 0; i < _uuidCount; i++) {
      list.add(_generateSingleUuidV4());
    }
    setState(() {
      _generatedUuids = list;
    });
    widget.onSaveHistory('Generated UUIDs', list.join('\n'));
  }

  void _generatePassword() {
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const numberChars = '0123456789';
    const symbolChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String allowedChars = '';
    if (_includeUppercase) allowedChars += uppercaseChars;
    if (_includeLowercase) allowedChars += lowercaseChars;
    if (_includeNumbers) allowedChars += numberChars;
    if (_includeSymbols) allowedChars += symbolChars;

    if (allowedChars.isEmpty) {
      setState(() {
        _generatedPassword = 'Select at least one option!';
      });
      return;
    }

    final rand = Random.secure();
    final chars = List<String>.generate(
      _passwordLength.round(),
      (_) => allowedChars[rand.nextInt(allowedChars.length)],
    );

    final pass = chars.join('');
    setState(() {
      _generatedPassword = pass;
    });
    widget.onSaveHistory('Generated Password/Token', pass);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // UUID GENERATOR
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UUID v4 Generator',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Quantity:'),
                      Expanded(
                        child: Slider(
                          value: _uuidCount.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: '$_uuidCount',
                          onChanged: (val) {
                            setState(() => _uuidCount = val.round());
                          },
                        ),
                      ),
                      Text(
                        '$_uuidCount',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('Uppercase'),
                        selected: _uuidUppercase,
                        onSelected: (val) {
                          setState(() => _uuidUppercase = val);
                        },
                      ),
                      FilterChip(
                        label: const Text('Remove Hyphens'),
                        selected: _uuidRemoveHyphens,
                        onSelected: (val) {
                          setState(() => _uuidRemoveHyphens = val);
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Generate'),
                        onPressed: _generateUuids,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black26
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: _generatedUuids.map((uuid) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  uuid,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                onPressed: () => widget.onCopy(uuid, 'UUID'),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SECURE PASSWORD GENERATOR
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Secure Token / Password Generator',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Length:'),
                      Expanded(
                        child: Slider(
                          value: _passwordLength,
                          min: 8,
                          max: 64,
                          divisions: 56,
                          label: '${_passwordLength.round()}',
                          onChanged: (val) {
                            setState(() => _passwordLength = val);
                          },
                        ),
                      ),
                      Text(
                        '${_passwordLength.round()}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text('A-Z'),
                        selected: _includeUppercase,
                        onSelected: (v) => setState(() => _includeUppercase = v),
                      ),
                      FilterChip(
                        label: const Text('a-z'),
                        selected: _includeLowercase,
                        onSelected: (v) => setState(() => _includeLowercase = v),
                      ),
                      FilterChip(
                        label: const Text('0-9'),
                        selected: _includeNumbers,
                        onSelected: (v) => setState(() => _includeNumbers = v),
                      ),
                      FilterChip(
                        label: const Text('!\$#%'),
                        selected: _includeSymbols,
                        onSelected: (v) => setState(() => _includeSymbols = v),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.key),
                        label: const Text('Generate'),
                        onPressed: _generatePassword,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black26
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _generatedPassword,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => widget.onCopy(
                            _generatedPassword,
                            'Password/Token',
                          ),
                        ),
                      ],
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
}

// ==========================================
// TAB 4: SESSION HISTORY LOG
// ==========================================
class HistoryView extends StatelessWidget {
  final List<HistoryItem> history;
  final VoidCallback onClearHistory;
  final Function(String, String) onCopy;

  const HistoryView({
    super.key,
    required this.history,
    required this.onClearHistory,
    required this.onCopy,
  });

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No generated items yet.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Actions perform in other tabs will log here.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Log (${history.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('Clear All', style: TextStyle(color: Colors.red)),
                onPressed: onClearHistory,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        _formatTimestamp(item.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      item.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () => onCopy(item.content, item.title),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}