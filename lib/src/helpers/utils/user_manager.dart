import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserManager with ChangeNotifier {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal() {
    loadUser();
  }

  String userName = 'Usuario Invitado';
  String? avatarPath;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('user_name') ?? 'Usuario Invitado';
    avatarPath = prefs.getString('user_avatar_path');
    notifyListeners();
  }

  Future<void> updateUser(String name, String? path) async {
    final prefs = await SharedPreferences.getInstance();
    userName = name;
    avatarPath = path;
    
    await prefs.setString('user_name', name);
    if (path != null) {
      await prefs.setString('user_avatar_path', path);
    } else {
      await prefs.remove('user_avatar_path');
    }
    
    notifyListeners();
  }
}
