import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/mainAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/orderDetail.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: false);
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getOrderDelivery(orderNotifier, storeNotifier.store.storeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CollectionsColors.grey,
        appBar: MainAppbar(
          appBarTitle: 'คำสั่งซื้อ',
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return buildStoreCard(orderNotifier, index);
          },
          itemCount: orderNotifier.orderList.length,
        ),
      ),
    );
  }

  Widget buildStoreCard(OrderNotifier orderNotifier, int index) {
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: GestureDetector(
        onTap: () {
          orderNotifier.currentOrder = orderNotifier.orderList[index];
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  OrderDetailPage(storeNotifier.store.storeId),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            backgroundColor: CollectionsColors.grey,
                            radius: 35.0,
                            child: Text(
                              orderNotifier.orderList[index].customerName[0]
                                  .toUpperCase(),
                              style: FontCollection.descriptionTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          orderNotifier.orderList[index].customerName,
                          style: FontCollection.bodyTextStyle,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'รายละเอียด',
                            style: FontCollection.descriptionTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  // padding: ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                orderNotifier.orderList[index].dateOrdered,
                                textAlign: TextAlign.left,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                orderNotifier.orderList[index].timeOrdered,
                                textAlign: TextAlign.left,
                                style: FontCollection.bodyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            orderNotifier.orderList[index].netPrice,
                            style: TextStyle(
                              fontFamily: NotoSansFont,
                              fontWeight: FontWeight.w700,
                              fontSize: bigSize,
                              color: CollectionsColors.red,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            ' บาท',
                            style: FontCollection.bodyTextStyle,
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

  Widget priceText(String text) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: NotoSansFont,
          fontWeight: FontWeight.w700,
          fontSize: bigSize,
          color: CollectionsColors.red,
        ),
      ),
    );
  }
}
