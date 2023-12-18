import "package:wordle/constants/answer_enum.dart";

class TileModel {
  String letter;
  Answer answer;

  TileModel({
    required this.letter,
    required this.answer,
  });
}
