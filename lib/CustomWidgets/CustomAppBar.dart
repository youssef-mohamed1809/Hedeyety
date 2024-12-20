import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  IconButton? button;
  CustomAppBar({super.key, required this.button});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: button,
        )
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: 50, height: 50, child: Image.asset("Assets/Images/hedeyety_logo.png")),
          ),
          const Text("Hedeyety")
        ],

      ),
    );
  }
}