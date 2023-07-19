import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLeading;
  final VoidCallback onPressed;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  const CustomAppBar(
      {super.key,
      this.title,
      this.showLeading = true,
      required this.onPressed,
      this.bottom,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? GestureDetector(
              onTap: onPressed,
              child:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            )
          : null,
      actions: actions,
      title: Text(
        title ?? "",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
