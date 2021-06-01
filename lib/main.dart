import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './component/bottomBar.dart';
import 'notifiers/storeNotifier.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StoreNotifier()),
        // ChangeNotifierProvider(create: (context) => LocationNotifier()),
        // ChangeNotifierProvider.value(value: UserNotifier.initialize())
        // ChangeNotifierProvider(create: (context) => UserNotifier.initialize())
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final String title = 'Home';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        bottomBar.routeName: (context) => bottomBar(),
      },
    );
  }
}

