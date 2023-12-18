import "package:charts_flutter_new/flutter.dart" as charts;
import "package:wordle/data/prefs.dart";

class Chart {
  int rowScore;
  bool isRecent;

  Chart({
    required this.rowScore,
    required this.isRecent,
  });

  static Future<List<charts.Series<Chart, String>>> getSeries() async {
    List<Chart> data = [];
    List<int> scores = await Prefs.getChartStats();
    if (scores.isNotEmpty) {
      for (int s in scores) {
        data.add(Chart(rowScore: s, isRecent: false));
      }
    }
    int? row = await Prefs.getChartRow();
    if (row != null) {
      data[row - 1].isRecent = true;
    }

    return [
      charts.Series(
        id: "Stats",
        data: data,
        domainFn: (model, index) => "R-${(index! + 1)}",
        measureFn: (model, index) => model.rowScore,
        labelAccessorFn: (model, index) => model.rowScore.toString(),
        colorFn: (model, index) => model.isRecent
            ? charts.MaterialPalette.blue.shadeDefault
            : charts.MaterialPalette.gray.shadeDefault,
      ),
    ];
  }
}
