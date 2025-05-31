import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthRepository {
  final SharedPreferences prefs;
  static const String _userKey = 'current_user';
  static const String _isAuthenticatedKey = 'is_authenticated';

  AuthRepository(this.prefs);

  Future<bool> isAuthenticated() async {
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  Future<User?> getCurrentUser() async {
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(userJson);
  }

  Future<User> register(String username, String email, String password) async {
    // In a real app, this would make an API call
    await Future.delayed(const Duration(seconds: 1));
    
    final user = User(
      id: email, // Using email as ID for simplicity
      username: username,
      email: email,
    );

    await prefs.setString(_userKey, user.toJson());
    await prefs.setBool(_isAuthenticatedKey, true);
    
    return user;
  }

  Future<User> login(String email, String password) async {
    // In a real app, this would make an API call
    await Future.delayed(const Duration(seconds: 1));
    
    final user = User(
      id: email, // Using email as ID for simplicity
      username: email.split('@')[0], // Using part of email as username
      email: email,
    );

    await prefs.setString(_userKey, user.toJson());
    await prefs.setBool(_isAuthenticatedKey, true);
    
    return user;
  }

  Future<void> logout() async {
    await prefs.remove(_userKey);
    await prefs.setBool(_isAuthenticatedKey, false);
  }
} 