import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:cs_senior_project_merchant/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage(this.storeId);

  final String storeId;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getOrderMenu(
      orderNotifier,
      widget.storeId,
      orderNotifier.currentOrder.orderId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);

    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: CollectionsColors.grey,
        appBar: RoundedAppBar(
          appBarTittle: 'ข้อมูลการสั่งซื้ออาหาร',
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundColor: CollectionsColors.yellow,
                                radius: 35.0,
                                child: Text(
                                  orderNotifier.currentOrder.customerName[0]
                                      .toUpperCase(),
                                  style: FontCollection.descriptionTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              orderNotifier.currentOrder.customerName,
                              style: FontCollection.bodyTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.centerRight,
                              child: MaterialButton(
                                color: CollectionsColors.yellow,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.call,
                                ),
                                shape: CircleBorder(),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                OrderCard(
                  headerText: 'เวลาการนัดหมาย',
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            orderNotifier.currentOrder.dateOrdered,
                            style: FontCollection.bodyTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            '${orderNotifier.currentOrder.timeOrdered} น.',
                            style: FontCollection.bodyTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                OrderCard(
                  headerText: 'ที่อยู่',
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Text(
                            orderNotifier.currentOrder.address,
                            style: FontCollection.bodyTextStyle,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'แก้ไข',
                            style: FontCollection.smallBodyTextStyle,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // itemBuilder(menuNotifier),
                OrderCard(
                  headerText: 'รายการอาหารทั้งหมด',
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderNotifier.orderMenuList.length,
                            itemBuilder: (context, index) {
                              final menu = orderNotifier.orderMenuList[index];
                              return listOrder(menu);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  'ราคาสุทธิ',
                                  style: FontCollection.bodyTextStyle,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    orderNotifier.currentOrder.netPrice
                                        .toString(),
                                    style: FontCollection.bodyTextStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'บาท',
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomOrder(),
      ),
    );
  }

  Widget listOrder(OrderMenu menu) => Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      menu.amount.toString(),
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    menu.menuName,
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      menu.totalPrice,
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'บาท',
                      style: FontCollection.bodyTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    menu.topping.join(', '),
                    style: FontCollection.bodyTextStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
