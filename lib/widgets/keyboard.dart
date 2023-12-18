import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wordle/constants/answer_enum.dart";
import "package:wordle/constants/colors.dart";
import "package:wordle/controllers/controller.dart";
import "package:wordle/data/keybaord_keys.dart";

class Keyboard extends StatelessWidget {
  final int min;
  final int max;

  const Keyboard({
    super.key,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<Controller>(
      builder: (_, value, __) {
        int index = 0;

        return IgnorePointer(
          ignoring: value.gameCompleted,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: keyboardKeys.entries.map(
              (key) {
                index++;
                if (index >= min && index <= max) {
                  Color bgColor = Theme.of(context).primaryColorLight;
                  Color fontColor = Colors.black87;

                  if (key.value == Answer.correct) {
                    bgColor = COLORS.green;
                    fontColor = Colors.white;
                  } else if (key.value == Answer.contains) {
                    bgColor = COLORS.yellow;
                    fontColor = Colors.white;
                  } else if (key.value == Answer.incorrect) {
                    bgColor = Theme.of(context).primaryColorDark;
                    fontColor = Colors.white;
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: SizedBox(
                      width: key.key.length > 1
                          ? size.width * 0.14
                          : size.width * 0.09,
                      height: size.height * 0.08,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.006),
                        child: Material(
                          borderRadius: BorderRadius.circular(4.0),
                          color: key.key.length > 1
                              ? key.key == "BACK"
                                  ? Colors.red
                                  : Colors.green
                              : bgColor,
                          child: InkWell(
                            onTap: () {
                              Provider.of<Controller>(context, listen: false)
                                  .handlePress(
                                      context: context, letter: key.key);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: key.key.length > 1
                                    ? key.key == "BACK"
                                        ? const Icon(
                                            Icons
                                                .keyboard_double_arrow_left_rounded,
                                            size: 32.0,
                                          )
                                        : const Icon(
                                            Icons.done_rounded,
                                            size: 32.0,
                                          )
                                    : Text(
                                        key.key,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: fontColor,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
