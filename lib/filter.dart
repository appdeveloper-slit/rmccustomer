import 'package:flutter/material.dart';
import 'package:rmc_customer/manager/static_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service_doctor_list.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class Filter extends StatefulWidget {
  Map<String, dynamic> data;

  Filter(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FilterPage();
  }
}

class FilterPage extends State<Filter> {
  late BuildContext ctx;
  int selectedGender = -1, selectedPrice = -1;

  Map<String, dynamic> v = {};
  String? sGender, sPrice;

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
      sGender = sp.getString("gender") ?? "";
      sGender == "Female"
          ? selectedGender = 1
          : sGender == "Male"
              ? selectedGender = 0
              : selectedGender = -1;
      sPrice = sp.getString("price") ?? "";
      sPrice == "false"
          ? selectedPrice = 1
          : sPrice == "true"
              ? selectedPrice = 0
              : selectedPrice = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, 'Filters'),
      body: bodyLayout(),
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
          Container(
            padding: EdgeInsets.only(
              top: Dim().d20,
              left: Dim().d16,
              right: Dim().d16,
              bottom: Dim().d28,
            ),
            width: double.infinity,
            color: Clr().white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gender",
                  style: Sty().largeText,
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedGender != 0) {
                              selectedGender = 0;
                            } else {
                              selectedGender = -1;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            Dim().d12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedGender == 0
                                ? Clr().primaryColor
                                : Clr().white,
                            border: Border.all(
                              color: Clr().grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              Dim().d4,
                            ),
                          ),
                          child: Text(
                            "Male Doctor",
                            style: Sty().mediumText.copyWith(
                                  color: selectedGender == 0
                                      ? Clr().white
                                      : Clr().black,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dim().d16,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedGender != 1) {
                              selectedGender = 1;
                            } else {
                              selectedGender = -1;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            Dim().d12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedGender == 1
                                ? Clr().primaryColor
                                : Clr().white,
                            border: Border.all(
                              color: Clr().grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              Dim().d4,
                            ),
                          ),
                          child: Text(
                            "Female Doctor",
                            style: Sty().mediumText.copyWith(
                                  color: selectedGender == 1
                                      ? Clr().white
                                      : Clr().black,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Text(
                  "Price",
                  style: Sty().largeText,
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedPrice != 0) {
                              selectedPrice = 0;
                            } else {
                              selectedPrice = -1;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            Dim().d12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedPrice == 0
                                ? Clr().primaryColor
                                : Clr().white,
                            border: Border.all(
                              color: Clr().grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              Dim().d4,
                            ),
                          ),
                          child: Text(
                            "Under ₹500",
                            style: Sty().mediumText.copyWith(
                                  color: selectedPrice == 0
                                      ? Clr().white
                                      : Clr().black,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dim().d16,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedPrice != 1) {
                              selectedPrice = 1;
                            } else {
                              selectedPrice = -1;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            Dim().d12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedPrice == 1
                                ? Clr().primaryColor
                                : Clr().white,
                            border: Border.all(
                              color: Clr().grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              Dim().d4,
                            ),
                          ),
                          child: Text(
                            "Above ₹500",
                            style: Sty().mediumText.copyWith(
                                  color: selectedPrice == 1
                                      ? Clr().white
                                      : Clr().black,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Dim().d250,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  if (!mounted) return;
                  setState(() {
                    sp.setString(
                        "gender",
                        selectedGender == 1
                            ? "Female"
                            : selectedGender == 0
                            ? "Male"
                            : "");
                    sp.setString(
                        "price",
                        selectedPrice == 1
                            ? "false"
                            : selectedPrice == 0
                            ? "true"
                            : "");
                    // STM().back2Previous(ctx);
                    print(v);
                    STM().replacePage(ctx, ServiceDoctorList(widget.data));
                  });
                },
                child: Text(
                  'Apply',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
