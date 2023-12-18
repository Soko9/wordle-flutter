import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/controllers/controller.dart";
import "package:wordle/screens/settings.dart";
import "package:wordle/widgets/grid.dart";
import "package:wordle/widgets/keyboard.dart";
import "package:wordle/widgets/stats_box.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Controller>(context, listen: false).setCorrectWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wordle"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const StatsBox(fromIcon: true),
              );
            },
            icon: const Icon(Icons.bar_chart_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Settings(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          Divider(
            thickness: 2.0,
            height: 2.0,
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Grid(),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Keyboard(min: 1, max: 10),
                    Keyboard(min: 11, max: 19),
                    Keyboard(min: 20, max: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
