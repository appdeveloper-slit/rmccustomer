import 'package:flutter/material.dart';
import 'package:rmc_customer/adapter/item_summary.dart';
import 'package:rmc_customer/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coupon.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';

class Summary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SummaryPage();
  }
}

class SummaryPage extends State<Summary> {
  late BuildContext ctx;
  bool isLoaded = true;
  String? sID;

  List<dynamic> resultList = [];

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
          // getData();
        }
      });
    });
  }

  //Api Method
  getData() async {
    //Output
    var result = await STM().get(ctx, Str().loading, "get_notification");
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Payment Summary'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return Column(
      children: [
        Container(
          color: Clr().white,
          padding: EdgeInsets.symmetric(
            vertical: Dim().d32,
            horizontal: Dim().d12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: Dim().d150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFED5B6E33),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: Dim().d150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFED5B6E33),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: Dim().d150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFED5B6E33),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                          'url': "assets/dummy_summary.png",
                          'width': Dim().d140,
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
                                "Govardhan pathology lab",
                                style: Sty().mediumText,
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Text(
                                "Ambernath (w)",
                                style: Sty().mediumText,
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Text(
                                "Mon - Sat",
                                style: Sty().mediumText,
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Text(
                                "10:30Am - 10:30Pm",
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
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: resultList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return itemSummary(ctx, index, resultList);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // controller: nameCtrl,
                        cursorColor: Clr().primaryColor,
                        style: Sty().mediumText,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
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
                        onPressed: () {},
                        child: Text(
                          'APPLY',
                          style: Sty().largeText.copyWith(
                                color: Clr().white,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                InkWell(
                  onTap: () {
                    STM().redirect2page(ctx, Coupon(""));
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
                  child: Container(
                    color: Clr().white,
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
                              "₹2400",
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
                              "₹90",
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
                              "Discount",
                              style: Sty().smallText,
                            ),
                            Text(
                              "₹90",
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
                              "₹2400",
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
        Card(
          elevation: 2,
          color: Clr().white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dim().d12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Total : ₹ 1200",
                  style: Sty().largeText,
                ),
                SizedBox(
                  width: Dim().d150,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {},
                    child: Text(
                      'Pay Now',
                      style: Sty().largeText.copyWith(
                            color: Clr().white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
