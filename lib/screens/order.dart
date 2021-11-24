import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/location_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/order/customer_map.dart';
import 'package:cs_senior_project_merchant/screens/order/orderDetail.dart';
import 'package:cs_senior_project_merchant/screens/store.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:cs_senior_project_merchant/widgets/icontext_widget.dart';
import 'package:cs_senior_project_merchant/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key, this.typeOrder}) : super(key: key);

  final String typeOrder;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    storeNotifier.reloadUserModel();

    LocationNotifier locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);
    locationNotifier.initialization();

    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);

    updateLocation();

    getOrderDelivery(orderNotifier, storeNotifier.user.uid);
    super.initState();
  }

  Future<void> updateLocation() async {
    StoreNotifier store = Provider.of<StoreNotifier>(context, listen: false);

    Position _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (store.store.storeStatus == true) {
      store.updateUserData({
        "realtimeLocation": GeoPoint(
          _currentPosition.latitude,
          _currentPosition.longitude,
        ),
      });

      print(
        '${_currentPosition.latitude} ${_currentPosition.longitude}',
      );

      Future.delayed(Duration(seconds: 1), () {
        updateLocation();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        // appBar: MainAppbar(
        //   appBarTitle: 'คำสั่งซื้อ',
        //   map: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => AllDestinationPage()));
        //   },
        // ),
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: getOrders(storeNotifier.user.uid, widget.typeOrder),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                }

                return Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'รอการยืนยัน',
                          style: FontCollection.topicBoldTextStyle,
                        ),
                      ),
                      ListView(
                        children: snapshot.data.docs.map((order) {
                          return order['orderStatus'] == 'กำลังดำเนินการ'
                              ? orderCard(order, storeNotifier.user.uid)
                              : Container();
                        }).toList(),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'ยืนยันแล้ว',
                          style: FontCollection.topicBoldTextStyle,
                        ),
                      ),
                      ListView(
                        children: snapshot.data.docs.map((order) {
                          return order['orderStatus'] == 'ยืนยันคำสั่งซื้อ' ||
                                  order['orderStatus'] == 'ยืนยันการจัดส่ง'
                              ? orderCard(order, storeNotifier.user.uid)
                              : Container();
                        }).toList(),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget priceText(String text) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: NotoSansFont,
          fontWeight: FontWeight.w700,
          fontSize: regularSize,
          color: CollectionsColors.orange,
        ),
      ),
    );
  }

  Widget orderCard(final order, String storeId) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: GestureDetector(
        onTap: () {
          switchPage() {
            switch (order['orderStatus']) {
              case 'ยืนยันคำสั่งซื้อ':
                return OrderDetailPage(
                    storeId: storeId,
                    order: order,
                    isConfirm: false,
                    typeOrder: widget.typeOrder);
              case 'ยืนยันการจัดส่ง':
                return CustomerMapPage(order: order);
              default:
                return OrderDetailPage(
                    storeId: storeId,
                    order: order,
                    isConfirm: false,
                    typeOrder: widget.typeOrder);
            }
          }

          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => switchPage()),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildName(
                        order['customerName'][0].toUpperCase(),
                        order['customerName'],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: CollectionsColors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            Text(
                              '${order['distance']} กม.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            BuildIconText(
                              icon: Icons.date_range,
                              child: Text(
                                order['dateOrdered'],
                                style: FontCollection.smallBodyTextStyle,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            BuildIconText(
                              icon: Icons.access_time,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'ก่อน',
                                      style: FontCollection.smallBodyTextStyle,
                                    ),
                                  ),
                                  priceText(order['timeOrdered']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bottomLeft(
                                order['amountOfMenu'],
                                order['netPrice'],
                              ),
                              Container(
                                child: Text(
                                  'รายละเอียด',
                                  style:
                                      FontCollection.underlineButtonTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomLeft(String orderNumber, String price) {
    return Container(
      child: Row(
        children: [
          BuildIconText(
            icon: Icons.list_alt,
            text: '$orderNumber รายการ',
          ),
          SizedBox(
            height: 20,
            child: VerticalDivider(
              thickness: 2,
              width: 20,
            ),
          ),
          priceText(price),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'บาท',
              style: FontCollection.smallBodyTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildName(String leadingName, String name) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: CollectionsColors.navy,
            child: Text(
              leadingName,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            radius: 15,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              name,
              style: FontCollection.smallBodyTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
