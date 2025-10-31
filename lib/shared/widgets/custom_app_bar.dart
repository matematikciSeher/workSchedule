import 'package:flutter/material.dart';

/// Özelleştirilebilir app bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

