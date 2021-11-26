import 'package:flutter/material.dart';

class BuildPopUpMenu extends StatelessWidget {
  BuildPopUpMenu({Key key, this.children, this.onSelected}) : super(key: key);

  final Function(String) onSelected;
  final List<PopupMenuEntry<String>> children;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => children,
      onSelected: onSelected,
    );
  }
}
