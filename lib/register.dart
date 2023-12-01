import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'verification.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPage();
  }
}

class RegisterPage extends State<Register> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();

  //Api method
  void sendOtp() async {
    //Input
    FormData body = FormData.fromMap({
      'type': "customer",
      'page_type': "register",
      'mobile': mobileCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "sendOTP", body);
    if (!mounted) return;
    if (!result['error']) {
      STM().redirect2page(
        ctx,
        Verification("reg", mobileCtrl.text.toString()),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      ////resizeToAvoidBottomInset: false,
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
              height: Dim().d80,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Sign Up',
                style: Sty().extraLargeText,
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Text(
              'Mobile Number',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d8,
            ),
            TextFormField(
              cursorColor: Clr().primaryColor,
              controller: mobileCtrl,
              style: Sty().mediumText,
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
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () {
                  // STM().redirect2page(
                  //   ctx,
                  //   const Verification("register", "8888888881"),
                  // );
                  if (formKey.currentState!.validate()) {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        sendOtp();
                      }
                    });
                  }
                },
                child: Text(
                  'Send OTP',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  STM().replacePage(ctx, Login());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Sty().mediumText,
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: Sty().mediumBoldText.copyWith(
                              color: Clr().accentColor,
                            ),
                      ),
                    ],
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
