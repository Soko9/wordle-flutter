import "package:flutter/material.dart";

class CustomSwitch extends StatelessWidget {
  final bool isSwitched;
  final IconData one;
  final IconData two;

  const CustomSwitch({
    Key? key,
    required this.isSwitched,
    required this.one,
    required this.two,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 80.0,
      height: 40.0,
      color: Colors.transparent,
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSwitched ? theme.primaryColor : theme.primaryColorLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                one,
                color: isSwitched ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    !isSwitched ? theme.primaryColor : theme.primaryColorLight,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                two,
                color: !isSwitched ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
