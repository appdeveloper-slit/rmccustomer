import 'package:flutter/material.dart';
import 'package:rmc_customer/manager/static_method.dart';

import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<StatefulWidget> createState() {
    return AboutUsPage();
  }
}

class AboutUsPage extends State<AboutUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'About Us'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: Dim().d16,
        horizontal: Dim().d20,
      ),
      child: Column(
        children: [
          SizedBox(
            height: Dim().d20,
          ),
          STM().imageView2(
            'assets/launcher.png',
            width: Dim().d180,
          ),
          SizedBox(
            height: Dim().d32,
          ),
          Text(
            Str().aboutUs,
            style: Sty().mediumText,
          ),
        ],
      ),
    );
  }
}
