import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// URL base del backend - Se selecciona automáticamente según la plataforma
// 🔧 Para dispositivo físico: Cambia la IP en la línea correspondiente (ej: 192.168.1.12)
String get kBaseUrl {
  if (kIsWeb) {
    // Navegador web
    return 'http://localhost:3000';
  } else if (Platform.isAndroid) {
    // Android Emulator usa 10.0.2.2 para localhost de la PC
    // Para dispositivo físico, descomentar la línea siguiente:
    return 'http://10.0.2.2:3000';
    // return 'http://192.168.1.12:3000'; // Descomenta para dispositivo físico (tu IP: 192.168.1.12)
  } else if (Platform.isIOS) {
    // iOS Simulator puede usar localhost
    // Para dispositivo físico, descomentar la línea siguiente:
    return 'http://localhost:3000';
    // return 'http://192.168.1.12:3000'; // Descomenta para dispositivo físico (tu IP: 192.168.1.12)
  } else {
    return 'http://localhost:3000';
  }
}

// Clave Vigenère compartida con el backend.
const String kClaveVigenere = 'ITQ';
