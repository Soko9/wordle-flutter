import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/constants/theme.dart";
import "package:wordle/controllers/controller.dart";
import "package:wordle/controllers/theme_controller.dart";
import "package:wordle/data/prefs.dart";
import "package:wordle/screens/home.dart";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Controller()),
        ChangeNotifierProvider.value(value: ThemeController()),
      ],
      child: FutureBuilder<bool>(
          initialData: false,
          future: Prefs.getTheme(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Provider.of<ThemeController>(context, listen: false)
                    .setTheme(theme: snapshot.data as bool);
              });
            }
            return FutureBuilder<bool>(
                initialData: false,
                future: Prefs.getMode(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Provider.of<Controller>(context, listen: false)
                          .changeMode(mode: snapshot.data as bool);
                    });
                  }
                  return Consumer<ThemeController>(
                    builder: (_, value, __) => MaterialApp(
                      title: "Wordle Game",
                      debugShowCheckedModeBanner: false,
                      theme: value.isDark
                          ? AppTheme.darkTheme
                          : AppTheme.lightTheme,
                      home: const Home(),
                    ),
                  );
                });
          }),
    );
  }
}
