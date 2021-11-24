//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class TimePickerWidget extends StatefulWidget {
//   @override
//   _TimePickerWidgetState createState() => _TimePickerWidgetState();
// }
//
// class _TimePickerWidgetState extends State<TimePickerWidget> {
//   TimeOfDay time;
//
//   @override
//   Widget build(BuildContext context) => pickTime(context);
//
//   Future pickTime(BuildContext context) async {
//     final initialTime = TimeOfDay(hour: 9, minute: 0);
//     final newTime = await showTimePicker(
//       context: context,
//       initialTime: time ?? initialTime,
//     );
//
//     if (newTime == null) return;
//
//     setState(() => time = newTime);
//   }
//
//
// }