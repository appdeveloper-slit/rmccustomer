import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapter/item_service_doctor.dart';
import 'filter.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class ServiceDoctorList extends StatefulWidget {
  Map<String, dynamic> data;
  ServiceDoctorList(this.data,  {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ServiceDoctorListPage();
  }
}

class ServiceDoctorListPage extends State<ServiceDoctorList> {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

  bool isLoaded = false;
  String? sID, sGender, sPrice;

  List<dynamic> resultList = [];

  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    v = widget.data;
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id") ?? "";
      sGender = sp.getString("gender") ?? "";
      sPrice = sp.getString("price") ?? "";
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          if (v.containsKey('id')) {
            getData();
          } else if (v.containsKey('search')) {
            if (v['search'].isNotEmpty) {
              searchCtrl = TextEditingController(text: v['search']);
              searchData();
            }
          }
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID ?? "",
      'appointment_type': v['apt_id'],
      'speciality_id': v['id'],
      'gender': sGender,
      'price': sPrice,
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/get_doctors", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      setState(() {
        isLoaded = true;
        resultList = result['doctors'];
      });
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  //Api Method
  searchData() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID ?? "",
      'keyword': searchCtrl.text.trim(),
      'gender': sGender,
      'price': sPrice,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "customer/search", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      setState(() {
        isLoaded = true;
        resultList = result['doctors'];
      });
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: AppBar(
        backgroundColor: Clr().white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Clr().primaryColor,
        ),
        centerTitle: true,
        title: v.containsKey('name')
            ? Text(
                v['name'],
                style: Sty().extraLargeText.copyWith(
                      color: Clr().primaryColor,
                    ),
              )
            : TextFormField(
                controller: searchCtrl,
                cursorColor: Clr().primaryColor,
                style: Sty().mediumText,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: Sty().textFieldWithoutStyle.copyWith(
                      hintStyle: Sty().mediumText.copyWith(
                            color: Clr().lightGrey,
                          ),
                      hintText: "Search Doctor",
                    ),
                onFieldSubmitted: (v) {
                  STM().checkInternet(ctx, widget).then((value) {
                    if (value) {
                      searchData();
                    }
                  });
                },
              ),
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          borderRadius: BorderRadius.circular(
            Dim().d100,
          ),
          child: Padding(
            padding: EdgeInsets.all(
              Dim().d16,
            ),
            child: SvgPicture.asset(
              'assets/back.svg',
              color: Clr().primaryColor,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (v.containsKey('search')) {
                v.update("search", (value) => searchCtrl.text.trim());
              }
              STM().redirect2page(ctx, Filter(widget.data));
            },
            borderRadius: BorderRadius.circular(
              Dim().d100,
            ),
            child: Padding(
              padding: EdgeInsets.all(
                Dim().d16,
              ),
              child: SvgPicture.asset(
                'assets/filter.svg',
                height: Dim().d32,
              ),
            ),
          ),
        ],
      ),
      body: Visibility(
        visible: isLoaded,
        child: resultList.isNotEmpty
            ? bodyLayout()
            : STM().emptyData("No Doctor Found"),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: Dim().d8,
      ),
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        return itemServiceDoctor(
            ctx, index, resultList, v['apt_id'], v['apt_name']);
      },
    );
  }
}
