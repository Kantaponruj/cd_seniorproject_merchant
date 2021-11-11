import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:flutter/material.dart';

class BuildCheckBox extends StatelessWidget {
  BuildCheckBox({Key key,this.title, this.value, this.onChanged}) : super(key: key);

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      controlAffinity: ListTileControlAffinity.leading,
      value: value,
      onChanged: onChanged,
      activeColor: CollectionsColors.yellow,
      checkColor: CollectionsColors.white,
    );
  }
}
