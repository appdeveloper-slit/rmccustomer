import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_lab.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class SelectLab extends StatefulWidget {
  String sType;

  SelectLab(this.sType, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectLabPage();
  }
}

class SelectLabPage extends State<SelectLab> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID, sType;

  List<dynamic> resultList = [];
  List<dynamic> patientList = [];

  @override
  void initState() {
    sType = widget.sType;
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
      'customer_id': sID ?? "",
    });
    //Output
    var result = await STM().post(ctx, Str().loading,
        "customer/${sType == 'lab' ? 'get_labs' : 'get_diagnostics'}", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result[sType == 'lab' ? 'labs' : 'diagnostics'];
      patientList = result['patients'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, sType == 'lab' ? 'Labs' : 'Diagnostics Center'),
      body: Visibility(
        visible: isLoaded,
        child: resultList.isNotEmpty
            ? bodyLayout()
            : STM().emptyData(
                "No ${sType == 'lab' ? 'Lab' : 'Diagnostics Center'} Found"),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Dim().pp,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 262,
      ),
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        return itemLab(ctx, index, resultList, patientList);
      },
    );
  }
}
