import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 50,
      child: ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            primary: color != null ? color : Theme.of(context).buttonColor),
        child: Text(
          text,
          style: FontCollection.buttonTextStyle,
        ),
      ),
    );
  }
}

class StadiumButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const StadiumButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          onPressed: onClicked,
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(), primary: Theme.of(context).buttonColor),
          child: Text(
            text,
            style: FontCollection.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}

class SmallStadiumButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;

  const SmallStadiumButtonWidget({
    @required this.text,
    @required this.onClicked,
    this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        height: 60,
        child: ElevatedButton(
          onPressed: onClicked,
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: (color == null) ? Theme.of(context).buttonColor : color),
          child: Text(
            text,
            style: FontCollection.smallBodyTextStyle,
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  EditButton({Key key, @required this.onClicked, @required this.editText, this.textStyle})
      : super(key: key);

  final VoidCallback onClicked;
  final String editText;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClicked,
      child: Text(
        editText,
        style: textStyle == null ? FontCollection.underlineButtonTextStyle : textStyle,
      ),
    );
  }
}

class NoShapeButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;

  const NoShapeButton({
    @required this.text,
    @required this.onClicked,
    this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClicked,
      style: ElevatedButton.styleFrom(
          primary: (color == null) ? Theme.of(context).buttonColor : color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          text,
          style: FontCollection.smallBodyTextStyle,
        ),
      ),
    );
  }
}
