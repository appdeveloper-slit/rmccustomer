import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmc_customer/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appointment.dart';
import 'coupon.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class AppointmentCheckout extends StatefulWidget {
  Map<String, dynamic> data;

  AppointmentCheckout(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppointmentCheckoutPage();
  }
}

class AppointmentCheckoutPage extends State<AppointmentCheckout> {
  late BuildContext ctx;

  Map<String, dynamic> v = {};

  bool isLogin = false;
  String? sID;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController homeAddressCtrl = TextEditingController();
  TextEditingController contactNoCtrl = TextEditingController();

  GlobalKey<FormFieldState> couponKey = GlobalKey<FormFieldState>();
  TextEditingController couponCodeCtrl = TextEditingController();
  bool isApplied = false;
  String? sCouponMessage;

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
      sID = sp.getString("user_id") ?? "";
    });
  }

  //Api method
  void addData() async {
    String sUrl = 'https://rmcservice.in/appointment?'
        'customer_id=$sID&'
        'doctor_id=${v['id']}&'
        'patient_id=${v['patient_id']}&'
        'appointment_type_id=${v['apt_id']}&'
        'date=${v['slot_date_id']}&'
        'slot_id=${v['slot_id']}&'
        'home_address=${homeAddressCtrl.text.trim()}&'
        'contact_no=${contactNoCtrl.text.trim()}&'
        'charge=${v['charge']}&'
        'coupon_code=${couponCodeCtrl.text.trim()}&'
        'gst=${(v['charge'] * 0.18).round()}&'
        'discount=${v['discount']}&'
        'total=${v['total']}&'
        'language=${v['language']}';
    STM().redirect2page(ctx, WebViewPage(sUrl, Appointment()));
  }

  //Api method
  void addData2() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID,
      'doctor_id': v['id'],
      'patient_id': v['patient_id'],
      'appointment_type_id': v['apt_id'],
      'date': v['slot_date_id'],
      'slot_id': v['slot_id'],
      'home_address': homeAddressCtrl.text.trim(),
      'contact_no': contactNoCtrl.text.trim(),
      'charge': v['charge'],
      'coupon_code': couponCodeCtrl.text.trim(),
      'gst': v['gst'],
      'discount': v['discount'],
      'total': v['total'],
      'language': v['language'],
      'txn_id': 'ABCDEFG',
      'txn_date': DateTime.now(),
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/add_appointment", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialog(ctx, message, Appointment());
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  //Api method
  void apply() async {
    //Input
    FormData body = FormData.fromMap({
      'coupon_type': "doctor",
      'customer_id': sID,
      'coupon_code': couponCodeCtrl.text.trim(),
      'order_amount': v['charge'],
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/apply_coupon", body);
    if (!mounted) return;
    var error = result['error'];
    sCouponMessage = result['message'];
    if (!error) {
      setState(() {
        FocusManager.instance.primaryFocus!.unfocus();
        isApplied = true;
        int da = result['discounted_amount'];
        int fa = result['final_amount'];
        v.update("discount", (value) => da);
        v.update("total", (value) => fa + (fa * 0.18).round());
        v.update("gst", (value) => (fa * 0.18).round());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Checkout'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Container(
                    width: MediaQuery.of(ctx).size.width,
                    color: Clr().white,
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dim().d100,
                          ),
                          child: STM().imageView({
                            'url': v['profile_picture'],
                            'width': Dim().d80,
                            'height': Dim().d80,
                            'fit': BoxFit.cover,
                          }),
                        ),
                        SizedBox(
                          height: Dim().d2,
                        ),
                        Text(
                          '${v['name']}',
                          style: Sty().smallText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: Dim().d2,
                        ),
                        Text(
                          '${v['speciality']}',
                          style: Sty().smallText.copyWith(
                                color: Clr().lightGrey,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Wrap(
                              children: [
                                SvgPicture.asset(
                                  "assets/time.svg",
                                ),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                Text(
                                  '${v['slot_time']}',
                                  style: Sty().smallText,
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                SvgPicture.asset(
                                  "assets/date.svg",
                                ),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                Text(
                                  '${v['slot_date']}',
                                  style: Sty().smallText,
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                SvgPicture.asset(
                                  v['apt_id'] == '3'
                                      ? "assets/home.svg"
                                      : v['apt_id'] == '2'
                                          ? "assets/clinic.svg"
                                          : "assets/online.svg",
                                ),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                Text(
                                  '${v['apt_name']}',
                                  style: Sty().smallText,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dim().d32,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Consultation for : ",
                              style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
                                  ),
                              children: [
                                TextSpan(
                                  text: v['patient_name'],
                                  style: Sty().mediumText,
                                ),
                              ]),
                        ),
                        if (v['apt_id'] == '2')
                          SizedBox(
                            height: Dim().d8,
                          ),
                        if (v['apt_id'] == '2')
                          RichText(
                            text: TextSpan(
                                text: "Clinic Address : ",
                                style: Sty().mediumText.copyWith(
                                      color: Clr().primaryColor,
                                    ),
                                children: [
                                  TextSpan(
                                    text: '${v['opd_address']}',
                                    style: Sty().mediumText,
                                  ),
                                ]),
                          ),
                        if (v['apt_id'] == '3') homeVisitLayout(),
                        SizedBox(
                          height: Dim().d16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: couponKey,
                                readOnly: isApplied,
                                controller: couponCodeCtrl,
                                cursorColor: Clr().primaryColor,
                                style: Sty().mediumText,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: Sty().textFieldWhiteStyle.copyWith(
                                      hintStyle: Sty().mediumText.copyWith(
                                            color: Clr().lightGrey,
                                          ),
                                      hintText: "Enter Coupon Code",
                                    ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return Str().invalidCode;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            SizedBox(
                              width: Dim().d120,
                              child: ElevatedButton(
                                style: Sty().primaryButton,
                                onPressed: () {
                                  if (isApplied) {
                                    setState(() {
                                      sCouponMessage = null;
                                      couponCodeCtrl.clear();
                                      isApplied = false;
                                      v.update("discount", (value) => 0);
                                      v.update(
                                          "total",
                                          (value) =>
                                              v['charge'] +
                                              (v['charge'] * 0.18).round());
                                      v.update(
                                          "gst",
                                          (value) =>
                                              (v['charge'] * 0.18).round());
                                    });
                                  } else {
                                    if (couponKey.currentState!.validate()) {
                                      apply();
                                    }
                                  }
                                },
                                child: Text(
                                  isApplied ? 'UNAPPLY' : 'APPLY',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sty().smallText.copyWith(
                                        color: Clr().white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (sCouponMessage != null)
                          Text(
                            sCouponMessage ?? "",
                            style: Sty().smallText.copyWith(
                                  color: isApplied ? Clr().green2 : Clr().red,
                                ),
                          ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        InkWell(
                          onTap: () {
                            STM().redirect2page(ctx, Coupon("doctor"));
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "View all coupons",
                              style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Summary",
                              style: Sty().largeText,
                            ),
                            SizedBox(
                              height: Dim().d16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Consultation Fee",
                                  style: Sty().smallText,
                                ),
                                Text(
                                  "₹${v['charge']}",
                                  style: Sty().smallText,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "GST",
                                  style: Sty().smallText,
                                ),
                                Text(
                                  "₹${v['gst']}",
                                  style: Sty().smallText,
                                ),
                              ],
                            ),
                            if (isApplied)
                              SizedBox(
                                height: Dim().d8,
                              ),
                            if (isApplied)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Discount",
                                    style: Sty().smallText,
                                  ),
                                  Text(
                                    "-₹${v['discount']}",
                                    style: Sty().smallText,
                                  ),
                                ],
                              ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Amount Payable",
                                  style: Sty()
                                      .mediumText
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "₹${v['total']}",
                                  style: Sty()
                                      .smallText
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Container(
            color: Clr().white,
            padding: EdgeInsets.symmetric(
              vertical: Dim().d8,
              horizontal: Dim().d20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\u20b9${v['total']}",
                  style: Sty().largeText,
                ),
                SizedBox(
                  width: Dim().d160,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      if (v['apt_id'] == '3') {
                        if (formKey.currentState!.validate()) {
                          STM().checkInternet(context, widget).then((value) {
                            if (value) {
                              addData();
                            }
                          });
                        }
                      } else {
                        STM().checkInternet(context, widget).then((value) {
                          if (value) {
                            addData();
                          }
                        });
                      }
                    },
                    child: Text(
                      'CONTINUE',
                      style: Sty().largeText.copyWith(
                            color: Clr().white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget homeVisitLayout() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dim().d16,
          ),
          Text(
            'Enter Home Address :',
            style: Sty().mediumText.copyWith(
                  color: Clr().primaryColor,
                ),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          TextFormField(
            controller: homeAddressCtrl,
            cursorColor: Clr().primaryColor,
            style: Sty().mediumText,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            textInputAction: TextInputAction.next,
            decoration: Sty().textFieldWhiteStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                  hintText: "Enter Address",
                ),
            validator: (value) {
              if (value!.isEmpty) {
                return Str().invalidEmpty;
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Text(
            'Enter Contact Number :',
            style: Sty().mediumText.copyWith(
                  color: Clr().primaryColor,
                ),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          TextFormField(
            controller: contactNoCtrl,
            cursorColor: Clr().primaryColor,
            style: Sty().mediumText,
            maxLength: 10,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'\d')),
            ],
            textInputAction: TextInputAction.done,
            decoration: Sty().textFieldWhiteStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                  hintText: "Enter Mobile Number",
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
              if (value!.isEmpty || !RegExp(r'([5-9]\d{9})').hasMatch(value)) {
                return Str().invalidMobile;
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
