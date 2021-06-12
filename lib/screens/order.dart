import 'package:cs_senior_project/component/mainAppBar.dart';
import 'package:cs_senior_project/component/roundAppBar.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(
        appBarTitle: 'คำสั่งซื้อ',
      ),
      body: Container(
          child: Column(
        children: [
          buildStoreCard(),
          buildStoreCard(),
        ],
      )),
    );
  }

  Widget buildStoreCard() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 35.0,
                        child: Text('Name'),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Name',
                        style: TextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Detailed',
                          style: TextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text('เวลาจัดส่ง เวลาปัจจุบัน'),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        'ราคา บาท',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
