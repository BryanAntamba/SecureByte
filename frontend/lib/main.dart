// Importa las utilidades de codificación y decodificación de texto.
import 'dart:convert';

// Importa los componentes visuales y de diseño de Flutter.
import 'package:flutter/material.dart';
// Importa servicios de plataforma, como el portapapeles.
import 'package:flutter/services.dart';

// Función principal que inicia la aplicación Flutter.
void main() {
  // Ejecuta la aplicación usando el widget raíz MyApp.
  runApp(const MyApp());
}

// Widget raíz inmutable de la aplicación.
class MyApp extends StatelessWidget {
  // Constructor con la clave del widget para optimizaciones de Flutter.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Construye el widget MaterialApp con tema y pantalla inicial.
    return MaterialApp(
      // Oculta la etiqueta de depuración en modo debug.
      debugShowCheckedModeBanner: false,
      // Título de la aplicación, usado por el sistema operativo.
      title: 'SecureByte',
      // Define el tema visual de la aplicación.
      theme: ThemeData(
        // Crea un esquema de color basado en un color semilla.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        // Activa Material Design 3.
        useMaterial3: true,
      ),
      // Establece la pantalla principal al iniciar.
      home: const SplashScreen(),
    );
  }
}

// Widget con estado para la pantalla de bienvenida.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Estado asociado a SplashScreen, con animaciones.
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Controlador de animación usado para las transiciones.
  late final AnimationController _controller;
  // Animación adicional para el texto.
  late final Animation<double> _textAnimation;

  // Texto que se animará en la pantalla de carga.
  static const String _titleText = 'SecureByte';

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de animación con duración.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward();

    // Define la animación del texto con un intervalo específico.
    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    // Escucha el estado de la animación para navegar a HomeScreen al completar.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    // Libera recursos del controlador de animación.
    _controller.dispose();
    super.dispose();
  }

  // Construye una onda animada para el fondo del splash.
  Widget _buildWave(double delay) {
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay, delay + 0.45, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        return Opacity(
          opacity: (1.0 - progress).clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.6 + progress * 1.4,
            child: child,
          ),
        );
      },
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha((0.9 * 255).toInt()), width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.08 * 255).toInt()),
              blurRadius: 18,
              spreadRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  // Calcula el texto que se muestra según el progreso de la animación.
  String get _animatedTitle {
    final int count = (_textAnimation.value * _titleText.length).clamp(0, _titleText.length).toInt();
    return _titleText.substring(0, count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildWave(0.0),
                    _buildWave(0.15),
                    _buildWave(0.3),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.12 * 255).toInt()),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset('assets/ic_launcher.png', width: 96, height: 96),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  _animatedTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Opacity(
                  opacity: _textAnimation.value,
                  child: const Text(
                    'Cargando seguridad...',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Pantalla principal donde se muestran mensajes y operaciones.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de mensajes capturados que el usuario puede seleccionar.
  final List<String> _capturedMessages = [
    'Reunión a las 7pm',
    'Clave secreta 123',
    'Envía el paquete hoy',
  ];
  // Índice del mensaje seleccionado, -1 significa ninguno.
  int _selectedMessageIndex = -1;

  // Obtiene el mensaje seleccionado si hay alguno.
  String get _selectedMessage =>
      _selectedMessageIndex >= 0 ? _capturedMessages[_selectedMessageIndex] : '';

  // Indica si hay un mensaje seleccionado.
  bool get _hasSelectedMessage => _selectedMessageIndex >= 0;

  // Muestra el diálogo para encriptar un mensaje.
  void _showEncryptDialog() {
    final TextEditingController controller = TextEditingController(text: _selectedMessage);
    String result = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                  onPressed: () {
                    setState(() {
                      result = base64Encode(utf8.encode(controller.text));
                    });
                  },
                  style: _actionButtonStyle,
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
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
                  result.isEmpty ? 'Aquí aparecerá el texto encriptado' : result,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: result.isNotEmpty
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
        });
      },
    );
  }

  // Muestra el diálogo para desencriptar un mensaje en Base64.
  void _showDecryptDialog() {
    final TextEditingController controller = TextEditingController();
    String result = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                    hintText: 'Texto en Base64',
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final data = await Clipboard.getData(Clipboard.kTextPlain);
                      if (data?.text?.isNotEmpty == true) {
                        controller.text = data!.text!;
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No hay texto en el portapapeles')),
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
                  onPressed: () {
                    setState(() {
                      try {
                        result = utf8.decode(base64Decode(controller.text));
                      } catch (_) {
                        result = 'Texto no válido. Usa Base64 generado desde Encriptar.';
                      }
                    });
                  },
                  style: _actionButtonStyle,
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
                  result.isEmpty ? 'Aquí aparecerá el mensaje desencriptado' : result,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // Estilo reutilizable para los botones de acción.
  ButtonStyle get _actionButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        side: const BorderSide(color: Colors.indigo),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                  Image.asset('assets/ic_launcher.png', width: 100, height: 100),
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
              const Text(
                'Mensajes capturados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona un mensaje que deseas realizar el proceso',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Column(
                children: List.generate(_capturedMessages.length, (index) {
                  final bool selected = index == _selectedMessageIndex;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: selected ? Colors.indigo.shade50 : Colors.grey.shade100,
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
                          color: selected ? Colors.indigo.shade900 : Colors.black87,
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
                onPressed: _hasSelectedMessage ? _showEncryptDialog : null,
                style: _actionButtonStyle,
                child: const Text('Encriptar', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _hasSelectedMessage ? _showDecryptDialog : null,
                style: _actionButtonStyle,
                child: const Text('Desencriptar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
