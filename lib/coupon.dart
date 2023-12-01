import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_coupon.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/strings.dart';

class Coupon extends StatefulWidget {
  String sType;

  Coupon(this.sType, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CouponPage();
  }
}

class CouponPage extends State<Coupon> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  List<dynamic> resultList = [];

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id") ?? "";
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData();
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'coupon_type': widget.sType,
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/get_coupons", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['coupons'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, 'Coupons'),
      body: Visibility(
        visible: isLoaded,
        child: resultList.isNotEmpty
            ? bodyLayout()
            : STM().emptyData("No Coupon Found"),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Dim().pp,
        vertical: Dim().d8,
      ),
      itemCount: resultList.length,
      itemBuilder: (BuildContext context, int index) {
        return itemCoupon(ctx, index, resultList);
      },
    );
  }
}
