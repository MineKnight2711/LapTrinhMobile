import 'package:flutter/material.dart';

class CustomSwiperPagination extends StatelessWidget {
  final int itemCount;
  final int activeIndex;

  const CustomSwiperPagination(
      {super.key, required this.itemCount, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        height: 2, // Adjust the height of the line here
        width: itemCount * 20.0, // Adjust the width based on itemCount
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              width: 12,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              color: activeIndex == index
                  ? Colors.blue
                  : Colors.grey, // Adjust active and inactive colors here
            );
          },
        ),
      ),
    );
  }
}
