import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/constants/answer_enum.dart";
import "package:wordle/constants/colors.dart";
import "package:wordle/controllers/controller.dart";

class Tile extends StatefulWidget {
  final int index;

  const Tile({
    super.key,
    required this.index,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with SingleTickerProviderStateMixin {
  late Answer answer;

  late AnimationController _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _flipAnimation.dispose();
    super.dispose();
  }

  late Color backColor;
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (_, value, __) {
        if (widget.index < value.tiles.length) {
          text = value.tiles[widget.index].letter;
          answer = value.tiles[widget.index].answer;

          if (value.checkLine) {
            backColor = Theme.of(context).primaryColorLight;

            int delay = widget.index - (value.rowNumber - 1) * 5;
            Future.delayed(Duration(milliseconds: 250 * delay), () {
              if (mounted) {
                _flipAnimation.forward();
              }
              value.checkLine = false;
            });

            if (answer == Answer.correct) {
              backColor = COLORS.green;
            } else if (answer == Answer.contains) {
              backColor = COLORS.yellow;
            } else if (answer == Answer.incorrect) {
              backColor = Theme.of(context).primaryColorDark;
            }
          }

          return AnimatedBuilder(
            animation: _flipAnimation,
            builder: (_, __) {
              double flip = 0;
              if (_flipAnimation.value >= 0.5) {
                flip = pi;
              }

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.003)
                  ..rotateX(_flipAnimation.value * pi)
                  ..rotateX(flip),
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: flip > 0
                        ? backColor
                        : Theme.of(context).primaryColorLight,
                    border: Border.all(
                      width: 1.0,
                      color: Theme.of(context).dividerColor,
                    ),
                    // borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Theme.of(context).dividerColor,
              ),
              // borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }
      },
    );
  }
}
