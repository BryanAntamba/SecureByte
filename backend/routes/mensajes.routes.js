const { Router } = require('express');
const { getMensajes, encriptarMensaje, desencriptarMensaje } = require('../controllers/mensajes.controller');

const router = Router();

router.get('/mensajes', getMensajes);
router.post('/encriptar', encriptarMensaje);
router.post('/desencriptar', desencriptarMensaje);

module.exports = router;
