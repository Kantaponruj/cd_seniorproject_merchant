import 'package:flutter/material.dart';

Widget locateFAB(BuildContext context) => FloatingActionButton(
  backgroundColor: Colors.white,
  child: Icon(
    Icons.gps_fixed,
    color: Theme.of(context).primaryColor,
  ),
  onPressed: () {},
);