import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/contact_us.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class BookingDetail extends StatefulWidget {
  Map<String, dynamic> data;

  BookingDetail(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BookingDetailPage();
  }
}

class BookingDetailPage extends State<BookingDetail> {
  late BuildContext ctx;
  Map<String, dynamic> v = {};

  @override
  void initState() {
    v = widget.data;
    super.initState();
  }

  //Api method
  void cancel() async {
    //Input
    FormData body = FormData.fromMap({
      'appt_id': v['id'],
    });
    //Output
    var result = await STM()
        .post(ctx, Str().loading, "customer/cancel_lab_booking", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialog(ctx, message, widget);
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
      appBar: titleToolbarLayout(ctx, 'Booking Details'),
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
                  STM().imageView({
                    'url': v['lab_image_path'],
                    'width': Dim().d120,
                    'height': Dim().d120,
                  }),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${v['lab_name']}',
                          style: Sty().mediumText,
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          '${v['lab_location']}',
                          style: Sty().mediumText,
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          "Patient Name : ${v['patient_name']}",
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
                            "Test charges",
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
                  if (v['status'] != 0)
                    Padding(
                      padding: EdgeInsets.only(
                        left: Dim().d12,
                        right: Dim().d12,
                        bottom: Dim().d12,
                      ),
                      child: InkWell(
                        onTap: () {
                          STM().openWeb(v['invoice']);
                        },
                        child: Text(
                          "View Invoice",
                          style: Sty().smallText.copyWith(
                                color: Clr().accentColor,
                              ),
                        ),
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
                          "Lab Address",
                          style: Sty().mediumText,
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
                    child: Html(
                      data: v['lab_address'],
                      shrinkWrap: true,
                      style: {
                        "body": Style(
                          margin: Margins.zero,
                          // padding: EdgeInsets.zero,
                          fontFamily: 'Regular',
                          letterSpacing: 0.5,
                          color: Clr().black,
                          fontSize: FontSize(16.0),
                        ),
                      },
                      // onLinkTap: (url, context, attrs, element) {
                      //   STM().openWeb(url!);
                      // },
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Booked On",
                            style: Sty().smallText,
                          ),
                        ),
                        Text(
                          ":",
                          style: Sty().smallText,
                        ),
                        Expanded(
                          child: Text(
                            "${v['date']}",
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
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (v['status'] == 1 &&
              v['perscription'] != null &&
              v['perscription'].isNotEmpty)
            SizedBox(
              height: Dim().d20,
            ),
          if (v['status'] == 1 &&
              v['perscription'] != null &&
              v['perscription'].isNotEmpty)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: Dim().d300,
                child: ElevatedButton(
                  style: Sty().primaryButton,
                  onPressed: () {
                    STM().openWeb(v['perscription']);
                  },
                  child: Text(
                    'Download Report',
                    style: Sty().largeText.copyWith(
                          color: Clr().white,
                        ),
                  ),
                ),
              ),
            ),
          if (v['status'] == 0)
            SizedBox(
              height: Dim().d20,
            ),
          if (v['status'] == 0)
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: Dim().d300,
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
            ),
          // SizedBox(
          //   height: Dim().d12,
          // ),
          // Text(
          //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been",
          //   style: Sty().smallText,
          //   textAlign: TextAlign.center,
          // ),
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
