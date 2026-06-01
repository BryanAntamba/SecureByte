import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../widgets/encrypt_dialog.dart';
import '../widgets/decrypt_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _capturedMessages = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedMessageIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchMensajes();
  }

  Future<void> _fetchMensajes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final uri = Uri.parse('$kBaseUrl/api/mensajes');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        setState(() {
          _capturedMessages = data
              .map<String>((m) => m['plaintext'] as String)
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error del servidor: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'No se pudo conectar al servidor.\nVerifica que el backend esté corriendo.';
        _isLoading = false;
      });
    }
  }

  String get _selectedMessage => _selectedMessageIndex >= 0
      ? _capturedMessages[_selectedMessageIndex]
      : '';

  bool get _hasSelectedMessage => _selectedMessageIndex >= 0;

  ButtonStyle get _actionButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.indigo,
    side: const BorderSide(color: Colors.indigo),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/ic_launcher.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Secure',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: 'Byte',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mensajes capturados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  if (!_isLoading)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.indigo),
                      tooltip: 'Recargar mensajes',
                      onPressed: _fetchMensajes,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona un mensaje que deseas realizar el proceso',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.indigo),
                )
              else if (_errorMessage != null)
                Column(
                  children: [
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _fetchMensajes,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.indigo,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: List.generate(_capturedMessages.length, (index) {
                    final bool selected = index == _selectedMessageIndex;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: selected
                          ? Colors.indigo.shade50
                          : Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: selected ? Colors.indigo : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: selected,
                        onChanged: (value) {
                          setState(() {
                            _selectedMessageIndex = value == true ? index : -1;
                          });
                        },
                        title: Text(
                          'Mensaje ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.indigo.shade900
                                : Colors.black87,
                          ),
                        ),
                        subtitle: Opacity(
                          opacity: 0.8,
                          child: Text(
                            _capturedMessages[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        secondary: Icon(
                          selected ? Icons.check_circle : Icons.circle_outlined,
                          color: selected ? Colors.indigo : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),
              const SizedBox(height: 24),
              const Text(
                'Operación secreta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona la operación que deseas realizar con el mensaje que seleccionaste',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _hasSelectedMessage
                    ? () => showEncryptDialog(context, _selectedMessage)
                    : null,
                style: _actionButtonStyle,
                child: const Text('Encriptar', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _hasSelectedMessage
                    ? () => showDecryptDialog(context, _selectedMessage)
                    : null,
                style: _actionButtonStyle,
                child: const Text(
                  'Desencriptar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
