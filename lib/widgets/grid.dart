import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/animations/bounce_animation.dart";
import "package:wordle/animations/dance_animation.dart";
import "package:wordle/controllers/controller.dart";
import "package:wordle/controllers/theme_controller.dart";
import "package:wordle/widgets/tile.dart";

class Grid extends StatelessWidget {
  const Grid({super.key});

  static const double space = 5.0;
  static const int columns = 5;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: space,
        crossAxisSpacing: space,
      ),
      itemBuilder: (context, index) => Consumer<ThemeController>(
        builder: (_, __, ___) {
          return Consumer<Controller>(
            builder: (_, value, __) {
              bool animate = false;
              bool animateDance = false;
              int danceDelay = 1450;
              if (index == value.tileNumber - 1 && !value.isBackOrEnter) {
                animate = true;
              }
              if (value.gameWon) {
                for (int i = value.tiles.length - 5;
                    i < value.tiles.length;
                    i++) {
                  if (index == i) {
                    animateDance = true;
                    danceDelay += 90 * (i - (value.rowNumber - 1) * 5);
                  }
                }
              }
              return DanceAnimation(
                delay: danceDelay,
                animate: animateDance,
                child: BounceAnimation(
                  animate: animate,
                  child: Tile(index: index),
                ),
              );
            },
          );
        },
      ),
      itemCount: 30,
    );
  }
}
