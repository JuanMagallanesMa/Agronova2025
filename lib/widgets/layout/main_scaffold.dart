import 'package:flutter/material.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? trailingAppBar;
  final bool showDrawer;
  final PreferredSizeWidget? bottomAppBar;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    this.trailingAppBar,
    this.showDrawer = true,
    this.bottomAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title, trailing: trailingAppBar,bottom: bottomAppBar,),
      drawer: showDrawer ? const CustomDrawer() : null,
      body: body,
    );
  }
}
