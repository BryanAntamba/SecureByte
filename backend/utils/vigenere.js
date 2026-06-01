/**
 * Cifrado Vigenère manual (sin librerías).
 * Fórmula: C = (P + K) mod 26
 * Solo opera sobre letras A-Z mayúsculas; espacios y símbolos se mantienen.
 */
function vigenereEncrypt(plainText, key) {
    let cipherText = '';
    plainText = plainText.toUpperCase();
    key = key.toUpperCase();
    let keyIndex = 0;

    for (let i = 0; i < plainText.length; i++) {
        const charCode = plainText.charCodeAt(i);
        if (charCode >= 65 && charCode <= 90) {
            const textPosition = charCode - 65;
            const keyPosition = key.charCodeAt(keyIndex % key.length) - 65;
            const encryptedPosition = (textPosition + keyPosition) % 26;
            cipherText += String.fromCharCode(encryptedPosition + 65);
            keyIndex++;
        } else {
            cipherText += plainText[i];
        }
    }
    return cipherText;
}

/**
 * Descifrado Vigenère manual.
 * Fórmula: D = (C - K + 26) mod 26
 */
function vigenereDecrypt(cipherText, key) {
    let plainText = '';
    cipherText = cipherText.toUpperCase();
    key = key.toUpperCase();
    let keyIndex = 0;

    for (let i = 0; i < cipherText.length; i++) {
        const charCode = cipherText.charCodeAt(i);
        if (charCode >= 65 && charCode <= 90) {
            const cipherPos = charCode - 65;
            const keyPos = key.charCodeAt(keyIndex % key.length) - 65;
            const decryptedPos = (cipherPos - keyPos + 26) % 26;
            plainText += String.fromCharCode(decryptedPos + 65);
            keyIndex++;
        } else {
            plainText += cipherText[i];
        }
    }
    return plainText;
}

module.exports = { vigenereEncrypt, vigenereDecrypt };
