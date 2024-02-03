import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Key? key, Widget? leading})
      : super(
          key: key,
          leading: leading,
          backgroundColor: Colors.black,
          elevation: 0,
          actions: [
            const Icon(Icons.more_vert, color: Colors.white,)
          ]
        );
}
