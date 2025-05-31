import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserRepository {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  final SharedPreferences _prefs;

  UserRepository(this._prefs) {
    _initializeDefaultUsers();
  }

  Future<void> _initializeDefaultUsers() async {
    final defaultUsers = [
      const User(
        id: 'abderrahmane',
        username: 'Abderrahmane',
        email: 'abderrahmane@example.com',
      ),
      const User(
        id: 'prof-loubna',
        username: 'Prof-loubna',
        email: 'prof-loubna@example.com',
      ),
    ];

    // Only initialize if no users exist
    if (!_prefs.containsKey(_usersKey)) {
      await saveUsers(defaultUsers);
    }
  }

  Future<void> saveUsers(List<User> users) async {
    final usersJson = users.map((user) => user.toJson()).toList();
    await _prefs.setString(_usersKey, jsonEncode(usersJson));
  }

  List<User> getUsers() {
    final usersJson = _prefs.getString(_usersKey);
    if (usersJson == null) return [];

    final List<dynamic> decoded = jsonDecode(usersJson);
    return decoded.map((json) => User.fromJson(json)).toList();
  }

  Future<void> saveCurrentUser(User user) async {
    await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  User? getCurrentUser() {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson == null) return null;

    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> clearCurrentUser() async {
    await _prefs.remove(_currentUserKey);
  }

  User? getUserById(String userId) {
    return getUsers().firstWhere(
      (user) => user.id == userId,
      orElse: () => const User(
        id: 'unknown',
        username: 'Unknown User',
        email: 'unknown@example.com',
      ),
    );
  }
} 