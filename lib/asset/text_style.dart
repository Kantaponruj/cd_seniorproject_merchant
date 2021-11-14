import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:flutter/material.dart';

const smallestSize = 12.0;
const regularSize = 14.0;
const mediumSize = 16.0;
const bigSize = 20.0;

const String RobotoFont = 'Roboto';
const String NotoSansFont = 'NotoSansThai';

class FontCollection {
  static const topicTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize:  bigSize,
    color: Colors.black,
  );

  static const topicBoldTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w700,
    fontSize:  bigSize,
    color: Colors.black,
  );

  static const  appbarTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: bigSize,
    color: Colors.black,
  );

  static const orderDetailHeaderTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w700,
    fontSize: bigSize,
    color: CollectionsColors.orange,
  );

  static const bodyTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: mediumSize,
    color: Colors.black,
  );

  static const whiteBodyTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: mediumSize,
    color: Colors.white,
  );

  static const bodyBoldTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w700,
    fontSize: mediumSize,
    color: Colors.black,
  );

  static const smallBodyTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: regularSize,
    color: Colors.black,
  );

  static const descriptionTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: smallestSize,
    color: Colors.black,
  );

  static const buttonTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: bigSize,
    color: Colors.black,
  );

  static const underlineButtonTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: regularSize,
    color: Colors.black,
    decoration: TextDecoration.underline,
  );

  static const underlineSmallButtonTextStyle = TextStyle(
    fontFamily: NotoSansFont,
    fontWeight: FontWeight.w400,
    fontSize: smallestSize,
    color: Colors.black,
    decoration: TextDecoration.underline,
  );
}
