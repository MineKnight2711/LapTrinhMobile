import 'package:flutter/material.dart';

class CenteredTextWithLineBars extends StatelessWidget {
  final String text;
  final int? textFlex;
  const CenteredTextWithLineBars(
      {super.key, required this.text, this.textFlex});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: size.height / 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.75),
                    Colors.black,
                  ],
                  stops: const [0.1, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          Flexible(
            flex: textFlex ?? 5,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: size.height / 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
                    Colors.black,
                  ],
                  stops: const [0.1, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
