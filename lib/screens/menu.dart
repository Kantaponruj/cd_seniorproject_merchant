import 'dart:async';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/login.dart';
import 'package:cs_senior_project_merchant/screens/menu/add_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  static const routeName = '/menu';

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Widget> _children;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: RoundedAppBar(
          appBarTittle: 'เพิ่มรายการอาหารของคุณ',
          action: [
            IconButton(onPressed: () {
              store.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
            }, icon: Icon(Icons.logout),),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: buildHorizontalListView(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 2,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return menuCategories();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddMenuPage()));
          },
          backgroundColor: CollectionsColors.orange,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildHorizontalListView() => ListView.builder(
    padding: EdgeInsets.all(16),
    scrollDirection: Axis.horizontal,
    physics: NeverScrollableScrollPhysics(),
    // separatorBuilder: (context, index) => Divider(),
    itemCount: 2,
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(right: 16),
        child: Text(
          'categories name',
          style: FontCollection.topicBoldTextStyle,
        ),
      );
    },
  );

  Widget menuCategories() => BuildCard(
    headerText: 'categories name',
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: gridView(),
    ),
    canEdit: false,
  );

  Widget gridView() {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
        ),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        controller: controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          // final item = items[index];
          return menuData(storeNotifier, index);
        },
      ),
    );
  }

  Widget menuData(StoreNotifier storeNotifier, int index) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
          },
          child: Container(
            alignment: Alignment.centerLeft,
            width: 150,
            child: Column(
              children: [
                Container(
                  height: 150,
                  child: SizedBox(
                    child: Image.network(
                      'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    'name',
                    textAlign: TextAlign.left,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'price' + ' บาท',
                    textAlign: TextAlign.left,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}
