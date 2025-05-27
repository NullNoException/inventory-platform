import 'package:flutter/material.dart';

/// A custom app bar with configurable title, actions, and back button behavior.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Widget? leading;
  final double elevation;
  final Widget? titleWidget;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.leading,
    this.elevation = 4.0,
    this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? Text(title),
      automaticallyImplyLeading: showBackButton,
      leading:
          onBackPressed != null
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed,
              )
              : leading,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
