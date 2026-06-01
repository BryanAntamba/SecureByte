const mensajes = require('../data/mensajes');
const { vigenereEncrypt, vigenereDecrypt } = require('../utils/vigenere');

const CLAVE_SECRETA = 'ITQ';

function getMensajes(req, res) {
    const data = mensajes.map((texto, index) => ({
        id: index + 1,
        plaintext: texto,
    }));

    res.json({ success: true, data });
}

function encriptarMensaje(req, res) {
    const { texto } = req.body;

    if (!texto || typeof texto !== 'string' || texto.trim() === '') {
        return res.status(400).json({ success: false, error: 'El campo texto es requerido.' });
    }

    const ciphertext = vigenereEncrypt(texto.trim(), CLAVE_SECRETA);

    res.json({
        success: true,
        algo: 'Vigenere Manual (Modulo 26)',
        clave: CLAVE_SECRETA,
        ciphertext,
    });
}

function desencriptarMensaje(req, res) {
    const { texto } = req.body;

    if (!texto || typeof texto !== 'string' || texto.trim() === '') {
        return res.status(400).json({ success: false, error: 'El campo texto es requerido.' });
    }

    const plaintext = vigenereDecrypt(texto.trim(), CLAVE_SECRETA);

    res.json({
        success: true,
        algo: 'Vigenere Manual (Modulo 26)',
        plaintext,
    });
}

module.exports = { getMensajes, encriptarMensaje, desencriptarMensaje };
