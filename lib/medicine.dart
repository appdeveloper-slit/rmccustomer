import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmc_customer/home.dart';
import 'package:rmc_customer/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class Medicine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MedicinePage();
  }
}

class MedicinePage extends State<Medicine> {
  late BuildContext ctx;
  String? sID;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController messageCtrl = TextEditingController();

  String? sCertificateImg;
  bool isCertificate = false;

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
    });
  }

  //Api method
  void addData() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID,
      'doctor_name': nameCtrl.text.trim(),
      'registration_certificate': sCertificateImg,
      'message': messageCtrl.text.trim()
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/add_medicine", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialogWithAffinity(ctx,message,Home());
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Medicine'),
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
              'Want To Order Medicines In Bulk?',
              style: Sty().extraLargeText.copyWith(
                    color: Clr().primaryColor,
                  ),
            ),
            SizedBox(
              height: Dim().d32,
            ),
            Text(
              'Name of Doctor',
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
                    hintText: "Enter Doctor Name",
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
              'Registration Certificate',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            InkWell(
              onTap: () {
                filePicker();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Clr().white,
                  border: isCertificate
                      ? Border.all(
                          color: Clr().errorRed,
                        )
                      : Border.all(
                          color: Clr().lightGrey,
                        ),
                ),
                padding: const EdgeInsets.all(
                  10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: sCertificateImg != null
                          ? Text(
                              'File Selected',
                              style: Sty().mediumText,
                            )
                          : Text(
                              'Upload Certificate',
                              style: Sty().mediumText.copyWith(
                                    color: Clr().lightGrey,
                                  ),
                            ),
                    ),
                    SizedBox(
                      width: Dim().d16,
                    ),
                    SvgPicture.asset(
                      "assets/export.svg",
                    ),
                    SizedBox(
                      width: Dim().d16,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Text(
              'Message (Write medicine name & quantity)',
              style: Sty().largeText,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            TextFormField(
              controller: messageCtrl,
              cursorColor: Clr().primaryColor,
              style: Sty().mediumText,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              maxLines: 5,
              decoration: Sty().textFieldWhiteStyle,
              validator: (value) {
                if (value!.isEmpty) {
                  return Str().invalidEmpty;
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
                    isCertificate = sCertificateImg == null ? true : false;
                  });
                  if (formKey.currentState!.validate() && !isCertificate) {
                    STM().checkInternet(context, widget).then((value) {
                      if (value) {
                        addData();
                      }
                    });
                  }
                },
                child: Text(
                  'Submit',
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

  //File uploading
  void filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg']);
    if (result != null) {
      final image = File(result.files.single.path.toString()).readAsBytesSync();
      setState(() {
        sCertificateImg = base64Encode(image).toString();
        isCertificate = false;
      });
    }
  }
}