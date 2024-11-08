import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final StorageService _storageService = StorageService();

  Future<void> setPassword(String password) async {
    await _storageService.savePassword(password);
  }

  Future<String?> getPassword() async {
    return await _storageService.getPassword();
  }

  Future<bool> authenticate(String enteredPassword) async {
    final savedPassword = await getPassword();
    return savedPassword == enteredPassword;
  }
}

class StorageService {
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_password', password);
  }

  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_password');
  }
}
