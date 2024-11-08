
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> savePassword(String password) async {
    await _secureStorage.write(key: 'userPassword', value: password);
  }

  Future<String?> getPassword() async {
    return await _secureStorage.read(key: 'userPassword');
  }
}
