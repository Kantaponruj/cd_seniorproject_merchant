import 'package:cs_senior_project/notifiers/meeting_notifier.dart';
import 'package:cs_senior_project/notifiers/menu_notifier.dart';
import 'package:cs_senior_project/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './component/bottomBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MeetingNotifier()),
    ChangeNotifierProvider(create: (context) => MenuNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final String title = 'Home';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
        ),
        // initialRoute: '/',
        // routes: {
        //   bottomBar.routeName: (context) => bottomBar(),
        // }
        home: LoginPage());
  }
}
