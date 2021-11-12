import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class BuildSwitch extends StatelessWidget {
  BuildSwitch({
    Key key,
    this.width,
    @required this.activeText,
    @required this.inactiveText,
    @required this.value,
    @required this.onToggle,
  }) : super(key: key);

  final double width;
  final String activeText;
  final String inactiveText;
  final bool value;
  final void Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: width,
      showOnOff: true,
      activeTextColor: CollectionsColors.white,
      activeColor: CollectionsColors.orange,
      inactiveTextColor: CollectionsColors.white,
      activeText: activeText,
      inactiveText: inactiveText,
      activeTextFontWeight: FontWeight.w400,
      inactiveTextFontWeight: FontWeight.w400,
      value: value,
      onToggle: onToggle,
    );
  }
}
