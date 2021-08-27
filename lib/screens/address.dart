import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:cs_senior_project_merchant/component/roundAppBar.dart';
import 'package:cs_senior_project_merchant/notifiers/address_notifier.dart';
import 'package:cs_senior_project_merchant/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key key, this.storeId}) : super(key: key);
  final String storeId;

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    AddressNotifier addressNotifier =
        Provider.of<AddressNotifier>(context, listen: false);
    getAddress(addressNotifier, widget.storeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddressNotifier addressNotifier = Provider.of<AddressNotifier>(context);

    return SafeArea(
      child: Scaffold(
        appBar: RoundedAppBar(
          appBarTittle: 'ที่อยู่ของคุณ',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          alignment: Alignment.center,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: addressNotifier.addressList.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          title: Text(
                            addressNotifier.addressList[index].addressName,
                            style: FontCollection.bodyTextStyle,
                          ),
                          subtitle: AutoSizeText(
                            addressNotifier.addressList[index].address,
                            maxLines: 2,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Theme.of(context).buttonColor),
                  child: Text(
                    'เพิ่มที่อยู่ใหม่',
                    style: FontCollection.buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
