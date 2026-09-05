import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Global ValueNotifier to dynamically change the app's theme color
final ValueNotifier<Color> appPrimaryColorNotifier =
    ValueNotifier<Color>(const Color(0xFF00BFA5));

void main() {
  runApp(const DevPulseApp());
}

class DevPulseApp extends StatefulWidget {
  const DevPulseApp({super.key});

  @override
  State<DevPulseApp> createState() => _DevPulseAppState();
}

class _DevPulseAppState extends State<DevPulseApp> {
  @override
  Widget build(BuildContext meContext) {
    return ValueListenableBuilder<Color>(
      valueListenable: appPrimaryColorNotifier,
      builder: (context, primaryColor, child) {
        return MaterialApp(
          title: 'DevPulse Utilities',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              brightness: Brightness.dark,
              primary: primaryColor,
              surface: const Color(0xFF1E222A),
            ),
            scaffoldBackgroundColor: const Color(0xFF12151C),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E222A),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

// Global Theme Color Selector Dialog accessible from any screen
void showGlobalThemeColorPicker(BuildContext context) {
  Color currentColor = appPrimaryColorNotifier.value;
  double hue = HSVColor.fromColor(currentColor).hue;
  double saturation = HSVColor.fromColor(currentColor).saturation;
  double value = HSVColor.fromColor(currentColor).value;

  final List<Color> quickSwatches = [
    const Color(0xFF00BFA5), // Teal
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.deepOrangeAccent,
    Colors.limeAccent,
  ];

  showDialog(
    context: context,
    builder: (dialogCtx) {
      return StatefulBuilder(
        builder: (ctx, setPickerState) {
          final tempColor = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
          final hexVal = tempColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();

          return AlertDialog(
            backgroundColor: const Color(0xFF1E222A),
            title: const Text('Pick App Theme Color'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: tempColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: tempColor.withAlpha(100),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '#$hexVal',
                        style: TextStyle(
                          color: tempColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Preset Swatches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: quickSwatches.map((c) {
                      final isSelected = tempColor.value == c.value;
                      return GestureDetector(
                        onTap: () {
                          setPickerState(() {
                            hue = HSVColor.fromColor(c).hue;
                            saturation = HSVColor.fromColor(c).saturation;
                            value = HSVColor.fromColor(c).value;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: c.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Color Spectrum (Hue)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Slider(
                    value: hue,
                    min: 0.0,
                    max: 360.0,
                    activeColor: HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
                    onChanged: (val) => setPickerState(() => hue = val),
                  ),
                  const Text('Saturation (Intensity)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Slider(
                    value: saturation,
                    min: 0.0,
                    max: 1.0,
                    activeColor: tempColor,
                    onChanged: (val) => setPickerState(() => saturation = val),
                  ),
                  const Text('Brightness', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Slider(
                    value: value,
                    min: 0.0,
                    max: 1.0,
                    activeColor: tempColor,
                    onChanged: (val) => setPickerState(() => value = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  appPrimaryColorNotifier.value = tempColor;
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App theme color updated successfully!')),
                  );
                },
                child: const Text('Apply Theme Color'),
              ),
            ],
          );
        },
      );
    },
  );
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    JsonToolPage(),
    EncoderToolPage(),
    ColorInspectorPage(),
    SnippetVaultPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFF1E222A),
        indicatorColor: primaryColor.withAlpha(80),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.code),
            selectedIcon: Icon(Icons.code, color: primaryColor),
            label: 'JSON',
          ),
          NavigationDestination(
            icon: const Icon(Icons.transform),
            selectedIcon: Icon(Icons.transform, color: primaryColor),
            label: 'Encoder',
          ),
          NavigationDestination(
            icon: const Icon(Icons.palette),
            selectedIcon: Icon(Icons.palette, color: primaryColor),
            label: 'Colors',
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_stories),
            selectedIcon: Icon(Icons.auto_stories, color: primaryColor),
            label: 'Vault',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 1. JSON FORMATTER & MINIFIER
// ==========================================
class JsonToolPage extends StatefulWidget {
  const JsonToolPage({super.key});

  @override
  State<JsonToolPage> createState() => _JsonToolPageState();
}

class _JsonToolPageState extends State<JsonToolPage> {
  final TextEditingController _controller = TextEditingController();
  String _errorMessage = '';
  String _statsMessage = 'Ready';

  void _formatJson() {
    final rawText = _controller.text.trim();
    if (rawText.isEmpty) return;

    try {
      final parsed = json.decode(rawText);
      final pretty = const JsonEncoder.withIndent('  ').convert(parsed);
      setState(() {
        _controller.text = pretty;
        _errorMessage = '';
        _statsMessage = 'Valid JSON • ${pretty.length} chars';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _statsMessage = 'Invalid JSON';
      });
    }
  }

  void _minifyJson() {
    final rawText = _controller.text.trim();
    if (rawText.isEmpty) return;

    try {
      final parsed = json.decode(rawText);
      final minified = json.encode(parsed);
      setState(() {
        _controller.text = minified;
        _errorMessage = '';
        _statsMessage = 'Minified • ${minified.length} chars';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _statsMessage = 'Invalid JSON';
      });
    }
  }

  void _loadSample() {
    const sample =
        '{"name":"DevPulse","version":1.0,"features":["JSON","Encoder","Palette"],"active":true,"pricing":{"tier":"free","cost":"\\\$0.00"}}';
    setState(() {
      _controller.text = sample;
      _errorMessage = '';
      _statsMessage = 'Loaded Sample JSON';
    });
  }

  void _copyToClipboard() {
    if (_controller.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _controller.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied JSON to clipboard!')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('JSON Studio'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens_outlined),
              tooltip: 'Choose Theme Color',
              onPressed: () => showGlobalThemeColorPicker(context),
            ),
            IconButton(
              icon: const Icon(Icons.lightbulb),
              tooltip: 'Sample Data',
              onPressed: _loadSample,
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy Output',
              onPressed: _copyToClipboard,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _formatJson,
                    icon: const Icon(Icons.format_indent_increase, size: 18),
                    label: const Text('Pretty Print'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor.withAlpha(50),
                      foregroundColor: primaryColor,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _minifyJson,
                    icon: const Icon(Icons.compress, size: 18),
                    label: const Text('Minify'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _errorMessage = '';
                        _statsMessage = 'Cleared';
                      });
                    },
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statsMessage,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(40),
                    border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    softWrap: true,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                maxLines: 18,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Paste raw JSON string here...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF181B22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. TEXT ENCODER & DECODER
// ==========================================
class EncoderToolPage extends StatefulWidget {
  const EncoderToolPage({super.key});

  @override
  State<EncoderToolPage> createState() => _EncoderToolPageState();
}

class _EncoderToolPageState extends State<EncoderToolPage> {
  final TextEditingController _inputController = TextEditingController();
  String _outputText = '';
  String _activeOperation = 'Base64 Encode';

  void _processText() {
    final text = _inputController.text;
    if (text.isEmpty) {
      setState(() => _outputText = '');
      return;
    }

    try {
      switch (_activeOperation) {
        case 'Base64 Encode':
          setState(() => _outputText = base64.encode(utf8.encode(text)));
          break;
        case 'Base64 Decode':
          setState(() => _outputText = utf8.decode(base64.decode(text)));
          break;
        case 'URL Encode':
          setState(() => _outputText = Uri.encodeComponent(text));
          break;
        case 'URL Decode':
          setState(() => _outputText = Uri.decodeComponent(text));
          break;
      }
    } catch (e) {
      setState(() => _outputText = 'Error processing text: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Text Encoder & Decoder'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens_outlined),
              tooltip: 'Choose Theme Color',
              onPressed: () => showGlobalThemeColorPicker(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  'Base64 Encode',
                  'Base64 Decode',
                  'URL Encode',
                  'URL Decode',
                ].map((op) {
                  final isSelected = _activeOperation == op;
                  return ChoiceChip(
                    label: Text(op),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _activeOperation = op;
                          _processText();
                        });
                      }
                    },
                    selectedColor: primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _inputController,
                maxLines: 5,
                onChanged: (_) => _processText(),
                decoration: const InputDecoration(
                  labelText: 'Input Text',
                  hintText: 'Type or paste text to convert...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF181B22),
                ),
              ),
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
                          Flexible(
                            child: Text(
                              'Result ($_activeOperation)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              if (_outputText.isNotEmpty) {
                                Clipboard.setData(ClipboardData(text: _outputText));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Result copied!')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        _outputText.isEmpty ? 'Output will appear here...' : _outputText,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: _outputText.isEmpty ? Colors.grey : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. COLOR & CONTRAST INSPECTOR
// ==========================================
class ColorInspectorPage extends StatefulWidget {
  const ColorInspectorPage({super.key});

  @override
  State<ColorInspectorPage> createState() => _ColorInspectorPageState();
}

class _ColorInspectorPageState extends State<ColorInspectorPage> {
  final TextEditingController _hexController = TextEditingController(text: '00BFA5');
  Color _currentColor = const Color(0xFF00BFA5);
  bool _isValidHex = true;

  final List<Color> _presetColors = const [
    Color(0xFF00BFA5), // Teal
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.indigoAccent,
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.yellowAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.white,
    Colors.black,
  ];

  void _setColor(Color color) {
    setState(() {
      _currentColor = color;
      _isValidHex = true;
      final hex = color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
      _hexController.text = hex;
    });
  }

  void _updateColorFromText(String hex) {
    String cleanHex = hex.replaceAll('#', '').trim();
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    if (cleanHex.length == 8) {
      final val = int.tryParse(cleanHex, radix: 16);
      if (val != null) {
        setState(() {
          _currentColor = Color(val);
          _isValidHex = true;
        });
        return;
      }
    }
    setState(() => _isValidHex = false);
  }

  void _openInteractiveColorPicker() {
    double hue = HSVColor.fromColor(_currentColor).hue;
    double saturation = HSVColor.fromColor(_currentColor).saturation;
    double value = HSVColor.fromColor(_currentColor).value;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setPickerState) {
            final tempColor = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
            final hexVal = tempColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();

            return AlertDialog(
              backgroundColor: const Color(0xFF1E222A),
              title: const Text('Custom Interactive Color Picker'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: tempColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: tempColor.withAlpha(120),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '#$hexVal',
                          style: TextStyle(
                            color: tempColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Hue Spectrum', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Slider(
                      value: hue,
                      min: 0.0,
                      max: 360.0,
                      activeColor: HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
                      onChanged: (val) {
                        setPickerState(() {
                          hue = val;
                        });
                      },
                    ),
                    const Text('Saturation (Color Intensity)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Slider(
                      value: saturation,
                      min: 0.0,
                      max: 1.0,
                      activeColor: tempColor,
                      onChanged: (val) {
                        setPickerState(() {
                          saturation = val;
                        });
                      },
                    ),
                    const Text('Brightness / Value', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Slider(
                      value: value,
                      min: 0.0,
                      max: 1.0,
                      activeColor: tempColor,
                      onChanged: (val) {
                        setPickerState(() {
                          value = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _setColor(tempColor);
                    Navigator.pop(dialogCtx);
                  },
                  child: const Text('Select Color'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double _calculateLuminance(Color color) {
    return color.computeLuminance();
  }

  double _contrastRatio(Color c1, Color c2) {
    final l1 = _calculateLuminance(c1) + 0.05;
    final l2 = _calculateLuminance(c2) + 0.05;
    return l1 > l2 ? l1 / l2 : l2 / l1;
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contrastWithWhite = _contrastRatio(_currentColor, Colors.white);
    final contrastWithBlack = _contrastRatio(_currentColor, Colors.black);
    final hexString = _currentColor.value.toRadixString(16).padLeft(8, '0').toUpperCase();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Color Studio & Inspector'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.palette),
              tooltip: 'Choose Visual Color',
              onPressed: _openInteractiveColorPicker,
            ),
            IconButton(
              icon: const Icon(Icons.format_paint),
              tooltip: 'Set as App Theme',
              onPressed: () {
                appPrimaryColorNotifier.value = _currentColor;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Applied selected color as global App Theme!')),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _hexController,
                maxLength: 9,
                onChanged: _updateColorFromText,
                decoration: InputDecoration(
                  labelText: 'HEX Color Code',
                  hintText: 'e.g. #00BFA5 or 00BFA5',
                  errorText: _isValidHex ? null : 'Invalid HEX format',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.colorize, color: _currentColor),
                    onPressed: _openInteractiveColorPicker,
                    tooltip: 'Pick Visual Color',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 100,
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _currentColor.withAlpha(100),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '#${hexString.substring(2)}',
                        style: TextStyle(
                          color: contrastWithWhite > contrastWithBlack ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Pick Color" to choose visually',
                        style: TextStyle(
                          color: (contrastWithWhite > contrastWithBlack ? Colors.white : Colors.black)
                              .withAlpha(180),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ElevatedButton.icon(
                    onPressed: _openInteractiveColorPicker,
                    icon: const Icon(Icons.palette),
                    label: const Text('Open Visual Picker'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      appPrimaryColorNotifier.value = _currentColor;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updated global App Theme Color!')),
                      );
                    },
                    icon: const Icon(Icons.format_paint),
                    label: const Text('Apply as App Theme'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Preset Palette Swatch',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _presetColors.map((color) {
                          final isSelected = _currentColor.value == color.value;
                          return GestureDetector(
                            onTap: () => _setColor(color),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: color.withAlpha(150),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                ],
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 20,
                                      color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
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
                        'RGB Interactive Sliders',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildRgbSlider('Red', _currentColor.red, Colors.red, (val) {
                        _setColor(Color.fromRGBO(val.toInt(), _currentColor.green, _currentColor.blue, 1.0));
                      }),
                      _buildRgbSlider('Green', _currentColor.green, Colors.green, (val) {
                        _setColor(Color.fromRGBO(_currentColor.red, val.toInt(), _currentColor.blue, 1.0));
                      }),
                      _buildRgbSlider('Blue', _currentColor.blue, Colors.blue, (val) {
                        _setColor(Color.fromRGBO(_currentColor.red, _currentColor.green, val.toInt(), 1.0));
                      }),
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
                        'WCAG Accessibility Contrast',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildContrastRow('White Text Contrast', contrastWithWhite),
                      const SizedBox(height: 8),
                      _buildContrastRow('Black Text Contrast', contrastWithBlack),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Flutter Code Generator',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              final codeText = 'Color(0x$hexString)';
                              Clipboard.setData(ClipboardData(text: codeText));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Copied "$codeText"')),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      SelectableText(
                        'const Color(0x$hexString)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRgbSlider(String label, int value, Color activeColor, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            activeColor: activeColor,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 35,
          child: Text(
            '$value',
            textAlign: TextAlign.end,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildContrastRow(String label, double ratio) {
    final passesAA = ratio >= 4.5;
    final passesAAA = ratio >= 7.0;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${ratio.toStringAsFixed(2)}:1',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text(passesAAA ? 'AAA' : (passesAA ? 'AA' : 'Fail')),
          backgroundColor: passesAA ? Colors.green.withAlpha(50) : Colors.red.withAlpha(50),
          side: BorderSide(color: passesAA ? Colors.green : Colors.red),
          labelStyle: TextStyle(
            color: passesAA ? Colors.greenAccent : Colors.redAccent,
            fontSize: 11,
          ),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

// ==========================================
// 4. CODE SNIPPET VAULT
// ==========================================
class SnippetItem {
  final String id;
  final String title;
  final String language;
  final String code;

  SnippetItem({
    required this.id,
    required this.title,
    required this.language,
    required this.code,
  });
}

class SnippetVaultPage extends StatefulWidget {
  const SnippetVaultPage({super.key});

  @override
  State<SnippetVaultPage> createState() => _SnippetVaultPageState();
}

class _SnippetVaultPageState extends State<SnippetVaultPage> {
  final List<SnippetItem> _snippets = [
    SnippetItem(
      id: '1',
      title: 'Flutter Responsive LayoutBuilder',
      language: 'Dart',
      code:
          'LayoutBuilder(\n  builder: (context, constraints) {\n    if (constraints.maxWidth > 600) {\n      return WideLayout();\n    }\n    return NarrowLayout();\n  },\n);',
    ),
    SnippetItem(
      id: '2',
      title: 'Async Delay Example',
      language: 'Dart',
      code: 'await Future.delayed(const Duration(seconds: 2));',
    ),
    SnippetItem(
      id: '3',
      title: 'JSON Decoding Safely',
      language: 'Dart',
      code:
          'try {\n  final data = jsonDecode(rawString);\n} catch (e) {\n  print(\'Decoding failed: \$e\');\n}',
    ),
  ];

  String _searchQuery = '';

  void _addSnippet(String title, String language, String code) {
    setState(() {
      _snippets.insert(
        0,
        SnippetItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          language: language,
          code: code,
        ),
      );
    });
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final langController = TextEditingController(text: 'Dart');
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Add Code Snippet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Snippet Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: langController,
                  decoration: const InputDecoration(
                    labelText: 'Language/Tag',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Code Content',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && codeController.text.isNotEmpty) {
                  _addSnippet(
                    titleController.text,
                    langController.text,
                    codeController.text,
                  );
                  Navigator.pop(dialogCtx);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final filtered = _snippets.where((s) {
      final q = _searchQuery.toLowerCase();
      return s.title.toLowerCase().contains(q) ||
          s.language.toLowerCase().contains(q) ||
          s.code.toLowerCase().contains(q);
    }).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Snippet Vault'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens_outlined),
              tooltip: 'Choose Theme Color',
              onPressed: () => showGlobalThemeColorPicker(context),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddDialog,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search snippets...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF181B22),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No snippets found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (ctx, index) {
                          final item = filtered[index];
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
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Chip(
                                        label: Text(item.language),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: primaryColor.withAlpha(40),
                                        labelStyle: TextStyle(
                                          color: primaryColor,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF14171D),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SelectableText(
                                      item.code,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            _snippets.removeWhere((s) => s.id == item.id);
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.copy, size: 18, color: primaryColor),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: item.code));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Copied "${item.title}"')),
                                          );
                                        },
                                      ),
                                    ],
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
        ),
      ),
    );
  }
}