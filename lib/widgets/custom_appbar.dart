import 'package:flutter/material.dart' as x;
import 'package:sizer/sizer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  const CustomAppbar({
    super.key,
    required this.title,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return x.AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(32, 32, 32, 1),
      surfaceTintColor: const Color.fromRGBO(32, 32, 32, 1),
      automaticallyImplyLeading: false,
      actions: actions,
      leading: IconButton(
        icon: const Icon(FluentIcons.back),
        onPressed: () async {
          await windowManager.restore();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(6.5.h);
}
