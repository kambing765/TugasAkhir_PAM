import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

class CryptoHelper {
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // Panjangnya harus 32
  static final _iv = encrypt.IV.fromLength(16);

  static String encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedData), iv: _iv);
    return decrypted;
  }
}
