import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/adapter/item_appointment.dart';
import 'package:rmc_customer/values/dimens.dart';
import 'package:rmc_customer/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/strings.dart';

class Appointment extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AppointmentPage();
  }
}

class AppointmentPage extends State<Appointment> {
  late BuildContext ctx;
  bool isLoaded = true;
  String? sID;

  List<dynamic> patientList = [];
  String? sPatient;

  List<dynamic> upcomingList = [];
  List<dynamic> completedList = [];
  int position = 0;

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
      'patient_id': sPatient,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "customer/my_appointments", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      patientList = result['patients'];
      upcomingList = result['upcoming_appointments'];
      completedList = result['completed_appointments'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(ctx).canPop()) {
          Navigator.of(ctx).pop();
        } else {
          STM().replacePage(ctx, Home());
        }
        return true;
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Clr().screenBackground,
        appBar: titleToolbarLayout(ctx, 'My Appointment'),
        body: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return Column(
      children: [
        SizedBox(
          height: Dim().d12,
        ),
        Container(
          color: Clr().white,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                hint: Text(
                  sPatient ?? 'Select Patient',
                  style: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                ),
                value: sPatient,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: Sty().mediumText,
                onChanged: (String? value) {
                  setState(() {
                    sPatient = value!;
                    getData();
                  });
                },
                items: patientList.map((value) {
                  return DropdownMenuItem<String>(
                    value: value['id'].toString(),
                    child: SizedBox(
                      width: MediaQuery.of(ctx).size.width / 3,
                      child: Text(
                        value['name'],
                        style: Sty().mediumText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Dim().d12,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    position = 0;
                  });
                },
                child: Container(
                  decoration: position == 0
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Clr().accentColor,
                              width: 2,
                            ),
                          ),
                        )
                      : null,
                  padding: EdgeInsets.all(
                    Dim().d12,
                  ),
                  child: Text(
                    "Upcoming",
                    style: Sty().mediumText.copyWith(
                          color:
                              position == 0 ? Clr().accentColor : Clr().black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    position = 1;
                  });
                },
                child: Container(
                  decoration: position == 1
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Clr().accentColor,
                              width: 2,
                            ),
                          ),
                        )
                      : null,
                  padding: EdgeInsets.all(
                    Dim().d12,
                  ),
                  child: Text(
                    "Completed",
                    style: Sty().mediumText.copyWith(
                          color:
                              position == 1 ? Clr().accentColor : Clr().black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (position == 0 ? upcomingList.isNotEmpty : completedList.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount:
                  position == 0 ? upcomingList.length : completedList.length,
              itemBuilder: (BuildContext context, int index) {
                return itemAppointment(
                    ctx, index, position == 0 ? upcomingList : completedList);
              },
            ),
          ),
        if (position == 0 ? upcomingList.isEmpty : completedList.isEmpty)
          Expanded(
            child: STM().emptyData("No Appointment Found"),
          )
      ],
    );
  }
}
