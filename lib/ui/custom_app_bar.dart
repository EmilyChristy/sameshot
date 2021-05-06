import 'package:flutter/material.dart';
import 'package:sameshot/ui/settings_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_4),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return SettingsPage();
              }),
            )
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
