import "package:shared_preferences/shared_preferences.dart";
import "package:wordle/models/stat.dart";

class Prefs {
  static const String _themePrefKey = "isDark";
  static const String _modePrefKey = "isHard";
  static const String _statsPrefKey = "stats";
  static const String _chartStatsPrefKey = "charStats";
  static const String _chartRowPrefKey = "charRow";

  static setTheme({required bool isDark}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePrefKey, isDark);
  }

  static Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themePrefKey) ?? false;
  }

  static setMode({required bool isHard}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_modePrefKey, isHard);
  }

  static Future<bool> getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_modePrefKey) ?? false;
  }

  static setStats({required Stats stats}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_statsPrefKey, stats.toList());
  }

  static Future<Stats?> getStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stats = prefs.getStringList(_statsPrefKey) ?? [];
    if (stats.isNotEmpty) {
      return Stats.fromList(stats);
    } else {
      return null;
    }
  }

  static resetStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsPrefKey);
  }

  static setChartStats({required List<int> dist}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _chartStatsPrefKey, dist.map((e) => e.toString()).toList());
  }

  static Future<List<int>> getChartStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = prefs.getStringList(_chartStatsPrefKey) ?? [];
    return result.map((e) => int.parse(e)).toList();
  }

  static resetChartStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chartStatsPrefKey);
  }

  static setChartRow({required int row}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_chartRowPrefKey, row);
  }

  static Future<int?> getChartRow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_chartRowPrefKey);
  }

  static resetChartRow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chartRowPrefKey);
  }
}
