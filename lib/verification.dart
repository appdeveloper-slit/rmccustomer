import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'manager/static_method.dart';
import 'register_detail.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Verification extends StatefulWidget {
  String sType, sMobile;

  Verification(this.sType, this.sMobile, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VerificationPage();
  }
}

class VerificationPage extends State<Verification> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool isResend = false;
  int secondsRemaining = 60;
  String sTime = '01:00';
  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  //Api method
  resend() async {
    //Input
    FormData body = FormData.fromMap({
      'type': "customer",
      'mobile': widget.sMobile,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resendOTP", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      function() {
        otpCtrl.clear();
      }

      STM().successWithButton(ctx, message, function).show();
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  //Api method
  verify() async {
    //Input
    FormData body = FormData.fromMap({
      'type': "customer",
      'page_type': widget.sType,
      'mobile': widget.sMobile,
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().verifying, "verifyOTP", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      if (widget.sType == "login") {
        sp.setBool('is_login', true);
        sp.setString('user_id', result['id'].toString());
        sp.setString('city_id', result['city_id'].toString());
        sp.setString('city_name', result['city_name'].toString());
        sp.setString('latitude', result['latitude'].toString());
        sp.setString('longitude', result['longitude'].toString());
        // sp.setString('city_id', "1");
        // sp.setString('city_name', "Mumbai");
        // sp.setString("latitude", "19.209400");
        // sp.setString("longitude", "73.093948");
        STM().finishAffinity(ctx, Home());
        STM().displayToast("Login successful");
      } else {
        STM().finishAffinity(ctx, RegisterDetail(widget.sMobile));
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Clr().screenBackground,
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        children: [
          SizedBox(
            height: Dim().d80,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'OTP Verification',
              style: Sty().extraLargeText.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Text(
            "Code is sent to +91 ${widget.sMobile}",
            style: Sty().mediumText,
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dim().d32,
            ),
            child: PinCodeTextField(
              controller: otpCtrl,
              errorAnimationController: errorController,
              appContext: context,
              enableActiveFill: true,
              textStyle: Sty().extraLargeText,
              length: 4,
              obscureText: false,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'\d')),
              ],
              animationType: AnimationType.scale,
              cursorColor: Clr().accentColor,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldWidth: Dim().d60,
                fieldHeight: Dim().d56,
                activeColor: Clr().accentColor,
                activeFillColor: Clr().transparent,
                inactiveFillColor: Clr().transparent,
                inactiveColor: Clr().errorRed,
                errorBorderColor: Clr().errorRed,
                selectedFillColor: Clr().transparent,
                selectedColor: Clr().primaryColor,
              ),
              animationDuration: const Duration(milliseconds: 200),
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
                  return "";
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Column(
            children: [
              Visibility(
                visible: !isResend,
                child: Text('I didn’t receive a code! ($sTime)',
                    style: Sty().mediumText),
              ),
              Visibility(
                visible: isResend,
                child: GestureDetector(
                  onTap: () {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        resend();
                      }
                    });
                  },
                  child: Text(
                    'Resend OTP',
                    style: Sty().mediumBoldText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: Dim().d16,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: Sty().primaryButton,
              onPressed: () {
                if (otpCtrl.text.length > 3) {
                  STM().checkInternet(context, widget).then((value) {
                    if (value) {
                      verify();
                    }
                  });
                } else {
                  STM().displayToast(Str().invalidOtp);
                }
              },
              child: Text(
                'Verify',
                style: Sty().largeText.copyWith(
                      color: Clr().white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
