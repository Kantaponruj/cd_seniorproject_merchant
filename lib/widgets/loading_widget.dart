import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'loading ...',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
