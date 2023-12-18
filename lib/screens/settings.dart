import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/controllers/controller.dart";
import "package:wordle/controllers/theme_controller.dart";
import "package:wordle/data/prefs.dart";

import "../widgets/custom_switch.dart";

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    void changeTheme({required bool isDark}) {
      isDark = !isDark;
      Prefs.setTheme(isDark: isDark);
      Provider.of<ThemeController>(context, listen: false)
          .setTheme(theme: isDark);
    }

    void changeMode({required bool isHard}) {
      isHard = !isHard;
      Prefs.setMode(isHard: isHard);
      Provider.of<Controller>(context, listen: false).changeMode(mode: isHard);
    }

    void resetStats() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "Reset Statistics",
            style: TextStyle(
              fontSize: 22.0,
              letterSpacing: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Provider.of<Controller>(context, listen: false).clearTiles();
                Provider.of<Controller>(context, listen: false).clearKeyboard();
                await Prefs.resetStats();
                await Prefs.resetChartStats();
                await Prefs.resetChartRow();
                if (!context.mounted) return;
                Navigator.maybePop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Text(
                "Change Theme",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.25,
                ),
              ),
              trailing: Consumer<ThemeController>(
                builder: (_, value, __) {
                  bool isDark = value.isDark;

                  return InkWell(
                    onTap: () => changeTheme(isDark: isDark),
                    child: CustomSwitch(
                      isSwitched: isDark,
                      one: Icons.dark_mode_rounded,
                      two: Icons.light_mode_rounded,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Text(
                "Change Mode",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.25,
                ),
              ),
              trailing: Consumer<Controller>(
                builder: (_, value, __) {
                  bool isHard = value.isHardMode;

                  return InkWell(
                    onTap: () => changeMode(isHard: isHard),
                    child: CustomSwitch(
                      isSwitched: isHard,
                      one: Icons.h_mobiledata_rounded,
                      two: Icons.e_mobiledata_rounded,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: const Text(
                "Reset Stats",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.25,
                  color: Colors.red,
                ),
              ),
              onTap: resetStats,
            ),
          ],
        ),
      ),
    );
  }
}
