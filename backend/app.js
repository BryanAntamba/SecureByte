const express = require('express');
const cors = require('cors');
const mensajesRouter = require('./routes/mensajes.routes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api', mensajesRouter);

module.exports = app;
