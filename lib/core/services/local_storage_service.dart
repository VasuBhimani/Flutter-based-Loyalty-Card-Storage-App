import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LocalStorageService {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  final encrypt.Encrypter _encrypter;
  final encrypt.IV _iv;

  LocalStorageService({
    required this.sharedPreferences,
    required this.secureStorage,
  })  : _iv = encrypt.IV.fromLength(16),
        _encrypter =
            encrypt.Encrypter(encrypt.AES(encrypt.Key.fromSecureRandom(32)));

  // Secure storage methods
  Future<void> saveSecureData(String key, String value) async {
    final encrypted = _encrypter.encrypt(value, iv: _iv);
    await secureStorage.write(key: key, value: encrypted.base64);
  }

  Future<String?> getSecureData(String key) async {
    final encrypted = await secureStorage.read(key: key);
    if (encrypted == null) return null;
    final decrypted = _encrypter.decrypt64(encrypted, iv: _iv);
    return decrypted;
  }

  Future<void> deleteSecureData(String key) async {
    await secureStorage.delete(key: key);
  }

  // Non-secure storage methods
  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      await sharedPreferences.setStringList(key, value);
    }
  }

  dynamic getData(String key) {
    return sharedPreferences.get(key);
  }

  Future<void> deleteData(String key) async {
    await sharedPreferences.remove(key);
  }

  // Card-specific methods
  Future<void> saveCard(String cardId, Map<String, dynamic> cardData) async {
    final encryptedData = _encrypter.encrypt(json.encode(cardData), iv: _iv);
    await secureStorage.write(key: 'card_$cardId', value: encryptedData.base64);
  }

  Future<Map<String, dynamic>?> getCard(String cardId) async {
    final encrypted = await secureStorage.read(key: 'card_$cardId');
    if (encrypted == null) return null;
    final decrypted = _encrypter.decrypt64(encrypted, iv: _iv);
    return json.decode(decrypted) as Map<String, dynamic>;
  }

  Future<void> deleteCard(String cardId) async {
    await secureStorage.delete(key: 'card_$cardId');
  }

  Future<List<String>> getAllCardIds() async {
    final allData = await secureStorage.readAll();
    return allData.keys
        .where((key) => key.startsWith('card_'))
        .map((key) => key.replaceFirst('card_', ''))
        .toList();
  }
}
