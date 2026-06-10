const express = require('express');
const cors = require('cors');
const mensajesRouter = require('./routes/mensajes.routes');

const app = express();

// Configurar CORS para aceptar solicitudes desde cualquier origen
const corsOptions = {
  origin: '*', // Acepta solicitudes desde cualquier origen
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: false,
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(express.json());

app.use('/api', mensajesRouter);

module.exports = app;
