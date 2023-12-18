import "dart:math";

import "package:flutter/material.dart";
import "package:wordle/constants/answer_enum.dart";
import "package:wordle/data/keybaord_keys.dart";
import "package:wordle/data/prefs.dart";
import "package:wordle/data/words.dart";
import "package:wordle/models/stat.dart";
import "package:wordle/models/tile_model.dart";

import "../widgets/stats_box.dart";

class Controller extends ChangeNotifier {
  bool checkLine = false;
  int tileNumber = 0;
  int rowNumber = 0;
  List<TileModel> tiles = [];
  String correctWord = "";
  bool isBackOrEnter = false;
  bool gameWon = false;
  bool gameCompleted = false;
  bool isHardMode = false;

  setCorrectWord() {
    if (isHardMode) {
      int r = Random().nextInt(hardWords.length);
      correctWord = hardWords[r];
    } else {
      int r = Random().nextInt(easyWords.length);
      correctWord = easyWords[r];
    }
  }

  void changeMode({required bool mode}) {
    isHardMode = mode;
    // print("isHard: $isHardMode");
    clearAll();
    setCorrectWord();
  }

  void clearAll() {
    checkLine = false;
    tileNumber = 0;
    rowNumber = 0;
    correctWord = "";
    isBackOrEnter = false;
    gameWon = false;
    gameCompleted = false;
    clearTiles();
    clearKeyboard();
  }

  void clearTiles() {
    tiles.clear();
    notifyListeners();
  }

  void clearKeyboard() {
    keyboardKeys.updateAll((key, value) => value = Answer.notAnswered);
    notifyListeners();
  }

  void handlePress({required BuildContext context, required String letter}) {
    if (letter == "ENTER") {
      if (tileNumber == 5 * (rowNumber + 1)) {
        checkWord(context);
        isBackOrEnter = true;
      }
    } else if (letter == "BACK") {
      if (tileNumber > 5 * (rowNumber + 1) - 5) {
        tileNumber--;
        tiles.removeLast();
        isBackOrEnter = true;
      }
    } else {
      if (tileNumber < 5 * (rowNumber + 1)) {
        tileNumber++;
        tiles.add(TileModel(letter: letter, answer: Answer.notAnswered));
      }
      isBackOrEnter = false;
    }
    notifyListeners();
  }

  void checkWord(BuildContext context) {
    List<String> guessed = [];
    List<String> remaining = correctWord.characters.toList();
    String guessedWord = "";

    for (int i = rowNumber * 5; i < (rowNumber * 5) + 5; i++) {
      guessed.add(tiles[i].letter);
    }

    guessedWord = guessed.join();

    if (guessedWord == correctWord) {
      for (int i = rowNumber * 5; i < (rowNumber * 5) + 5; i++) {
        tiles[i].answer = Answer.correct;
        keyboardKeys.update(tiles[i].letter, (value) => Answer.correct);
      }
      gameWon = true;
      gameCompleted = true;
    } else {
      // Check Guessed
      for (int i = 0; i < 5; i++) {
        if (guessedWord[i] == correctWord[i]) {
          remaining.remove(guessedWord[i]);
          tiles[i + (rowNumber * 5)].answer = Answer.correct;
          keyboardKeys.update(guessedWord[i], (value) => Answer.correct);
        }
      }

      // Check Remaining
      for (int i = 0; i < remaining.length; i++) {
        for (int j = 0; j < 5; j++) {
          if (remaining[i] == tiles[j + (rowNumber * 5)].letter) {
            if (tiles[j + (rowNumber * 5)].answer != Answer.correct) {
              tiles[j + (rowNumber * 5)].answer = Answer.contains;
            }

            final resultKeys = keyboardKeys.entries.where(
                (element) => element.key == tiles[j + (rowNumber * 5)].letter);
            if (resultKeys.single.value != Answer.correct) {
              keyboardKeys.update(
                  resultKeys.single.key, (value) => Answer.contains);
            }
          }
        }
      }
    }

    for (int i = rowNumber * 5; i < (rowNumber * 5) + 5; i++) {
      if (tiles[i].answer == Answer.notAnswered) {
        tiles[i].answer = Answer.incorrect;
      }
      final resultKeys = keyboardKeys.entries
          .where((element) => element.key == tiles[i].letter);
      if (resultKeys.single.value == Answer.notAnswered) {
        keyboardKeys.update(tiles[i].letter, (value) => Answer.incorrect);
      }
    }

    rowNumber++;
    checkLine = true;

    if (rowNumber == 6) {
      gameCompleted = true;
    }

    if (gameCompleted) {
      calculateStats(won: gameWon);
      if (gameWon) {
        calculateCharStats(row: rowNumber);
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const StatsBox(fromIcon: false),
            );
          }
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text(
                  "Word was '$correctWord'",
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.25,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const StatsBox(fromIcon: false),
                      );
                    },
                    child: const Text("Cool"),
                  ),
                ],
              ),
            );
          }
        });
      }
    }

    notifyListeners();
  }

  void calculateStats({required bool won}) async {
    int gamePlayed = 0,
        gameWon = 0,
        winPercentage = 0,
        currentStreak = 0,
        maxStreak = 0;

    Stats? stats = await Prefs.getStats();

    if (stats != null) {
      gamePlayed = stats.gamePlayed;
      gameWon = stats.gameWon;
      winPercentage = stats.winPercentage;
      currentStreak = stats.currentStreak;
      maxStreak = stats.maxStreak;
    }

    gamePlayed++;

    if (won) {
      gameWon++;
      currentStreak++;
    } else {
      currentStreak = 0;
    }

    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }

    winPercentage = ((gameWon / gamePlayed) * 100).toInt();

    Prefs.setStats(
      stats: Stats(
        gamePlayed: gamePlayed,
        gameWon: gameWon,
        winPercentage: winPercentage,
        currentStreak: currentStreak,
        maxStreak: maxStreak,
      ),
    );
  }

  void calculateCharStats({required int row}) async {
    List<int> dist = List.generate(6, (index) => 0);
    List<int> result = await Prefs.getChartStats();
    if (result.isNotEmpty) {
      dist = result;
    }
    for (int i = 0; i < 6; i++) {
      if (i == row - 1) {
        dist[i]++;
      }
    }
    Prefs.setChartStats(dist: dist);
    Prefs.setChartRow(row: row);
  }
}
