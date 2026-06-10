const app = require('./app');
const os = require('os');

const PORT = 3000;

// Obtener la IP local del servidor
function getLocalIP() {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      // Buscar IPv4 que no sea loopback
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return 'localhost';
}

const localIP = getLocalIP();

app.listen(PORT, '0.0.0.0', () => {
  console.log(`====================================================`);
  console.log(`  SecureByte Backend Inicializado Correctamente`);
  console.log(`  Servidor corriendo en: http://${localIP}:${PORT}`);
  console.log(`  Accesible desde cualquier interfaz de red`);
  console.log(`====================================================`);
});