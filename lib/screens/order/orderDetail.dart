import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/constant.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/screens/order/customer_map.dart';
import 'package:cs_senior_project_merchant/screens/order/cutomer_map.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:cs_senior_project_merchant/widgets/bottomOrder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage(
      {Key key, @required this.storeId, @required this.order, this.isConfirm})
      : super(key: key);

  final String storeId;
  final order;
  final bool isConfirm;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String orderStatus;
  OrderMenu menu = OrderMenu();

  @override
  void initState() {
    OrderNotifier orderNotifier =
        Provider.of<OrderNotifier>(context, listen: false);
    getOrderMenu(
      orderNotifier,
      widget.storeId,
      widget.order['documentId'],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    // StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return Scaffold(
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
                    padding: EdgeInsets.all(20),
                    child: customerInfo(),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 2,
                    //       child: Container(
                    //         height: 40,
                    //         width: 40,
                    //         alignment: Alignment.centerLeft,
                    //         child: CircleAvatar(
                    //           backgroundColor: CollectionsColors.yellow,
                    //           radius: 35.0,
                    //           child: Text(
                    //             widget.order['customerName'][0].toString(),
                    //             style: FontCollection.descriptionTextStyle,
                    //             textAlign: TextAlign.left,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 8,
                    //       child: Text(
                    //         widget.order['customerName'],
                    //         style: FontCollection.bodyTextStyle,
                    //         textAlign: TextAlign.left,
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 2,
                    //       child: Container(
                    //         width: 40,
                    //         height: 40,
                    //         alignment: Alignment.centerRight,
                    //         child: MaterialButton(
                    //           color: CollectionsColors.yellow,
                    //           textColor: Colors.white,
                    //           child: Icon(
                    //             Icons.call,
                    //           ),
                    //           shape: CircleBorder(),
                    //           onPressed: () async {
                    //             String number = widget.order['phone'];
                    //             // launch('tel://$number');
                    //             await FlutterPhoneDirectCaller.callNumber(
                    //                 number);
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ),
              OrderCard(
                headerText: 'เวลาการสั่งซื้อ',
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          widget.order['dateOrdered'],
                          style: FontCollection.bodyTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          '${widget.order['timeOrdered']} น.',
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
                        child: Text(
                          widget.order['address'],
                          style: FontCollection.bodyTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => CustomerMap(
                                  order: widget.order,
                                ),
                              ),
                            );
                          },
                          color: CollectionsColors.orange,
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
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderNotifier.orderMenuList.length,
                          itemBuilder: (context, index) {
                            menu = orderNotifier.orderMenuList[index];
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
                                  widget.order['netPrice'].toString(),
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
              // Add message card
              OrderCard(
                headerText: 'ข้อความเพิ่มเติม',
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.order['message'] ?? 'ไม่มีข้อความเพิ่มเติม',
                      style: FontCollection.bodyTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              widget.isConfirm
                  ? SizedBox.shrink()
                  : Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'ยกเลิกคำสั่งซื้อ',
                          style: FontCollection.underlineButtonTextStyle,
                        ),
                      ),
                    ),

              ///End Column
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.isConfirm
          ? SizedBox.shrink()
          : BottomOrder(
              confirmButton: () {
                orderStatus = 'ยืนยันคำสั่งซื้อ';
                setState(() {
                  isConfirmed = false;
                  isDelivery = false;
                  updateStatusOrder(
                    widget.order['customerId'],
                    widget.order['storeId'],
                    widget.order['orderId'],
                    widget.order['documentId'],
                    orderStatus,
                  );
                });
              },
              deliveryStatus: () {
                orderStatus = 'ยืนยันการจัดส่ง';
                setState(() {
                  isConfirmed = true;
                  isDelivery = true;
                  updateStatusOrder(
                    widget.order['customerId'],
                    widget.order['storeId'],
                    widget.order['orderId'],
                    widget.order['documentId'],
                    orderStatus,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CustomerMapPage(
                        order: widget.order,
                        orderMenu: menu,
                      ),
                    ),
                  );
                });
              },
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

  final height = 50.0;
  final width = 50.0;

  Widget customerInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          userPicAndName(),
          Container(
            width: width,
            height: height,
            // alignment: Alignment.centerRight,
            child: MaterialButton(
              color: CollectionsColors.yellow,
              textColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.call,
                ),
              ),
              shape: CircleBorder(),
              onPressed: () async {
                String number = widget.order['phone'];
                // launch('tel://$number');
                await FlutterPhoneDirectCaller.callNumber(number);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget userPicAndName() {
    return Container(
      child: Row(
        children: [
          Container(
            width: width,
            height: height,
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: CollectionsColors.yellow,
              radius: height,
              child: Text(
                widget.order['customerName'][0],
                style: FontCollection.descriptionTextStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              widget.order['customerName'],
              style: FontCollection.bodyTextStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
