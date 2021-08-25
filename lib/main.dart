import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/notifiers/dateTime_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/meeting_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/menu_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/address.dart';
import 'package:cs_senior_project_merchant/screens/login.dart';
import 'package:cs_senior_project_merchant/screens/opening_hours.dart';
import 'package:cs_senior_project_merchant/screens/orderDetail.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: StoreNotifier.initialize()),
      ChangeNotifierProvider(create: (context) => MeetingNotifier()),
      ChangeNotifierProvider(create: (context) => MenuNotifier()),
      ChangeNotifierProvider(create: (context) => DateTimeNotifier()),
    ],
    child: MaterialApp(
      theme: ThemeData(
        fontFamily: NotoSansFont,
        backgroundColor: Colors.white,
        primaryColor: CollectionsColors.orange,
        buttonColor: CollectionsColors.yellow,
        // iconTheme: IconThemeData(
        //   color: CollectionsColors.orange
        // ),
      ),
      // initialRoute: '/',
      home: MyApp(),
      routes: {
        // '/': (context) => BottomBar(),
        '/address': (context) => AddressPage(),
        // '/openingHours': (context) => OpeningHoursPage(),
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  // static final String title = 'Home';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Something went wrong")],
          ));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          switch (storeNotifier.status) {
            case Status.Uninitialized:
              return LoadingWidget();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return BottomBar();
            default:
              return LoginPage();
          }
        }

        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        );
      },
    );
  }
}
