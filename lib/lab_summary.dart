import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/booking.dart';
import 'package:rmc_customer/lab_detail.dart';
import 'package:rmc_customer/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coupon.dart';
import 'manager/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class LabSummary extends StatefulWidget {
  Map<String, dynamic> data;
  List<int> testList;

  LabSummary(this.data, this.testList, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LabSummaryPage();
  }
}

class LabSummaryPage extends State<LabSummary> {
  late BuildContext ctx;
  String? sID;

  Map<String, dynamic> v = {};

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
  void apply() async {
    //Input
    FormData body = FormData.fromMap({
      'coupon_type': v.containsKey('tests') ? "lab" : "dc",
      'customer_id': sID,
      'coupon_code': couponCodeCtrl.text.trim(),
      'order_amount': v['total'],
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
        v.update("grand_total", (value) => fa + (fa * 0.18).round());
        v.update("gst", (value) => (fa * 0.18).round());
      });
    }
  }

  //Api method
  void addData() async {
    if (v.containsKey('tests')) {
      String sUrl = 'https://rmcservice.in/lab_appointment?'
          'customer_id=$sID&'
          'lab_id=${v['id']}&'
          'patient_id=${v['patient_id']}&'
          'test_ids=${jsonEncode(widget.testList)}&'
          'charge=${v['total']}&'
          'coupon_code=${couponCodeCtrl.text.trim()}&'
          'gst=${(v['total'] * 0.18).round()}&'
          'discount=${v['discount']}&'
          'total=${v['grand_total']}';
      STM().redirect2page(ctx, WebViewPage(sUrl, Booking()));
    } else {
      String sUrl = 'https://rmcservice.in/diagnostic_appointment?'
          'customer_id=$sID&'
          'diagnostic_id=${v['id']}&'
          'patient_id=${v['patient_id']}&'
          'service_ids=${jsonEncode(widget.testList)}&'
          'charge=${v['total']}&'
          'coupon_code=${couponCodeCtrl.text.trim()}&'
          'gst=${(v['total'] * 0.18).round()}&'
          'discount=${v['discount']}&'
          'total=${v['grand_total']}';
      STM().redirect2page(ctx, WebViewPage(sUrl, Booking()));
    }
  }

  //Api method
  void addData2() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID,
      v.containsKey('tests') ? 'lab_id' : 'diagnostic_id': v['id'],
      'patient_id': v['patient_id'],
      v.containsKey('tests') ? 'test_ids' : 'service_ids':
          jsonEncode(widget.testList),
      'charge': v['total'],
      'coupon_code': couponCodeCtrl.text.trim(),
      'gst': (v['total'] * 0.18).round(),
      'discount': v['discount'],
      'total': v['grand_total'],
      'txn_id': 'ABCDEFG',
      'txn_date': DateTime.now(),
    });

    //Output
    var result = await STM().post(
        ctx,
        Str().loading,
        "customer/${v.containsKey('tests') ? 'book_lab' : 'book_diagnostic'}",
        body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialogWithAffinity(ctx, message, Booking());
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: (() async {
        LabDetailPage.updateStateController.sink.add("Updated");
        return true;
      }),
      child: Scaffold(
        backgroundColor: Clr().screenBackground,
        appBar: AppBar(
          backgroundColor: Clr().white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Clr().primaryColor,
          ),
          centerTitle: true,
          title: Text(
            '${v['name']}',
            style: Sty().largeText.copyWith(
                  color: Clr().primaryColor,
                ),
          ),
          leading: InkWell(
            onTap: () {
              LabDetailPage.updateStateController.sink.add("Updated");
              STM().back2Previous(ctx);
            },
            borderRadius: BorderRadius.circular(
              Dim().d100,
            ),
            child: Padding(
              padding: EdgeInsets.all(
                Dim().d16,
              ),
              child: SvgPicture.asset(
                'assets/back.svg',
                color: Clr().primaryColor,
              ),
            ),
          ),
        ),
        body: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                          'url': v['image_path'],
                          'width': Dim().d120,
                          'height': Dim().d100,
                        }),
                        SizedBox(
                          width: Dim().d12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${v['name']}',
                                style: Sty().mediumBoldText,
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Text(
                                '${v['location']}',
                                style: Sty().smallText,
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Text(
                                "${v['available_days']}\n${v['available_time']}",
                                style: Sty().smallText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                Card(
                  elevation: 2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: v.containsKey('tests')
                        ? v['tests'].length
                        : v['services'].length,
                    itemBuilder: (context, index) {
                      return itemTest(ctx, index,
                          v.containsKey('tests') ? v['tests'] : v['services']);
                    },
                  ),
                ),
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
                              v.update("grand_total", (value) => v['total'] + (v['total'] * 0.18).round());
                              v.update("gst", (value) => (v['total'] * 0.18).round());
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
                    STM().redirect2page(ctx, Coupon("lab"));
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
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: Column(
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
                              "Test Charges",
                              style: Sty().smallText,
                            ),
                            Text(
                              "₹${v['total']}",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "₹${v['grand_total']}",
                              style: Sty()
                                  .smallText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  "\u20b9${v['grand_total']}",
                  style: Sty().largeText,
                ),
                SizedBox(
                  width: Dim().d160,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      STM().checkInternet(context, widget).then((value) {
                        if (value) {
                          addData();
                        }
                      });
                    },
                    child: Text(
                      'Checkout',
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

  Widget itemTest(ctx, index, List<dynamic> list) {
    var v2 = list[index];
    return Visibility(
      visible: widget.testList.contains(v2['id']),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Dim().d4,
        ),
        padding: EdgeInsets.only(
          left: Dim().d12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${v2['name']}',
                    style: Sty().mediumText,
                  ),
                  Text(
                    '\u20b9${v2['price']}',
                    style: Sty().mediumText,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Dim().d16,
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  int total = v['total'];
                  int price = v2['price'];
                  int sub = total - price;
                  v.update('total', (value) => sub);
                  v.update('grand_total', (value) => sub);
                  widget.testList.remove(v2['id']);
                });
              },
              icon: SvgPicture.asset(
                'assets/cancel.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
