import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const APIFluxApp());
}

class APIFluxApp extends StatelessWidget {
  const APIFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APIFlux Workbench',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF12121D),
        cardTheme: const CardTheme(
          color: Color(0xFF1E1E2E),
          elevation: 2,
        ),
      ),
      home: const MainWorkbenchScreen(),
    );
  }
}

class KeyValuePair {
  String key;
  String value;
  bool enabled;

  KeyValuePair({this.key = '', this.value = '', this.enabled = true});
}

class HistoryItem {
  final String id;
  final String url;
  final String method;
  final int statusCode;
  final DateTime timestamp;

  HistoryItem({
    required this.id,
    required this.url,
    required this.method,
    required this.statusCode,
    required this.timestamp,
  });
}

class SavedRequest {
  final String id;
  final String name;
  final String url;
  final String method;
  final String category;

  SavedRequest({
    required this.id,
    required this.name,
    required this.url,
    required this.method,
    required this.category,
  });
}

class MainWorkbenchScreen extends StatefulWidget {
  const MainWorkbenchScreen({super.key});

  @override
  State<MainWorkbenchScreen> createState() => _MainWorkbenchScreenState();
}

class _MainWorkbenchScreenState extends State<MainWorkbenchScreen>
    with SingleTickerProviderStateMixin {
  int _currentBottomNavIndex = 0;

  // Request Builder State
  String _selectedMethod = 'GET';
  final TextEditingController _urlController = TextEditingController(
    text: 'https://jsonplaceholder.typicode.com/posts/1',
  );
  
  final List<KeyValuePair> _queryParams = [
    KeyValuePair(key: 'format', value: 'json', enabled: true),
  ];
  final List<KeyValuePair> _headers = [
    KeyValuePair(key: 'Accept', value: 'application/json', enabled: true),
    KeyValuePair(key: 'User-Agent', value: 'APIFlux/1.0.0', enabled: true),
  ];

  final TextEditingController _bodyController = TextEditingController();
  String _authType = 'None'; // 'None', 'Bearer', 'Basic'
  final TextEditingController _bearerTokenController = TextEditingController();
  final TextEditingController _basicUserController = TextEditingController();
  final TextEditingController _basicPassController = TextEditingController();

  bool _useMockEngine = false;
  bool _isLoading = false;
  int? _statusCode;
  String _statusText = '';
  int _responseTimeMs = 0;
  int _responseSizeBytes = 0;
  String _responseBody = '';
  Map<String, String> _responseHeaders = {};
  String _errorMessage = '';

  // Collections & History
  final List<HistoryItem> _history = [
    HistoryItem(
      id: '1',
      url: 'https://jsonplaceholder.typicode.com/posts/1',
      method: 'GET',
      statusCode: 200,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    HistoryItem(
      id: '2',
      url: 'https://reqres.in/api/users',
      method: 'POST',
      statusCode: 201,
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
  ];

  final List<SavedRequest> _savedRequests = [
    SavedRequest(
      id: 's1',
      name: 'Get Post Sample',
      url: 'https://jsonplaceholder.typicode.com/posts/1',
      method: 'GET',
      category: 'JSONPlaceholder',
    ),
    SavedRequest(
      id: 's2',
      name: 'GitHub User Info',
      url: 'https://api.github.com/users/flutter',
      method: 'GET',
      category: 'GitHub API',
    ),
    SavedRequest(
      id: 's3',
      name: 'HttpBin Test Endpoint',
      url: 'https://httpbin.org/get',
      method: 'GET',
      category: 'HttpBin',
    ),
  ];

  // Utility Studio Controllers
  final TextEditingController _jsonInputController = TextEditingController(
    text: '{"name":"APIFlux","type":"Utility","version":1.0,"features":["HTTP","Mock","Utils"]}',
  );
  String _jsonOutput = '';

  final TextEditingController _b64InputController = TextEditingController(text: 'Hello APIFlux Workbench!');
  String _b64Output = '';
  bool _b64EncodeMode = true;

  final TextEditingController _urlEncodeInputController = TextEditingController(text: 'https://api.example.com/search?q=flutter workbench&category=tools');
  String _urlEncodeOutput = '';
  bool _urlEncodeMode = true;

  final TextEditingController _jwtInputController = TextEditingController(
    text: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkphbmUgRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJyb2xlIjoiQWRtaW4ifQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
  );
  String _jwtHeaderOutput = '';
  String _jwtPayloadOutput = '';

  @override
  void initState() {
    super.initState();
    _formatInitialJson();
    _processBase64();
    _processUrlEncode();
    _processJwt();
  }

  void _formatInitialJson() {
    try {
      final parsed = json.decode(_jsonInputController.text);
      _jsonOutput = const JsonEncoder.withIndent('  ').convert(parsed);
    } catch (e) {
      _jsonOutput = 'Invalid JSON input';
    }
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      case 'HEAD':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(int? code) {
    if (code == null) return Colors.grey;
    if (code >= 200 && code < 300) return Colors.green;
    if (code >= 300 && code < 400) return Colors.blue;
    if (code >= 400 && code < 500) return Colors.orange;
    return Colors.red;
  }

  Future<void> _executeRequest() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _statusCode = null;
      _responseBody = '';
      _responseHeaders = {};
    });

    final urlText = _urlController.text.trim();
    if (urlText.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter a valid HTTP/HTTPS URL';
      });
      return;
    }

    if (_useMockEngine || urlText.startsWith('mock://')) {
      await Future.delayed(const Duration(milliseconds: 350));
      final mockData = {
        "status": "success",
        "mock_engine": true,
        "timestamp": DateTime.now().toIso8601String(),
        "request": {
          "method": _selectedMethod,
          "url": urlText,
          "auth": _authType,
        },
        "response": {
          "user_id": "usr_88A92",
          "account_code": "ACC-\$9902",
          "credits": 2500,
          "features": ["Endpoint Testing", "JWT Inspection", "Mock Server"],
          "rate_limit": {"limit": 1000, "remaining": 998}
        }
      };

      final formattedMock = const JsonEncoder.withIndent('  ').convert(mockData);
      setState(() {
        _isLoading = false;
        _statusCode = 200;
        _statusText = 'OK (Local Mock)';
        _responseTimeMs = 42;
        _responseBody = formattedMock;
        _responseSizeBytes = utf8.encode(formattedMock).length;
        _responseHeaders = {
          'content-type': 'application/json; charset=utf-8',
          'x-apiflux-mock': 'true',
          'server': 'APIFlux Mock Engine v1.0',
          'date': DateTime.now().toUtc().toString(),
        };
        _addToHistory(urlText, _selectedMethod, 200);
      });
      return;
    }

    final stopwatch = Stopwatch()..start();
    HttpClient? client;
    try {
      client = HttpClient()..connectionTimeout = const Duration(seconds: 12);
      
      String formattedUrl = urlText;
      if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
        formattedUrl = 'https://$formattedUrl';
      }

      Uri uri = Uri.parse(formattedUrl);

      // Add query parameters
      final activeParams = _queryParams.where((p) => p.enabled && p.key.trim().isNotEmpty).toList();
      if (activeParams.isNotEmpty) {
        final queryMap = Map<String, String>.from(uri.queryParameters);
        for (var p in activeParams) {
          queryMap[p.key.trim()] = p.value.trim();
        }
        uri = uri.replace(queryParameters: queryMap);
      }

      HttpClientRequest request;
      switch (_selectedMethod) {
        case 'POST':
          request = await client.postUrl(uri);
          break;
        case 'PUT':
          request = await client.putUrl(uri);
          break;
        case 'DELETE':
          request = await client.deleteUrl(uri);
          break;
        case 'PATCH':
          request = await client.patchUrl(uri);
          break;
        case 'HEAD':
          request = await client.headUrl(uri);
          break;
        default:
          request = await client.getUrl(uri);
          break;
      }

      // Add headers
      for (var h in _headers) {
        if (h.enabled && h.key.trim().isNotEmpty) {
          request.headers.set(h.key.trim(), h.value.trim());
        }
      }

      // Authentication Headers
      if (_authType == 'Bearer' && _bearerTokenController.text.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer ${_bearerTokenController.text.trim()}');
      } else if (_authType == 'Basic' && _basicUserController.text.isNotEmpty) {
        final rawCreds = '${_basicUserController.text.trim()}:${_basicPassController.text.trim()}';
        final encoded = base64.encode(utf8.encode(rawCreds));
        request.headers.set('Authorization', 'Basic $encoded');
      }

      // Write Request Body if applicable
      if (['POST', 'PUT', 'PATCH'].contains(_selectedMethod) && _bodyController.text.isNotEmpty) {
        if (request.headers.value('content-type') == null) {
          request.headers.set('content-type', 'application/json; charset=utf-8');
        }
        request.write(_bodyController.text);
      }

      final response = await request.close();
      stopwatch.stop();

      final responseBytes = await response.fold<List<int>>(<int>[], (acc, data) => acc..addAll(data));
      final rawBody = utf8.decode(responseBytes, allowMalformed: true);

      String formattedBody = rawBody;
      try {
        final jsonParsed = json.decode(rawBody);
        formattedBody = const JsonEncoder.withIndent('  ').convert(jsonParsed);
      } catch (_) {
        // Keep raw text if not valid JSON
      }

      final headerMap = <String, String>{};
      response.headers.forEach((name, values) {
        headerMap[name] = values.join(', ');
      });

      setState(() {
        _isLoading = false;
        _statusCode = response.statusCode;
        _statusText = response.reasonPhrase;
        _responseTimeMs = stopwatch.elapsedMilliseconds;
        _responseSizeBytes = responseBytes.length;
        _responseBody = formattedBody;
        _responseHeaders = headerMap;
        _addToHistory(uri.toString(), _selectedMethod, response.statusCode);
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _isLoading = false;
        _errorMessage = 'Request Failed: ${e.toString()}';
      });
    } finally {
      client?.close();
    }
  }

  void _addToHistory(String url, String method, int code) {
    setState(() {
      _history.insert(
        0,
        HistoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          url: url,
          method: method,
          statusCode: code,
          timestamp: DateTime.now(),
        ),
      );
      if (_history.length > 25) {
        _history.removeLast();
      }
    });
  }

  String _generateCurlCommand() {
    final sb = StringBuffer();
    sb.write('curl -X $_selectedMethod "${_urlController.text.trim()}"');

    for (var h in _headers) {
      if (h.enabled && h.key.isNotEmpty) {
        sb.write(' \\\n  -H "${h.key}: ${h.value}"');
      }
    }

    if (_authType == 'Bearer' && _bearerTokenController.text.isNotEmpty) {
      sb.write(' \\\n  -H "Authorization: Bearer ${_bearerTokenController.text.trim()}"');
    }

    if (['POST', 'PUT', 'PATCH'].contains(_selectedMethod) && _bodyController.text.isNotEmpty) {
      final cleanBody = _bodyController.text.replaceAll('"', '\\"').replaceAll('\n', ' ');
      sb.write(' \\\n  -d "$cleanBody"');
    }

    return sb.toString();
  }

  void _saveCurrentRequestDialog() {
    final nameCtrl = TextEditingController(text: 'New Endpoint');
    final catCtrl = TextEditingController(text: 'General');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save Request to Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Request Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: catCtrl,
              decoration: const InputDecoration(
                labelText: 'Category / Group',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                setState(() {
                  _savedRequests.add(
                    SavedRequest(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      url: _urlController.text.trim(),
                      method: _selectedMethod,
                      category: catCtrl.text.trim().isEmpty ? 'General' : catCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to collection!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Developer Utility Functions
  void _prettifyJson() {
    try {
      final parsed = json.decode(_jsonInputController.text);
      setState(() {
        _jsonOutput = const JsonEncoder.withIndent('  ').convert(parsed);
      });
    } catch (e) {
      setState(() {
        _jsonOutput = 'JSON Parse Error: ${e.toString()}';
      });
    }
  }

  void _minifyJson() {
    try {
      final parsed = json.decode(_jsonInputController.text);
      setState(() {
        _jsonOutput = json.encode(parsed);
      });
    } catch (e) {
      setState(() {
        _jsonOutput = 'JSON Parse Error: ${e.toString()}';
      });
    }
  }

  void _processBase64() {
    final input = _b64InputController.text;
    try {
      if (_b64EncodeMode) {
        final bytes = utf8.encode(input);
        setState(() {
          _b64Output = base64.encode(bytes);
        });
      } else {
        final decodedBytes = base64.decode(input.trim());
        setState(() {
          _b64Output = utf8.decode(decodedBytes);
        });
      }
    } catch (e) {
      setState(() {
        _b64Output = 'Base64 Processing Error: ${e.toString()}';
      });
    }
  }

  void _processUrlEncode() {
    final input = _urlEncodeInputController.text;
    try {
      setState(() {
        if (_urlEncodeMode) {
          _urlEncodeOutput = Uri.encodeComponent(input);
        } else {
          _urlEncodeOutput = Uri.decodeComponent(input);
        }
      });
    } catch (e) {
      setState(() {
        _urlEncodeOutput = 'URL Processing Error: ${e.toString()}';
      });
    }
  }

  void _processJwt() {
    final token = _jwtInputController.text.trim();
    final parts = token.split('.');
    if (parts.length < 2) {
      setState(() {
        _jwtHeaderOutput = 'Invalid JWT Token Format';
        _jwtPayloadOutput = 'Expected 3 dot-separated parts (Header.Payload.Signature)';
      });
      return;
    }

    try {
      String decodePart(String base64Part) {
        String normalized = base64Part.replaceAll('-', '+').replaceAll('_', '/');
        while (normalized.length % 4 != 0) {
          normalized += '=';
        }
        final bytes = base64.decode(normalized);
        final decodedString = utf8.decode(bytes);
        final parsedJson = json.decode(decodedString);
        return const JsonEncoder.withIndent('  ').convert(parsedJson);
      }

      setState(() {
        _jwtHeaderOutput = decodePart(parts[0]);
        _jwtPayloadOutput = decodePart(parts[1]);
      });
    } catch (e) {
      setState(() {
        _jwtHeaderOutput = 'Decode Error';
        _jwtPayloadOutput = 'Failed to decode JWT payload: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.api, color: Colors.indigoAccent),
            const SizedBox(width: 10),
            const Text(
              'APIFlux Workbench',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              const Text('Mock Mode', style: TextStyle(fontSize: 12)),
              Switch(
                value: _useMockEngine,
                activeColor: Colors.amber,
                onChanged: (val) {
                  setState(() {
                    _useMockEngine = val;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        val ? 'Mock Engine active: Offline endpoints enabled' : 'Live Network Mode active',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF181826),
        onTap: (idx) => setState(() => _currentBottomNavIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.send_rounded),
            label: 'Workbench',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: 'Collections & Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle),
            label: 'Dev Studio',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentBottomNavIndex) {
      case 0:
        return _buildRequestWorkbenchTab();
      case 1:
        return _buildCollectionsAndHistoryTab();
      case 2:
        return _buildDevStudioTab();
      default:
        return _buildRequestWorkbenchTab();
    }
  }

  Widget _buildRequestWorkbenchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // URL & Method Input Bar
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: _selectedMethod,
                        dropdownColor: const Color(0xFF252538),
                        underline: const SizedBox(),
                        style: TextStyle(
                          color: _getMethodColor(_selectedMethod),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        items: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD']
                            .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    m,
                                    style: TextStyle(
                                      color: _getMethodColor(m),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedMethod = val);
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Enter API Endpoint URL',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Preset Chips Widget using Wrap
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 6.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Quick Presets:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ActionChip(
                        label: const Text('Post JSON', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF2A2A3D),
                        onPressed: () {
                          setState(() {
                            _selectedMethod = 'GET';
                            _urlController.text = 'https://jsonplaceholder.typicode.com/posts/1';
                          });
                        },
                      ),
                      ActionChip(
                        label: const Text('HttpBin GET', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF2A2A3D),
                        onPressed: () {
                          setState(() {
                            _selectedMethod = 'GET';
                            _urlController.text = 'https://httpbin.org/get';
                          });
                        },
                      ),
                      ActionChip(
                        label: const Text('ReqRes Users', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF2A2A3D),
                        onPressed: () {
                          setState(() {
                            _selectedMethod = 'GET';
                            _urlController.text = 'https://reqres.in/api/users?page=2';
                          });
                        },
                      ),
                      ActionChip(
                        label: const Text('Mock Local Endpoint', style: TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFF382A1A),
                        onPressed: () {
                          setState(() {
                            _useMockEngine = true;
                            _selectedMethod = 'POST';
                            _urlController.text = 'mock://api/v1/user/checkout';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _executeRequest,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(_isLoading ? 'Executing...' : 'SEND REQUEST'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.bookmark_add_outlined),
                        tooltip: 'Save to Collection',
                        onPressed: _saveCurrentRequestDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Request Parameters & Headers Tabbed Interface
          DefaultTabController(
            length: 4,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.indigoAccent,
                    tabs: [
                      Tab(text: 'Params'),
                      Tab(text: 'Headers'),
                      Tab(text: 'Body'),
                      Tab(text: 'Auth'),
                    ],
                  ),
                  SizedBox(
                    height: 220,
                    child: TabBarView(
                      children: [
                        _buildParamsEditor(),
                        _buildHeadersEditor(),
                        _buildBodyEditor(),
                        _buildAuthEditor(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Response Inspector Area
          if (_errorMessage.isNotEmpty)
            Card(
              color: const Color(0xFF3B1E1E),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_statusCode != null) ...[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Bar Header
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 8.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(_statusCode).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _getStatusColor(_statusCode)),
                          ),
                          child: Text(
                            '$_statusCode $_statusText',
                            style: TextStyle(
                              color: _getStatusColor(_statusCode),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Chip(
                          avatar: const Icon(Icons.timer, size: 14, color: Colors.indigoAccent),
                          label: Text('${_responseTimeMs}ms', style: const TextStyle(fontSize: 11)),
                          backgroundColor: const Color(0xFF12121D),
                        ),
                        Chip(
                          avatar: const Icon(Icons.data_usage, size: 14, color: Colors.tealAccent),
                          label: Text('${_responseSizeBytes} B', style: const TextStyle(fontSize: 11)),
                          backgroundColor: const Color(0xFF12121D),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          tooltip: 'Copy Response Body',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _responseBody));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Response copied to clipboard!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.code, size: 18),
                          tooltip: 'Copy cURL Command',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _generateCurlCommand()));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('cURL command copied to clipboard!')),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(),

                    // Response Tabs
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const TabBar(
                            indicatorColor: Colors.indigoAccent,
                            tabs: [
                              Tab(text: 'Response Body'),
                              Tab(text: 'Headers'),
                              Tab(text: 'cURL Command'),
                            ],
                          ),
                          SizedBox(
                            height: 260,
                            child: TabBarView(
                              children: [
                                // Tab 1: Body
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF12121D),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SelectableText(
                                      _responseBody.isEmpty ? 'No content returned' : _responseBody,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        color: Colors.lightGreenAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                // Tab 2: Response Headers
                                ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: _responseHeaders.length,
                                  itemBuilder: (ctx, idx) {
                                    final key = _responseHeaders.keys.elementAt(idx);
                                    final val = _responseHeaders[key];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$key: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.indigoAccent,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              val ?? '',
                                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                // Tab 3: Generated cURL
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF12121D),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SelectableText(
                                      _generateCurlCommand(),
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        color: Colors.amberAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildParamsEditor() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _queryParams.length,
              itemBuilder: (ctx, idx) {
                final item = _queryParams[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.enabled,
                        onChanged: (val) {
                          setState(() => item.enabled = val ?? true);
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.key,
                          decoration: const InputDecoration(
                            hintText: 'Param Key',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => item.key = val,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.value,
                          decoration: const InputDecoration(
                            hintText: 'Value',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => item.value = val,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() => _queryParams.removeAt(idx));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Query Parameter'),
              onPressed: () {
                setState(() => _queryParams.add(KeyValuePair()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadersEditor() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _headers.length,
              itemBuilder: (ctx, idx) {
                final item = _headers[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.enabled,
                        onChanged: (val) {
                          setState(() => item.enabled = val ?? true);
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.key,
                          decoration: const InputDecoration(
                            hintText: 'Header Name',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => item.key = val,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.value,
                          decoration: const InputDecoration(
                            hintText: 'Header Value',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) => item.value = val,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() => _headers.removeAt(idx));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Request Header'),
              onPressed: () {
                setState(() => _headers.add(KeyValuePair()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyEditor() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Request Payload (JSON / Plain Text):', style: TextStyle(fontSize: 12)),
              TextButton(
                onPressed: () {
                  setState(() {
                    _bodyController.text = '{\n  "title": "Sample API Post",\n  "body": "Testing via APIFlux Workbench",\n  "userId": 1\n}';
                  });
                },
                child: const Text('Insert Template', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: _bodyController,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Enter JSON payload here...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthEditor() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Auth Method: ', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _authType,
                dropdownColor: const Color(0xFF252538),
                items: ['None', 'Bearer', 'Basic'].map((a) {
                  return DropdownMenuItem(value: a, child: Text(a));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _authType = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_authType == 'Bearer') ...[
            TextField(
              controller: _bearerTokenController,
              decoration: const InputDecoration(
                labelText: 'Bearer Token',
                hintText: 'e.g. eyJhbGciOi...',
                border: OutlineInputBorder(),
              ),
            ),
          ] else if (_authType == 'Basic') ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _basicUserController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _basicPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text(
              'No authorization headers will be injected automatically.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCollectionsAndHistoryTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Colors.indigoAccent,
            tabs: [
              Tab(icon: Icon(Icons.bookmark), text: 'Saved Collections'),
              Tab(icon: Icon(Icons.history), text: 'Request History'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Saved Collections
                _savedRequests.isEmpty
                    ? const Center(child: Text('No saved requests yet.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _savedRequests.length,
                        itemBuilder: (ctx, idx) {
                          final item = _savedRequests[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getMethodColor(item.method).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.method,
                                  style: TextStyle(
                                    color: _getMethodColor(item.method),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${item.category} • ${item.url}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow_rounded, color: Colors.greenAccent),
                                tooltip: 'Load & Run',
                                onPressed: () {
                                  setState(() {
                                    _selectedMethod = item.method;
                                    _urlController.text = item.url;
                                    _currentBottomNavIndex = 0;
                                  });
                                  _executeRequest();
                                },
                              ),
                            ),
                          );
                        },
                      ),

                // Request History
                _history.isEmpty
                    ? const Center(child: Text('History log is empty.'))
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_history.length} items logged', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                TextButton(
                                  onPressed: () {
                                    setState(() => _history.clear());
                                  },
                                  child: const Text('Clear History', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: _history.length,
                              itemBuilder: (ctx, idx) {
                                final item = _history[idx];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getMethodColor(item.method).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.method,
                                        style: TextStyle(
                                          color: _getMethodColor(item.method),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      item.url,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    subtitle: Text(
                                      '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}:${item.timestamp.second.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(item.statusCode).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${item.statusCode}',
                                        style: TextStyle(
                                          color: _getStatusColor(item.statusCode),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedMethod = item.method;
                                        _urlController.text = item.url;
                                        _currentBottomNavIndex = 0;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevStudioTab() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.indigoAccent,
            tabs: [
              Tab(text: 'JSON Formatter'),
              Tab(text: 'Base64 Tool'),
              Tab(text: 'URL Encoder'),
              Tab(text: 'JWT Decoder'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJsonTool(),
            _buildBase64Tool(),
            _buildUrlEncoderTool(),
            _buildJwtTool(),
          ],
        ),
      ),
    );
  }

  Widget _buildJsonTool() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Input JSON Text:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: _jsonInputController,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Paste unformatted JSON...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _prettifyJson,
                  icon: const Icon(Icons.auto_fix_high, size: 16),
                  label: const Text('Beautify'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _minifyJson,
                  icon: const Icon(Icons.compress, size: 16),
                  label: const Text('Minify'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Formatted Result:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF12121D),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: SelectableText(
                _jsonOutput,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.greenAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBase64Tool() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('Mode: ', style: TextStyle(fontWeight: FontWeight.bold)),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Encode')),
                  ButtonSegment(value: false, label: Text('Decode')),
                ],
                selected: {_b64EncodeMode},
                onSelectionChanged: (set) {
                  setState(() {
                    _b64EncodeMode = set.first;
                  });
                  _processBase64();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _b64InputController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Input Text',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _processBase64(),
          ),
          const SizedBox(height: 12),
          const Text('Base64 Output:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF12121D),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: SelectableText(
                _b64Output,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.amberAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlEncoderTool() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('Mode: ', style: TextStyle(fontWeight: FontWeight.bold)),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Encode')),
                  ButtonSegment(value: false, label: Text('Decode')),
                ],
                selected: {_urlEncodeMode},
                onSelectionChanged: (set) {
                  setState(() {
                    _urlEncodeMode = set.first;
                  });
                  _processUrlEncode();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _urlEncodeInputController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Target String',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _processUrlEncode(),
          ),
          const SizedBox(height: 12),
          const Text('Processed Result:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF12121D),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: SelectableText(
                _urlEncodeOutput,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.cyanAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJwtTool() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _jwtInputController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'JWT Token String (Header.Payload.Signature)',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _processJwt(),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Decoded Header:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF12121D),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              _jwtHeaderOutput,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.pinkAccent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Decoded Payload:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF12121D),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              _jwtPayloadOutput,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}