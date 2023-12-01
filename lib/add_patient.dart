import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmc_customer/emergency_checkout.dart';
import 'package:rmc_customer/lab_detail.dart';
import 'package:rmc_customer/select_slot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class AddPatient extends StatefulWidget {
  String sType;

  AddPatient(this.sType, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddPatientPage();
  }
}

class AddPatientPage extends State<AddPatient> {
  late BuildContext ctx;
  bool isLogin = false;
  String? sType, sID;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();

  List<dynamic> genderList = ['Male', 'Female'];
  String? sGender;

  List<dynamic> relationList = [
    {'id': "1", 'name': "Father"},
    {'id': "3", 'name': "Brother"},
    {'id': "4", 'name': "Sister"},
    {'id': "2", 'name': "Mother"},
    {'id': "5", 'name': "Husband"},
    {'id': "6", 'name': "Wife"},
    {'id': "7", 'name': "Daughter"},
    {'id': "8", 'name': "Son"},
    {'id': "9", 'name': "Other"}
  ];
  String? sRelation;

  bool isDob = false, isGender = false, isRelation = false;
  DateTime? dateTime;

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
    });
  }

  //Date picker
  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      //firstDate: DateTime.now().subtract(Duration(days: 1)),
      //Disabled future date
      //lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateTime = picked;
        String s = STM().dateFormat('dd/MM/yyyy', dateTime);
        dobCtrl = TextEditingController(text: s);
        isDob = false;
      });
    }
  }

  //Api method
  void addData() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID,
      'name': nameCtrl.text,
      'dob': dateTime,
      'gender': sGender,
      'relation_id': sRelation
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/add_patient", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      switch (sType) {
        case "slot":
          SelectSlotPage.controller.sink
              .add({"id": result['id'], "name": nameCtrl.text.trim()});
          break;
        case "lab":
          LabDetailPage.controller.sink
              .add({"id": result['id'], "name": nameCtrl.text.trim()});
          break;
        case "emergency":
          EmergencyCheckoutPage.controller.sink
              .add({"id": result['id'], "name": nameCtrl.text.trim()});
          break;
      }
      STM().displayToast(message);
      STM().back2Previous(ctx);
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Add Patient'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            TextFormField(
              controller: nameCtrl,
              cursorColor: Clr().primaryColor,
              style: Sty().mediumText,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: Sty().textFieldWhiteStyle.copyWith(
                    hintStyle: Sty().mediumText.copyWith(
                          color: Clr().lightGrey,
                        ),
                    hintText: "Enter Your Name",
                  ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Str().invalidName;
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Text(
              'Date Of Birth',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Container(
              decoration: BoxDecoration(
                color: Clr().white,
                border: isDob
                    ? Border.all(
                        color: Clr().errorRed,
                      )
                    : Border.all(
                        color: Clr().lightGrey,
                      ),
              ),
              child: TextFormField(
                onTap: () {
                  datePicker();
                },
                controller: dobCtrl,
                readOnly: true,
                cursorColor: Clr().primaryColor,
                style: Sty().mediumText,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: Sty().textFieldWhiteStyle.copyWith(
                      enabledBorder: InputBorder.none,
                      hintStyle: Sty().mediumText.copyWith(
                            color: Clr().lightGrey,
                          ),
                      hintText: "Select Date",
                    ),
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Text(
              'Gender',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Container(
              decoration: BoxDecoration(
                color: Clr().white,
                border: isGender
                    ? Border.all(
                        color: Clr().errorRed,
                      )
                    : Border.all(
                        color: Clr().lightGrey,
                      ),
              ),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    hint: Text(
                      sGender ?? 'Select Gender',
                      style: Sty().mediumText.copyWith(
                            color: Clr().lightGrey,
                          ),
                    ),
                    value: sGender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: Sty().mediumText,
                    onChanged: (String? value) {
                      setState(() {
                        sGender = value!;
                        isGender = false;
                      });
                    },
                    items: genderList.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Sty().mediumText,
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
            Text(
              'Relation',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Container(
              decoration: BoxDecoration(
                color: Clr().white,
                border: isRelation
                    ? Border.all(
                        color: Clr().errorRed,
                      )
                    : Border.all(
                        color: Clr().lightGrey,
                      ),
              ),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    onTap: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    hint: Text(
                      sRelation ?? 'Select Relation',
                      style: Sty().mediumText.copyWith(
                            color: Clr().lightGrey,
                          ),
                    ),
                    value: sRelation,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: Sty().mediumText,
                    onChanged: (String? value) {
                      setState(() {
                        sRelation = value!;
                        isRelation = false;
                      });
                    },
                    items: relationList.map((value) {
                      return DropdownMenuItem<String>(
                        value: value['id'].toString(),
                        child: Text(
                          value['name'],
                          style: Sty().mediumText,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () {
                  setState(() {
                    isDob = dobCtrl.text.isEmpty ? true : false;
                    isGender = sGender == null ? true : false;
                    isRelation = sRelation == null ? true : false;
                  });
                  if (formKey.currentState!.validate() &&
                      sGender != null &&
                      sRelation != null) {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        addData();
                      }
                    });
                  }
                },
                child: Text(
                  'ADD',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
