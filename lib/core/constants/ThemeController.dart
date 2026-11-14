import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = "themeMode";
  late SharedPreferences _prefs;

  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
  }

  void _loadThemeMode() {
    String? theme = _prefs.getString(_themeKey);
    if (theme != null) {
      if (theme == "light") {
        themeMode.value = ThemeMode.light;
      } else if (theme == "dark") {
        themeMode.value = ThemeMode.dark;
      } else {
        themeMode.value = ThemeMode.system;
      }
    }
  }

  void setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    String themeString = mode == ThemeMode.light
        ? "light"
        : mode == ThemeMode.dark
            ? "dark"
            : "system";
    await _prefs.setString(_themeKey, themeString);
  }
}
