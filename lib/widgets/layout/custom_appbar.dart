import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget?
  trailing; // Widget opcional a la derecha (e.g., botón de agregar)

  const CustomAppBar({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: trailing != null ? [trailing!, const SizedBox(width: 8)] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
