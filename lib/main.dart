import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/notifiers/meeting_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/screens/address.dart';
import 'package:cs_senior_project_merchant/screens/opening_hours.dart';
import 'package:cs_senior_project_merchant/screens/orderDetail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './component/bottomBar.dart';
import 'asset/text_style.dart';

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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: NotoSansFont,
        backgroundColor: Colors.white,
        primaryColor: CollectionsColors.orange,
        buttonColor: CollectionsColors.yellow,
        // iconTheme: IconThemeData(
        //   color: CollectionsColors.orange
        // ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BottomBar(),
        '/address': (context) => AddressPage(),
        '/openingHours': (context) => OpeningHoursPage(),
      },
    );
  }
}
