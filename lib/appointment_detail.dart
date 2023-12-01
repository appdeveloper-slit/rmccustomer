import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rmc_customer/video_call/outgoing_call.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class AppointmentDetail extends StatefulWidget {
  Map<String, dynamic> data;

  AppointmentDetail(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppointmentDetailPage();
  }
}

class AppointmentDetailPage extends State<AppointmentDetail> {
  late BuildContext ctx;
  String? sID;

  Map<String, dynamic> v = {};

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
      bool isLogin = sp.getBool("is_login") ?? false;
      if (isLogin) {
        sID = sp.getString("user_id");
      }
    });
  }

  //Api method
  void cancel() async {
    //Input
    FormData body = FormData.fromMap({
      'appt_id': v['id'],
    });
    //Output
    var result = await STM()
        .post(ctx, Str().loading, "customer/cancel_appointment", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialog(ctx, message, widget);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  //Api method
  void getToken(isRMCDoctor) async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID,
      'doctor_id': isRMCDoctor ? '1' : v['doctor_id'],
      'id': v['id'],
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/agora/token", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      Map<String, dynamic> map = {
        'id': sID,
        'doctor_id': isRMCDoctor ? '1' : v['doctor_id'],
        'name': isRMCDoctor ? 'RMC Doctor' : v['doctor_name'],
        'image': isRMCDoctor ? '' : v['doctor_profile_pic'],
        'channel': result['channel'],
        'token': result['token'],
        'is_rmc_doctor': isRMCDoctor,
      };
      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (context) => OutgoingCall(map),
        ),
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
      //resizeToAvoidBottomInset: false,
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Appointment Details'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().d12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Container(
              color: Clr().white,
              padding: EdgeInsets.all(
                Dim().d12,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dim().d100,
                    ),
                    child: STM().imageView({
                      'url': v['doctor_profile_pic'],
                      'width': Dim().d120,
                      'height': Dim().d120,
                      'fit': BoxFit.cover,
                    }),
                  ),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Appt. ID : #${v['appointment_id']}",
                          style: Sty().mediumText.copyWith(
                                color: Clr().accentColor,
                              ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          '${v['doctor_name']}',
                          style: Sty().mediumText,
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          '${v['doctor_speciality']}',
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Card(
            elevation: 2,
            child: Container(
              color: Clr().white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Dim().d12,
                      Dim().d12,
                      Dim().d12,
                      Dim().d4,
                    ),
                    child: Text(
                      "Payment Details",
                      style: Sty().mediumText,
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Consultation Fee",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        Expanded(
                          child: Text(
                            "₹${v['charge']}",
                            style: Sty().smallText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "GST",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        Expanded(
                          child: Text(
                            "₹${v['gst']}",
                            style: Sty().smallText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Discount",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        Expanded(
                          child: Text(
                            "₹${v['discount']}",
                            style: Sty().smallText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dim().d12,
                      right: Dim().d12,
                      bottom: Dim().d12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total Amount",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        Expanded(
                          child: Text(
                            "₹${v['total']}",
                            style: Sty().smallText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (v['status'] != 0)
                  //   Padding(
                  //     padding: EdgeInsets.only(
                  //       left: Dim().d12,
                  //       right: Dim().d12,
                  //       bottom: Dim().d12,
                  //     ),
                  //     child: InkWell(
                  //       onTap: () {
                  //         STM().openWeb(v['invoice']);
                  //       },
                  //       child: Text(
                  //         "View Invoice",
                  //         style: Sty().smallText.copyWith(
                  //               color: Clr().accentColor,
                  //             ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
          if (v['appointment_type_id'] == 3)
            SizedBox(
              height: Dim().d12,
            ),
          if (v['appointment_type_id'] == 3)
            Card(
              elevation: 2,
              child: Container(
                color: Clr().white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dim().d12,
                        Dim().d12,
                        Dim().d12,
                        Dim().d4,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/address.svg",
                            width: Dim().d32,
                          ),
                          SizedBox(
                            width: Dim().d16,
                          ),
                          Text(
                            "Home Address",
                            style: Sty().mediumText,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    InkWell(onTap: (){
                      // STM().openWeb(url!);
                    },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12,
                        ),
                        child: Html(
                          data: '${v['home_address']}',
                          shrinkWrap: true,
                          style: {
                            "body": Style(
                              margin: Margins.zero,
                              fontFamily: 'Regular',
                              letterSpacing: 0.5,
                              color: Clr().black,
                              fontSize: FontSize(16.0),
                            ),
                          },
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.only(
                        left: Dim().d12,
                        right: Dim().d12,
                        bottom: Dim().d12,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/accent_call.svg",
                            width: Dim().d32,
                          ),
                          SizedBox(
                            width: Dim().d8,
                          ),
                          Expanded(
                            child: Text(
                              "Doctor Contact: ${v['doctor_contact']}",
                              style: Sty().smallText,
                            ),
                          ),
                          SizedBox(
                            width: Dim().d4,
                          ),
                          InkWell(
                            onTap: () {
                              STM().openDialer(v['doctor_contact'].toString());
                            },
                            child: SvgPicture.asset(
                              "assets/dial_call.svg",
                              height: Dim().d32,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          if (v['appointment_type_id'] == 2)
            SizedBox(
              height: Dim().d12,
            ),
          if (v['appointment_type_id'] == 2)
            Card(
              elevation: 2,
              child: Container(
                color: Clr().white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dim().d12,
                        Dim().d12,
                        Dim().d12,
                        Dim().d4,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/address.svg",
                            width: Dim().d32,
                          ),
                          SizedBox(
                            width: Dim().d16,
                          ),
                          Text(
                            "Clinic Address",
                            style: Sty().mediumText,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                      child: Text('${v['doctor_opd_address']}',style: Sty().mediumText),
                    ),
                    SizedBox(height: Dim().d12,),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: Dim().d12,
                    //     right: Dim().d12,
                    //     bottom: Dim().d12,
                    //   ),
                    //   child: Html(
                    //     data: 'ggg',
                    //     shrinkWrap: true,
                    //     style: {
                    //       "body": Style(
                    //         margin: Margins.zero,
                    //         // padding: EdgeInsets.zero,
                    //         fontFamily: 'Regular',
                    //         letterSpacing: 0.5,
                    //         color: Clr().black,
                    //         fontSize: FontSize(16.0),
                    //       ),
                    //     },
                    //     // onLinkTap: (url, context, attrs, element) {
                    //     //   STM().openWeb(url!);
                    //     // },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          SizedBox(
            height: Dim().d12,
          ),
          Card(
            elevation: 2,
            child: Container(
              color: Clr().white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Dim().d12,
                      Dim().d12,
                      Dim().d12,
                      Dim().d4,
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/calendar.svg",
                          width: Dim().d32,
                        ),
                        SizedBox(
                          width: Dim().d16,
                        ),
                        Text(
                          "Appointment Details",
                          style: Sty().mediumText,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  if (v['appt_type'] != 'emergency')
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dim().d12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Date",
                              style: Sty().smallText,
                            ),
                          ),
                          Text(
                            ":",
                            style: Sty().smallText,
                          ),
                          SizedBox(
                            width: Dim().d40,
                          ),
                          Expanded(
                            child: Text(
                              '${v['date']}',
                              style: Sty().smallText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (v['appt_type'] != 'emergency')
                    SizedBox(
                      height: Dim().d8,
                    ),
                  if (v['appt_type'] != 'emergency')
                    if (v['slot']['slot'] != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12,
                        ),
                        child: Row(
                          children: [
                            if (v['slot']['slot'] != null)
                              Expanded(
                                child: Text(
                                  "Time",
                                  style: Sty().smallText,
                                ),
                              ),
                            if (v['slot']['slot'] != null)
                              Text(
                                ":",
                                style: Sty().smallText,
                              ),
                            if (v['slot']['slot'] != null)
                              SizedBox(
                                width: Dim().d40,
                              ),
                            Expanded(
                              child: Text(
                                '${v['slot']['slot'] != null ? v['slot']['slot'] : ''}',
                                style: Sty().smallText,
                              ),
                            ),
                          ],
                        ),
                      ),
                  if (v['appt_type'] != 'emergency')
                    SizedBox(
                      height: Dim().d8,
                    ),
                  if (v['appt_type'] != 'emergency')
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dim().d12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Language",
                              style: Sty().smallText,
                            ),
                          ),
                          Text(
                            ":",
                            style: Sty().smallText,
                          ),
                          SizedBox(
                            width: Dim().d40,
                          ),
                          Expanded(
                            child: Text(
                              '${v['appointment_language']}',
                              style: Sty().smallText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (v['appt_type'] != 'emergency')
                    SizedBox(
                      height: Dim().d8,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Type",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        SizedBox(
                          width: Dim().d40,
                        ),
                        Expanded(
                          child: Text(
                            '${v['appointment_type_text']}',
                            style: Sty().smallText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dim().d12,
                      right: Dim().d12,
                      bottom: Dim().d12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Status",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        SizedBox(
                          width: Dim().d40,
                        ),
                        Expanded(
                          child: Text(
                            '${v['status_text']}',
                            style: Sty().smallText.copyWith(
                                  color: v['status'] == 1
                                      ? Clr().green2
                                      : v['status'] == 2
                                          ? Clr().errorRed
                                          : Clr().accentColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //When apt type is online & apt is pending & call to apt doctor & slot time is greater than current time
          //When user call to rmc doctor this button hide OR when doctor is getting 0
          if (v['status'] == 0 &&
              v['appointment_type_id'] == 1 &&
              (v['slot'] != null ? v['slot']['is_video_call'] : true) &&
              v['doctor_id'] != 1)
            v['appt_type'] == 'emergency' ? Container() :  Container(
              width: MediaQuery.of(ctx).size.width / 1.1,
              margin: EdgeInsets.only(
                top: Dim().d20,
              ),
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  await Permission.camera.request();
                  await Permission.microphone.request();
                  getToken(false);
                },
                child: Text(
                  'Video call to appointed doctor',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
          //When apt type is online & apt is pending & call to rmc doctor & slot time is greater than current time
          if (v['status'] == 0 &&
              v['appointment_type_id'] == 1 &&
              (v['slot'] != null ? v['slot']['is_video_call'] : true))
            Container(
              width: MediaQuery.of(ctx).size.width / 1.1,
              margin: EdgeInsets.only(
                top: Dim().d12,
              ),
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  if (v['doctor_id'] != 1) {
                    showDialog(
                      context: ctx,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Clr().screenBackground,
                          contentPadding: EdgeInsets.all(
                            Dim().pp,
                          ),
                          title: Text(
                            "Confirmation",
                            style: Sty().largeText.copyWith(
                                  color: Clr().errorRed,
                                ),
                          ),
                          content: Text(
                            "Are you sure you want to call with RMC Doctor?",
                            style: Sty().smallText,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await Permission.camera.request();
                                await Permission.microphone.request();
                                if (!mounted) return;
                                STM().back2Previous(ctx);
                                getToken(true);
                              },
                              child: Text(
                                "Yes",
                                style: Sty()
                                    .smallText
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                STM().back2Previous(ctx);
                              },
                              child: Text(
                                "No",
                                style: Sty()
                                    .smallText
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await Permission.camera.request();
                    await Permission.microphone.request();
                    getToken(true);
                  }
                },
                child: Text(
                  'Video call to RMC doctor',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
          //When apt type is online & apt is pending & call to rmc doctor & slot time is greater than current time
          // if (v['status'] == 0 &&
          //         v['appointment_type_id'] == 1 &&
          //         v['slot'] != null
          //     ? v['slot']['is_video_call']
          //     : true)
          //   Container(
          //     margin: EdgeInsets.fromLTRB(
          //       Dim().d8,
          //       Dim().d4,
          //       Dim().d8,
          //       Dim().d0,
          //     ),
          //     child: Text(
          //       "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          //       style: Sty().smallText,
          //     ),
          //   ),
          //When apt is completed & prescription already added
          if (v['status'] == 1 &&
              v['perscription'] != null &&
              v['perscription'].isNotEmpty)
            Container(
              width: MediaQuery.of(ctx).size.width / 1.1,
              margin: EdgeInsets.only(
                top: Dim().d20,
              ),
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () {
                  STM().openWeb(v['perscription']);
                },
                child: Text(
                  'Download Prescription',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
          if (v['status'] == 0)
            Container(
              width: MediaQuery.of(ctx).size.width / 1.1,
              margin: EdgeInsets.only(
                top: Dim().d20,
              ),
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () {
                  showDialog(
                    context: ctx,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Clr().screenBackground,
                        contentPadding: EdgeInsets.all(
                          Dim().pp,
                        ),
                        title: Text(
                          "Confirmation",
                          style: Sty().largeText.copyWith(
                                color: Clr().errorRed,
                              ),
                        ),
                        content: Text(
                          "Are you sure you want to cancel?",
                          style: Sty().smallText,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              cancel();
                            },
                            child: Text(
                              "Yes",
                              style: Sty()
                                  .smallText
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              STM().back2Previous(ctx);
                            },
                            child: Text(
                              "No",
                              style: Sty()
                                  .smallText
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Cancel',
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                ),
              ),
            ),
          SizedBox(
            height: Dim().d12,
          ),
          InkWell(
            onTap: () {
              STM().openDialer('8104690763');
            },
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Contact Support",
                style: Sty().extraLargeText.copyWith(
                      color: Clr().primaryColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
