import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/cities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class RegisterDetail extends StatefulWidget {
  String sMobile;

  RegisterDetail(this.sMobile, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterDetailPage();
  }
}

class RegisterDetailPage extends State<RegisterDetail> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  List<dynamic> genderList = ['Male', 'Female'];
  String? sGender;

  bool isDob = false, isGender = false;
  DateTime? dateTime;

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
  void register() async {
    //Input
    FormData body = FormData.fromMap({
      'name': nameCtrl.text,
      'mobile': widget.sMobile,
      'email': emailCtrl.text,
      'dob': dateTime,
      'gender': sGender,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "customer/signup", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      sp.setBool('is_login', true);
      sp.setString('user_id', result['id'].toString());
      STM().successDialogWithAffinity(ctx, message, Cities("0"));
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: null,
      backgroundColor: Clr().screenBackground,
      body: bodyLayout(),
    );
  }

  //Body3
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
            SizedBox(
              height: Dim().d40,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Create Account',
                style: Sty().extraLargeText.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
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
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Clr().grey,
                    ),
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
                readOnly: true,
                onTap: () {
                  datePicker();
                },
                controller: dobCtrl,
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
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: Clr().grey,
                      ),
                    ),
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Text(
              'Select Your Gender',
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
              'Email Address',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            TextFormField(
              controller: emailCtrl,
              cursorColor: Clr().primaryColor,
              style: Sty().mediumText,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: Sty().textFieldWhiteStyle.copyWith(
                    hintStyle: Sty().mediumText.copyWith(
                          color: Clr().lightGrey,
                        ),
                    hintText: "Enter Your Email Address",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Clr().grey,
                    ),
                  ),
              validator: (value) {
                if (value!.isEmpty || !isEmail(value)) {
                  return Str().invalidEmail;
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () {
                  // STM().successDialogWithAffinity(
                  //     ctx, "Registration successful.", SelectLocation());
                  setState(() {
                    isDob = dobCtrl.text.isEmpty ? true : false;
                    isGender = sGender == null ? true : false;
                  });
                  if (formKey.currentState!.validate() && sGender != null) {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        register();
                      }
                    });
                  }
                },
                child: Text(
                  'Sign Up',
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
