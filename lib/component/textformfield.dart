import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildTextField extends StatefulWidget {
  BuildTextField({
    Key key,
    this.labelText,
    @required this.textEditingController,
    @required this.hintText,
    this.errorText,
    this.validator,
    this.textInputType,
    this.obscureText = false,
    this.maxLength,
    this.maxLine,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);

  final String labelText;
  final TextEditingController textEditingController;
  final String hintText;
  final String errorText;
  final String Function(String) validator;
  final TextInputType textInputType;
  final bool obscureText;
  final int maxLength;
  final int maxLine;
  final Function onSaved;
  final Function(String) onChanged;

  @override
  _BuildTextFieldState createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        fillColor: CollectionsColors.orange,
        errorText: widget.errorText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: CollectionsColors.orange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.red, width: 2.0),
        ),
      ),
      keyboardType: widget.textInputType,
      validator: widget.validator,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      maxLines: widget.maxLine,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
    );
  }
}

class BuildPasswordField extends StatefulWidget {
  const BuildPasswordField({
    Key key,
    @required this.labelText,
    @required this.textEditingController,
    @required this.hintText,
    this.errorText,
    this.validator,
  }) : super(key: key);

  final String labelText;
  final TextEditingController textEditingController;
  final String hintText;
  final String errorText;
  final String Function(String) validator;

  @override
  _BuildPasswordFieldState createState() => _BuildPasswordFieldState();
}

class _BuildPasswordFieldState extends State<BuildPasswordField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: isHidden,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        focusColor: CollectionsColors.orange,
        hoverColor: CollectionsColors.orange,
        fillColor: CollectionsColors.orange,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: CollectionsColors.orange,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.red, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          disabledColor: Colors.grey,
          focusColor: CollectionsColors.orange,
          color: Colors.black.withOpacity(0.6),
          onPressed: togglePasswordVisibility,
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      autofillHints: [AutofillHints.password],
      onEditingComplete: () => TextInput.finishAutofillContext(),
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}

class BuildPlainTextField extends StatefulWidget {
  BuildPlainTextField({
    Key key,
    this.textEditingController,
    this.hintText,
    this.initialValue,
    this.keyboardType,
    this.errorText,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final String initialValue;
  final TextInputType keyboardType;
  final String errorText;
  final Function(String) validator;
  final Function(String) onSaved;

  @override
  _BuildPlainTextFieldState createState() => _BuildPlainTextFieldState();
}

class _BuildPlainTextFieldState extends State<BuildPlainTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CollectionsColors.orange, width: 2.0),
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
