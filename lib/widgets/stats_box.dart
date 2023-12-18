import "package:flutter/material.dart";
import "package:charts_flutter_new/flutter.dart" as charts;
import "package:provider/provider.dart";
import "package:wordle/constants/answer_enum.dart";
import "package:wordle/controllers/theme_controller.dart";
import "package:wordle/data/keybaord_keys.dart";
import "package:wordle/data/prefs.dart";
import "package:wordle/main.dart";
import "package:wordle/models/chart.dart";
import "package:wordle/models/stat.dart";

class StatsBox extends StatelessWidget {
  final bool fromIcon;

  const StatsBox({
    super.key,
    required this.fromIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        width: size.width * 0.8,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBar(context),
            FutureBuilder<Stats?>(
                future: Prefs.getStats(),
                builder: (context, snapshot) {
                  Stats stats = Stats.zero();
                  if (snapshot.hasData) {
                    stats = snapshot.data as Stats;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statField(
                          context: context,
                          number: stats.gamePlayed,
                          label: "GAMES",
                        ),
                        _statField(
                          context: context,
                          number: stats.winPercentage,
                          label: "WINS %",
                        ),
                        _statField(
                          context: context,
                          number: stats.currentStreak,
                          label: "STREAK",
                        ),
                        _statField(
                          context: context,
                          number: stats.maxStreak,
                          label: "MAX\nSTREAK",
                        ),
                      ],
                    ),
                  );
                }),
            _graph(),
            ElevatedButton(
              onPressed: () {
                keyboardKeys.updateAll(
                  (key, value) => value = Answer.notAnswered,
                );
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainApp(),
                    ),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 12.0,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  )),
              child: const Text(
                "REPLAY",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _graph() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: FutureBuilder<List<charts.Series<Chart, String>>>(
                future: Chart.getSeries(),
                builder: (context, snapshot) {
                  List<charts.Series<Chart, String>> series;
                  if (snapshot.hasData) {
                    series =
                        snapshot.data as List<charts.Series<Chart, String>>;
                    return Consumer<ThemeController>(
                      builder: (_, value, __) => charts.BarChart(
                        series,
                        vertical: false,
                        barRendererDecorator: charts.BarLabelDecorator(
                          labelAnchor: charts.BarLabelAnchor.end,
                          insideLabelStyleSpec: const charts.TextStyleSpec(
                            fontWeight: "bold",
                            color: charts.Color.white,
                            fontSize: 12,
                            fontFamily: "Antic",
                          ),
                          outsideLabelStyleSpec: charts.TextStyleSpec(
                            fontWeight: "bold",
                            color: value.isDark
                                ? charts.Color.white
                                : charts.Color.black,
                            fontSize: 12,
                            fontFamily: "Antic",
                          ),
                        ),
                        primaryMeasureAxis: const charts.NumericAxisSpec(
                          renderSpec: charts.GridlineRendererSpec(
                            lineStyle: charts.LineStyleSpec(
                              color: charts.MaterialPalette.transparent,
                            ),
                            labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.transparent,
                            ),
                          ),
                        ),
                        domainAxis: charts.OrdinalAxisSpec(
                          renderSpec: charts.SmallTickRendererSpec(
                            lineStyle: const charts.LineStyleSpec(
                              color: charts.MaterialPalette.transparent,
                            ),
                            labelStyle: charts.TextStyleSpec(
                              fontWeight: "bold",
                              fontSize: 16,
                              fontFamily: "Antic",
                              color: value.isDark
                                  ? charts.Color.white
                                  : charts.Color.black,
                            ),
                          ),
                        ),
                        behaviors: [
                          charts.ChartTitle(
                            "GUESS DISTRIBUTION",
                            titleStyleSpec: charts.TextStyleSpec(
                              fontWeight: "bold",
                              fontSize: 22,
                              fontFamily: "Antic",
                              color: value.isDark
                                  ? charts.Color.white
                                  : charts.Color.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  "STATISTICS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 3.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          if (fromIcon)
            IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.clear_rounded),
            ),
        ],
      ),
    );
  }

  Widget _statField({
    required BuildContext context,
    required int number,
    required String label,
  }) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: size.width * 0.12,
        height: size.width * 0.12 * 1.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Text(
                number.toString().length > 1 ? number.toString() : "0$number",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  height: 0.8,
                  // fontFamily: "sans",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                alignment: Alignment.topCenter,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
