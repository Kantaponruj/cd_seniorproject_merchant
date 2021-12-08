import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/bottomBar.dart';
import 'package:cs_senior_project_merchant/component/mainAppBar.dart';
import 'package:cs_senior_project_merchant/component/orderCard.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/models/order.dart';
import 'package:cs_senior_project_merchant/notifiers/order_notifier.dart';
import 'package:cs_senior_project_merchant/notifiers/store_notifier.dart';
import 'package:cs_senior_project_merchant/screens/order/customer_map.dart';
import 'package:cs_senior_project_merchant/screens/order/individual_map.dart';
import 'package:cs_senior_project_merchant/services/order_service.dart';
import 'package:cs_senior_project_merchant/widgets/bottomOrder_widget.dart';
import 'package:cs_senior_project_merchant/widgets/button_widget.dart';
import 'package:cs_senior_project_merchant/widgets/icontext_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({
    Key key,
    @required this.storeId,
    @required this.order,
    @required this.typeOrder,
    @required this.isConfirm,
    @required this.isDelivery,
  }) : super(key: key);

  final String storeId;
  final order;
  final bool isConfirm;
  final String typeOrder;
  final bool isDelivery;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String orderStatus = 'ยืนยันคำสั่งซื้อ';
  String topicTime;
  OrderMenu menu = OrderMenu();
  OrderDetail _orderDetail = OrderDetail();
  // bool check;

  @override
  void initState() {
    OrderNotifier order = Provider.of<OrderNotifier>(context, listen: false);
    getOrderMenu(
      order,
      widget.storeId,
      widget.order['documentId'],
      widget.typeOrder,
    );
    // checkStatus();
    topicTime = widget.order['typeOrder'] == 'delivery'
        ? 'ระยะเวลาการจัดส่ง'
        : 'เวลานัดหมาย';
    super.initState();
  }

  // bool checkStatus() {
  //   if (orderStatus == 'ยืนยันคำสั่งซื้อ') {
  //     setState(() {
  //       check = true;
  //     });
  //   } else {
  //     setState(() {
  //       check = false;
  //     });
  //   }
  //   return check;
  // }

  // bool checkStatusPick() {
  //   if (orderStatus == 'ยืนยันคำสั่งซื้อ') {
  //     setState(() {
  //       check = true;
  //     });
  //   } else {
  //     setState(() {
  //       check = false;
  //     });
  //   }
  //   return check;
  // }

  @override
  Widget build(BuildContext context) {
    OrderNotifier orderNotifier = Provider.of<OrderNotifier>(context);
    StoreNotifier storeNotifier = Provider.of<StoreNotifier>(context);

    return (widget.isDelivery)
        ? Scaffold(
            // extendBodyBehindAppBar: true,
            backgroundColor: CollectionsColors.grey,
            appBar: RoundedAppBar(
              appBarTittle: 'ข้อมูลการสั่งซื้ออาหาร',
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: customerDeliCard(
                          widget.order['customerName'],
                          widget.order['phone'],
                          widget.order['address'],
                          () async {
                            String number = widget.order['phone'];
                            // launch('tel://$number');
                            await FlutterPhoneDirectCaller.callNumber(number);
                          },
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    IndividualMap(
                                  order: widget.order,
                                ),
                              ),
                            );
                          },
                        )
                        // ),
                        ),
                    BuildCard(
                      headerText: topicTime,
                      canEdit: false,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            BuildIconText(
                              icon: Icons.calendar_today,
                              text: widget.order['dateOrdered'],
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                BuildIconText(
                                  icon: Icons.schedule,
                                  text: '${widget.order['startWaitingTime']}',
                                ),
                                widget.order['endWaitingTime'] != null
                                    ? BuildIconText(
                                        text:
                                            ' จนถึง   ${widget.order['endWaitingTime']} น.',
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // itemBuilder(menuNotifier),
                    BuildCard(
                      headerText: 'รายการอาหารทั้งหมด',
                      canEdit: false,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            Container(
                              child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderNotifier.orderMenuList.length,
                                itemBuilder: (context, index) {
                                  menu = orderNotifier.orderMenuList[index];
                                  return listOrder(menu);
                                },
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'ราคาอาหารทั้งหมด',
                                            style: FontCollection.bodyTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              widget.order['subTotal']
                                                  .toString(),
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'บาท',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'ค่าส่ง',
                                            style: FontCollection.bodyTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              widget.order['shippingFee']
                                                  .toString(),
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'บาท',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'ราคาสุทธิ',
                                            style: FontCollection
                                                .bodyBoldTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              widget.order['netPrice']
                                                  .toString(),
                                              style: FontCollection
                                                  .bodyBoldTextStyle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'บาท',
                                              style: FontCollection
                                                  .bodyBoldTextStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    // Add message card
                    BuildCard(
                      headerText: 'ข้อความเพิ่มเติม',
                      canEdit: false,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: AlertDialog(
                                        title: Text(
                                          'ยืนยันที่จะลบข้อมูลที่อยู่นี้หรือไม่',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text(
                                                    'ยกเลิก',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: CollectionsColors
                                                            .red),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: ButtonWidget(
                                                  text: 'ยืนยัน',
                                                  onClicked: () {},
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
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
            bottomNavigationBar:
                widget.order['orderStatus'] == 'ยืนยันคำสั่งซื้อ'
                    ? BottomOrder(
                        text: 'ยืนยันการจัดส่ง',
                        onPressed: () {
                          setState(() {
                            updateStatusOrder(
                              widget.order['customerId'],
                              widget.order['storeId'],
                              widget.order['orderId'],
                              widget.order['documentId'],
                              'ยืนยันการจัดส่ง',
                              'delivery-orders',
                            );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => CustomerMapPage(
                                  order: widget.order,
                                  orderMenu: menu,
                                ),
                              ),
                            );
                          });
                        },
                      )
                    : BottomOrder(
                        text: 'ยืนยันคำสั่งซื้อ',
                        onPressed: () {
                          setState(() {
                            updateStatusOrder(
                              widget.order['customerId'],
                              widget.order['storeId'],
                              widget.order['orderId'],
                              widget.order['documentId'],
                              'ยืนยันคำสั่งซื้อ',
                              'delivery-orders',
                            );
                          });
                        },
                      ),
          )
        : Scaffold(
            backgroundColor: CollectionsColors.grey,
            appBar: RoundedAppBar(
              appBarTittle: 'ข้อมูลการสั่งซื้ออาหาร',
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: customerPickCard(
                          widget.order['customerName'],
                          widget.order['phone'],
                          () async {
                            String number = widget.order['phone'];
                            // launch('tel://$number');
                            await FlutterPhoneDirectCaller.callNumber(number);
                          },
                        )
                        // ),
                        ),
                    BuildCard(
                      headerText: topicTime,
                      canEdit: false,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            BuildIconText(
                              icon: Icons.calendar_today,
                              text: widget.order['dateOrdered'],
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 50),
                              child: BuildIconText(
                                icon: Icons.access_time,
                                text: widget.order['timeOrdered'] + ' น.',
                              ),
                            ),
                            // Divider(
                            //   color: Colors.white,
                            // ),
                            // Row(
                            //   children: [
                            //     BuildIconText(
                            //       icon: Icons.schedule,
                            //       text: '${widget.order['startWaitingTime']}',
                            //     ),
                            //     widget.order['endWaitingTime'] != null
                            //         ? BuildIconText(
                            //             text:
                            //                 ' จนถึง   ${widget.order['endWaitingTime']} น.',
                            //           )
                            //         : SizedBox(),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // itemBuilder(menuNotifier),
                    BuildCard(
                      headerText: 'รายการอาหารทั้งหมด',
                      canEdit: false,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            Container(
                              child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderNotifier.orderMenuList.length,
                                itemBuilder: (context, index) {
                                  menu = orderNotifier.orderMenuList[index];
                                  return listOrder(menu);
                                },
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'ราคาอาหารทั้งหมด',
                                            style: FontCollection.bodyTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              widget.order['subTotal']
                                                  .toString(),
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'บาท',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'ค่าส่ง',
                                            style: FontCollection.bodyTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              widget.order['shippingFee']
                                                  .toString(),
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'บาท',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'ราคาสุทธิ',
                                            style: FontCollection
                                                .bodyBoldTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              widget.order['netPrice']
                                                  .toString(),
                                              style: FontCollection
                                                  .bodyBoldTextStyle,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'บาท',
                                              style:
                                                  FontCollection.bodyTextStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    // Add message card
                    BuildCard(
                      headerText: 'ข้อความเพิ่มเติม',
                      canEdit: false,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: AlertDialog(
                                        title: Text(
                                          'ยืนยันที่จะลบข้อมูลที่อยู่นี้หรือไม่',
                                          style: FontCollection.bodyTextStyle,
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text(
                                                    'ยกเลิก',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: CollectionsColors
                                                            .red),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: ButtonWidget(
                                                  text: 'ยืนยัน',
                                                  onClicked: () {
                                                    // int count = 0;
                                                    //
                                                    // Navigator.popUntil(context,
                                                    //     (route) {
                                                    //   return count++ == 2;
                                                    // });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
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
            bottomNavigationBar: widget.order['orderStatus'] ==
                    'ยืนยันคำสั่งซื้อ'
                ? BottomOrder(
                    text: 'ปรุงอาหารเสร็จเรียบร้อย',
                    onPressed: () {
                      setState(() {
                        _orderDetail.documentId = widget.order['documentId'];
                        _orderDetail.orderId = widget.order['orderId'];
                        _orderDetail.customerId = widget.order['customerId'];
                        _orderDetail.customerName =
                            widget.order['customerName'];
                        _orderDetail.phone = widget.order['phone'];
                        _orderDetail.address = widget.order['address'];
                        _orderDetail.addressDetail =
                            widget.order['addressDetail'];
                        _orderDetail.message = widget.order['message'];
                        _orderDetail.netPrice = widget.order['netPrice'];
                        _orderDetail.dateOrdered = widget.order['dateOrdered'];
                        _orderDetail.timeOrdered = widget.order['timeOrdered'];
                        _orderDetail.startWaitingTime =
                            widget.order['startWaitingTime'];
                        _orderDetail.endWaitingTime =
                            widget.order['endWaitingTime'];
                        _orderDetail.amountOfMenu =
                            widget.order['amountOfMenu'];
                        _orderDetail.geoPoint = widget.order['geoPoint'];
                        _orderDetail.typeOrder = widget.order['typeOrder'];
                      });

                      updateStatusOrder(
                        widget.order['customerId'],
                        widget.order['storeId'],
                        widget.order['orderId'],
                        widget.order['documentId'],
                        'ปรุงอาหารเสร็จเรียบร้อย',
                        'pickup-orders',
                      );

                      saveOrderToHistory(
                        storeNotifier.store.storeId,
                        _orderDetail,
                      );
                      saveOrderMenuToHistory(
                        storeNotifier.store.storeId,
                        menu,
                      );
                      completedOrder(
                        storeNotifier.store.storeId,
                        widget.order['documentId'],
                        'pickup-orders',
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MainBottombar()),
                        (route) => false,
                      );
                    },
                  )
                : BottomOrder(
                    text: 'ยืนยันคำสั่งซื้อ',
                    onPressed: () {
                      setState(() {
                        updateStatusOrder(
                          widget.order['customerId'],
                          widget.order['storeId'],
                          widget.order['orderId'],
                          widget.order['documentId'],
                          'ยืนยันคำสั่งซื้อ',
                          'pickup-orders',
                        );
                      });
                    },
                  ),
          );
  }

  // Widget listOrder(OrderMenu menu) => Container(
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Expanded(
  //                 flex: 2,
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   child: Text(
  //                     menu.amount.toString(),
  //                     style: FontCollection.bodyTextStyle,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 6,
  //                 child: Text(
  //                   menu.menuName,
  //                   style: FontCollection.bodyTextStyle,
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 2,
  //                 child: Container(
  //                   alignment: Alignment.centerRight,
  //                   child: Text(
  //                     menu.totalPrice,
  //                     style: FontCollection.bodyTextStyle,
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 2,
  //                 child: Container(
  //                   alignment: Alignment.centerRight,
  //                   child: Text(
  //                     'บาท',
  //                     style: FontCollection.bodyTextStyle,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   menu.topping.join(', '),
  //                   style: FontCollection.bodyTextStyle,
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     );

  final height = 80.0;
  final width = 80.0;

  Widget customerDeliCard(
    String name,
    String phoneNumber,
    String address,
    VoidCallback onClickedContact,
    VoidCallback onClickedAddress,
  ) {
    return BuildCard(
      headerText: 'ข้อมูลผู้สั่งซื้อ',
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 5, 20),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: CollectionsColors.navy,
                radius: 35.0,
                child: Icon(
                  Icons.person,
                  color: CollectionsColors.white,
                ),
              ),
              title: Text(
                name,
                style: FontCollection.bodyTextStyle,
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                phoneNumber,
                style: FontCollection.bodyTextStyle,
              ),
              trailing: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CollectionsColors.yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 1,
                        offset: Offset(-0.5, 2))
                  ],
                ),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              onTap: onClickedContact,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: CollectionsColors.navy,
                  radius: 35.0,
                  child: Icon(
                    Icons.location_on,
                    color: CollectionsColors.white,
                  ),
                ),
                title: AutoSizeText(
                  address,
                  style: FontCollection.bodyTextStyle,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  Icons.chevron_right_outlined,
                  color: Colors.black,
                ),
                onTap: onClickedAddress,
              ),
            ),
          ],
        ),
      ),
      canEdit: false,
    );
  }

  Widget listOrder(OrderMenu menu) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
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
                    style: FontCollection.bodyBoldTextStyle,
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
          menu.topping.isEmpty
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 10,
                            child: Row(children: [
                              Text(
                                menu.topping.join(', '),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: smallestSize,
                                  color: Colors.black54,
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget customerPickCard(
    String name,
    String phoneNumber,
    VoidCallback onClickedContact,
  ) {
    return BuildCard(
      headerText: 'ข้อมูลผู้สั่งซื้อ',
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 5, 20),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: CollectionsColors.navy,
                radius: 35.0,
                child: Icon(
                  Icons.person,
                  color: CollectionsColors.white,
                ),
              ),
              title: Text(
                name,
                style: FontCollection.bodyTextStyle,
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                phoneNumber,
                style: FontCollection.bodyTextStyle,
              ),
              trailing: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CollectionsColors.yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 1,
                        offset: Offset(-0.5, 2))
                  ],
                ),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              onTap: onClickedContact,
            ),
          ],
        ),
      ),
      canEdit: false,
    );
  }
}
