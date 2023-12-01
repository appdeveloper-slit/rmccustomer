import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/adapter/item_notification.dart';
import 'package:rmc_customer/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/strings.dart';

class Notifications extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return NotificationPage();
  }
}

class NotificationPage extends State<Notifications> {
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
      sp.setString("date", DateTime.now().toString());
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
      'customer_id': sID,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "customer/get_notifications", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['notifications'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, 'Notifications'),
      body: Visibility(
        visible: isLoaded,
        child: resultList.isNotEmpty
            ? bodyLayout()
            : STM().emptyData("No Notification Found"),
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
        return itemNotification(ctx, index, resultList);
      },
    );
  }
}
