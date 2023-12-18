import "package:flutter/material.dart";

class ThemeController extends ChangeNotifier {
  bool isDark = false;

  setTheme({required bool theme}) {
    isDark = theme;
    // print("isDark: $isDark");
    notifyListeners();
  }

  // toggleTheme() {
  //   isDark = !isDark;
  //   notifyListeners();
  // }
}
