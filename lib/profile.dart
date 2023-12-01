import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Profile extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ProfilePage();
  }
}

class ProfilePage extends State<Profile> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  List<dynamic> genderList = ['Male', 'Female'];

  String? sName2, sGender, sGender2, sEmail2;

  bool isDob = false, isGender = false;
  DateTime? dateTime, dateTime2;

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

  //Get Api
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'id': sID,
    });
    //Output
    var result = await STM().post(ctx, Str().loading, "customer/profile", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      setState(() {
        isLoaded = true;
        mobileCtrl = TextEditingController(
          text: result['mobile'].toString(),
        );
        sName2 = result['name'].toString();
        nameCtrl = TextEditingController(
          text: sName2,
        );
        dateTime2 = DateTime.parse(result['dob'].toString());
        dateTime = dateTime2;
        String sDate = STM().dateFormat('dd/MM/yyyy', dateTime);
        dobCtrl = TextEditingController(
          text: sDate,
        );
        sGender2 = result['gender'];
        sGender = sGender2;
        sEmail2 = result['email'].toString();
        emailCtrl = TextEditingController(
          text: sEmail2,
        );
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  //Api method
  void update() async {
    //Input
    FormData body = FormData.fromMap({
      'id': sID,
      'name': nameCtrl.text,
      'email': emailCtrl.text,
      'dob': dateTime,
      'gender': sGender,
    });
    //Output
    var result = await STM()
        .post(ctx, Str().processing, "customer/update_profile", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialogWithReplace(ctx, message, widget);
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
      appBar: titleToolbarLayout(ctx, 'My Profile'),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
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
              'Mobile Number',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            TextFormField(
              readOnly: true,
              cursorColor: Clr().primaryColor,
              controller: mobileCtrl,
              style: Sty().mediumText,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              textInputAction: TextInputAction.done,
              decoration: Sty().textFieldWhiteStyle.copyWith(
                    hintStyle: Sty().mediumText.copyWith(
                          color: Clr().lightGrey,
                        ),
                    hintText: "Enter Your Number",
                    counterText: "",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(
                        14,
                      ),
                      child: SvgPicture.asset(
                        'assets/call.svg',
                      ),
                    ),
                    suffixIcon: TextButton(
                      onPressed: () {
                        AwesomeDialog mobileModal = STM().modalDialog(
                            ctx, MobileDialog(), Clr().screenBackground);
                        mobileModal.show();
                      },
                      child: Icon(
                        Icons.edit,
                        color: Clr().primaryColor,
                      ),
                    ),
                  ),
            ),
            SizedBox(
              height: Dim().d12,
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
                  setState(() {
                    isDob = dobCtrl.text.isEmpty ? true : false;
                    isGender = sGender == null ? true : false;
                  });
                  if (formKey.currentState!.validate() && sGender != null) {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        if (sName2 != nameCtrl.text ||
                            dateTime2 != dateTime ||
                            sGender2 != sGender ||
                            sEmail2 != emailCtrl.text) {
                          update();
                        } else {
                          STM().displayToast("Nothing has changed");
                        }
                      }
                    });
                  }
                },
                child: Text(
                  'Update Profile',
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

class MobileDialog extends StatefulWidget {

  @override
  MobileDialogState createState() => MobileDialogState();
}

class MobileDialogState extends State<MobileDialog> {
  GlobalKey<FormState> mobileFormKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController otpCtrl = TextEditingController();
  bool isOtp = false, isResend = false;
  String btnText = 'Send OTP';
  int secondsRemaining = 60;
  String sTime = '01:00';
  late Timer timer;

  late BuildContext ctx;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Padding(
      padding: EdgeInsets.all(Dim().d12),
      child: Form(
        key: mobileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Change Mobile No.',
                style: Sty().extraLargeText,
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Text(
              "New Mobile Number",
              style: Sty().mediumBoldText,
            ),
            TextFormField(
              cursorColor: Clr().primaryColor,
              controller: mobileCtrl,
              style: Sty().mediumText,
              enabled: isOtp ? false : true,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              textInputAction: TextInputAction.done,
              decoration: Sty().textFieldWhiteStyle.copyWith(
                    hintStyle: Sty().mediumText.copyWith(
                          color: Clr().lightGrey,
                        ),
                    counterText: "",
                    hintText: "Enter Mobile Number",
                  ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(value)) {
                  return Str().invalidMobile;
                } else {
                  return null;
                }
              },
            ),
            Visibility(
              visible: isOtp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Text(
                    "OTP",
                    style: Sty().mediumBoldText,
                  ),
                  TextFormField(
                    cursorColor: Clr().primaryColor,
                    controller: otpCtrl,
                    style: Sty().mediumText,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldWhiteStyle.copyWith(
                          hintStyle: Sty().mediumText.copyWith(
                                color: Clr().lightGrey,
                              ),
                          counterText: "",
                          hintText: "Enter OTP",
                        ),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Visibility(
                          visible: !isResend,
                          child: Text(
                            "OTP resend in $sTime",
                            style: Sty().mediumBoldText,
                          ),
                        ),
                        Visibility(
                          visible: isResend,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Did not receive the code ? ',
                              style: Sty().smallText,
                              children: [
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      STM()
                                          .checkInternet(ctx, widget)
                                          .then((value) {
                                        if (value) {
                                          reSendOTP();
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dim().d16,
                                        vertical: Dim().d4,
                                      ),
                                      child: Text(
                                        'Resend OTP',
                                        style: Sty().smallText.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Center(
              child: SizedBox(
                width: Dim().d200,
                child: ElevatedButton(
                  style: Sty().primaryButton,
                  onPressed: () {
                    if (mobileFormKey.currentState!.validate()) {
                      if (isOtp) {
                        if (otpCtrl.text.length == 4) {
                          STM().checkInternet(ctx, widget).then((value) {
                            if (value) {
                              changeMobile();
                            }
                          });
                        } else {
                          STM().displayToast(Str().invalidOtp);
                        }
                      } else {
                        STM().checkInternet(ctx, widget).then((value) {
                          if (value) {
                            sendOTP();
                          }
                        });
                      }
                    }
                  },
                  child: Text(
                    btnText,
                    style: Sty().largeText.copyWith(
                          color: Clr().white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendOTP() async {
    //Input
    FormData body = FormData.fromMap({
      'type': "customer",
      'page_type': "register",
      'mobile': mobileCtrl.text.trim(),
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "sendOTP", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      setState(() {
        isOtp = true;
        btnText = 'Submit';
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            if (secondsRemaining != 0) {
              setState(() {
                secondsRemaining--;
                Duration duration = Duration(seconds: secondsRemaining);
                sTime = [duration.inMinutes, duration.inSeconds]
                    .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
                    .join(':');
              });
            } else {
              setState(() {
                isResend = true;
              });
            }
          }
        });
      });
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  reSendOTP() async {
    //Input
    FormData body = FormData.fromMap({
      'type': "customer",
      'mobile': mobileCtrl.text.trim(),
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resendOTP", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      setState(() {
        otpCtrl.clear();
        isResend = false;
        secondsRemaining = 60;
      });
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  changeMobile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    //Input
    FormData body = FormData.fromMap({
      'type': "customer",
      'page_type': "change_mobile",
      'id': sp.getString("user_id"),
      'mobile': mobileCtrl.text,
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().processing, "verifyOTP", body);
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithReplace(ctx, message, Profile());
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
