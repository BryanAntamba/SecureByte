import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

void showEncryptDialog(BuildContext context, String initialText) {
  final TextEditingController controller = TextEditingController(
    text: initialText,
  );
  String result = '';
  bool isEncrypting = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            title: Row(
              children: [
                const Expanded(child: Text('Encriptar mensaje')),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Mensaje a encriptar',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isEncrypting
                      ? null
                      : () async {
                          setState(() => isEncrypting = true);
                          try {
                            final uri = Uri.parse('$kBaseUrl/api/encriptar');
                            final response = await http
                                .post(
                                  uri,
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({
                                    'texto': controller.text.trim(),
                                  }),
                                )
                                .timeout(const Duration(seconds: 8));
                            if (response.statusCode == 200) {
                              final body = jsonDecode(response.body);
                              setState(() {
                                result = body['ciphertext'] as String;
                              });
                            } else {
                              setState(() {
                                result =
                                    'Error del servidor: ${response.statusCode}';
                              });
                            }
                          } catch (_) {
                            setState(() {
                              result = 'No se pudo conectar al servidor.';
                            });
                          } finally {
                            setState(() => isEncrypting = false);
                          }
                        },
                  style: _buttonStyle,
                  child: SizedBox(
                    width: double.infinity,
                    child: isEncrypting
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.indigo,
                              ),
                            ),
                          )
                        : const Text(
                            'Encriptar',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Resultado:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  result.isEmpty
                      ? 'Aquí aparecerá el texto encriptado'
                      : result,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed:
                      result.isNotEmpty &&
                          !result.startsWith('Error') &&
                          !result.startsWith('No se')
                      ? () async {
                          await Clipboard.setData(ClipboardData(text: result));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mensaje copiado')),
                            );
                          }
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.indigo,
                    side: const BorderSide(color: Colors.indigo),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Copiar mensaje',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: Colors.indigo,
  side: const BorderSide(color: Colors.indigo),
  padding: const EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
);
