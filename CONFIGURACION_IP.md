# Configuración de IP para SecureByte

## 🔧 Cambios realizados

El backend ahora escucha en **todas las interfaces de red** (`0.0.0.0:3000`), lo que permite conexiones desde diferentes dispositivos sin cambios en el código.

## 📱 Configurar el Frontend según tu dispositivo

Edita el archivo `frontend/lib/core/constants.dart` y cambia `kBaseUrl`:

### 1️⃣ **Emulador Android en la misma PC**
```dart
const String kBaseUrl = 'http://10.0.2.2:3000';
```
✅ Ya está configurado así por defecto

### 2️⃣ **Dispositivo físico Android en la red local**
Primero, obtén la IP del PC:
```bash
# En Windows (en terminal de PowerShell)
ipconfig
# Busca "Dirección IPv4" (ej: 192.168.1.100)
```

Luego, edita `constants.dart`:
```dart
const String kBaseUrl = 'http://192.168.1.100:3000';  // Cambia 192.168.1.100 por tu IP
```

### 3️⃣ **iOS Simulator en la misma PC**
```dart
const String kBaseUrl = 'http://localhost:3000';
```

### 4️⃣ **iOS Dispositivo físico en la red local**
Igual que dispositivo Android físico:
```dart
const String kBaseUrl = 'http://192.168.1.100:3000';  // Tu IP del PC
```

## ⚡ Cómo iniciar

### Backend
```bash
cd backend
npm install      # Solo la primera vez
npm start        # o: node index.js
```
Verás en consola la IP del PC automáticamente: `Servidor corriendo en: http://192.168.x.x:3000`

### Frontend
```bash
cd frontend
flutter pub get  # Solo la primera vez
flutter run      # Elige tu dispositivo
```

## 🔍 Troubleshooting

### Conectar a través de la red local
1. Ambos dispositivos (PC y móvil) deben estar en la **misma red WiFi**
2. La firewall del PC podría bloquear el puerto 3000:
   ```bash
   # En Windows (Run as Admin):
   netsh advfirewall firewall add rule name="SecureByte Backend" dir=in action=allow protocol=tcp localport=3000
   ```

### Ver la IP actual del PC en tiempo real
Abre otra terminal:
```bash
# Windows
ipconfig

# Linux/Mac
ifconfig
```

Busca la sección del adaptador WiFi/Ethernet actual.
