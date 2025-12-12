import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget?
  trailing; // Widget opcional a la derecha (e.g., botón de agregar)
  final PreferredSizeWidget? bottom;
  const CustomAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: trailing != null ? [trailing!, const SizedBox(width: 8)] : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    // Calcula la altura del AppBar (kToolbarHeight)
    // MÁS la altura del 'bottom' (la TabBar), si existe.
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
