import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class ContactUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactUsPage();
  }
}

class ContactUsPage extends State<ContactUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Contact Us'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dim().d20,
      ),
      child: Column(
        children: [
          SizedBox(
            height: Dim().d20,
          ),
          Image.asset('assets/contact_banner.png'),
          SizedBox(
            height: Dim().d20,
          ),
          Text(
            'Contact Information',
            style: Sty()
                .largeText
                .copyWith(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Text(
            'Have any query contact us',
            style: Sty().microText.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
          SizedBox(
            height: Dim().d20,
          ),
          Icon(
            Icons.call,
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Text(
            '== Contact ==',
            style: Sty().mediumBoldText,
          ),
          InkWell(
              onTap: () {
                STM().openDialer('8104690763');
              },
              child: Text(
                '+91 8104690763',
                style: Sty().mediumText,
              )),
          SizedBox(
            height: Dim().d28,
          ),
          Icon(
            Icons.email,
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Text(
            '== Email ==',
            style: Sty().mediumBoldText,
          ),
          InkWell(
            onTap: () async {
              await launchUrlString('mailto:rmc134062@gmail.com');
            },
            child: Text(
              'rmc134062@gmail.com',
              style: Sty().mediumText,
            ),
          ),
          SizedBox(
            height: Dim().d28,
          ),
          Icon(
            Icons.location_on_sharp,
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Text(
            '== Location ==',
            style: Sty().mediumBoldText,
          ),
          Text(
            'R No. C-3, Plot No.CD 58, Dharti CHS Ltd, SVP NGR, Mhada, Nr Versova Telephone E, Mumbai - 400 053',
            textAlign: TextAlign.center,
            style: Sty().mediumText,
          ),
        ],
      ),
    );
  }
}
