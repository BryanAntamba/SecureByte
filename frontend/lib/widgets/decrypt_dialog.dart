import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

void showDecryptDialog(BuildContext context, String initialText) {
  final TextEditingController controller = TextEditingController(
    text: initialText,
  );
  String result = '';

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
                const Expanded(child: Text('Desencriptar mensaje')),
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
                    hintText: 'Texto cifrado',
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final data = await Clipboard.getData(
                        Clipboard.kTextPlain,
                      );
                      if (data?.text?.isNotEmpty == true) {
                        controller.text = data!.text!;
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No hay texto en el portapapeles'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.paste),
                    label: const Text('Pegar mensaje'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.indigo,
                      side: const BorderSide(color: Colors.indigo),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final texto = controller.text.trim();
                    if (texto.isEmpty) {
                      setState(() => result = 'Ingresa un texto cifrado.');
                      return;
                    }
                    try {
                      final uri = Uri.parse('$kBaseUrl/api/desencriptar');
                      final response = await http
                          .post(
                            uri,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'texto': texto}),
                          )
                          .timeout(const Duration(seconds: 8));
                      if (response.statusCode == 200) {
                        final body = jsonDecode(response.body);
                        setState(() => result = body['plaintext'] as String);
                      } else {
                        setState(
                          () => result =
                              'Error del servidor: ${response.statusCode}',
                        );
                      }
                    } catch (_) {
                      setState(
                        () => result = 'No se pudo conectar al servidor.',
                      );
                    }
                  },
                  style: _buttonStyle,
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Desencriptar',
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
                      ? 'Aquí aparecerá el mensaje desencriptado'
                      : result,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
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
