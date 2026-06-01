const app = require('./app');

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(`  SecureByte Backend Inicializado Correctamente`);
  console.log(`  Servidor corriendo en: http://localhost:${PORT}`);
  console.log(`====================================================`);
});