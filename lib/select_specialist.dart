import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_specialist.dart';
import 'dialog/dialog_confirmation.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class SelectSpecialist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectSpecialistPage();
  }
}

class SelectSpecialistPage extends State<SelectSpecialist> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  Map<String, dynamic> v = {};

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
      'customer_id': sID,
    });
    //Output
    var result = await STM()
        .post(ctx, Str().loading, "customer/get_emergency_details", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      v = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, 'Select Specialist'),
      body: Visibility(
        visible: isLoaded,
        child: v.isNotEmpty ? bodyLayout() : Container(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return Padding(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              AwesomeDialog dialog = STM().modalDialog2(ctx,
                  dialogConfirmation(ctx, v, false), Clr().screenBackground);
              dialog.show();
            },
            child: STM().imageView({
              'url': "assets/dummy_button.png",
            }),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Expanded(
            child: v['specialities'].isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: Dim().d240,
                    ),
                    itemCount: v['specialities'].length,
                    itemBuilder: (context, index) {
                      return itemSpecialist(ctx, v['specialities'][index]);
                    },
                  )
                : STM().emptyData("No Specialist Found"),
          ),
        ],
      ),
    );
  }
}
