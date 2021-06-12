import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: RaisedButton(
          padding: EdgeInsets.all(10),
          color: Color(0xFFFAD161),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          onPressed: onClicked,
        ),

      ),
    );
  }
}
