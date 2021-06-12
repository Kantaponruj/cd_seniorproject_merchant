import 'package:cs_senior_project/component/roundAppBar.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: RoundedAppBar(appBarTittle: 'History',),
      body: Center(
        child: Container(
          color: Colors.teal,
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('This is menu page'),
              // SearchWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
