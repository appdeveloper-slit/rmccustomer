import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemCoupon(ctx, index, list) {
  var v = list[index];
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: Dim().d8,
    ),
    padding: EdgeInsets.all(
      Dim().d16,
    ),
    color: Clr().white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            FlutterClipboard.copy(v['coupon_code']).then(
                (value) => STM().displayToast('Code Copied Successfully'));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Dim().d8,
              horizontal: Dim().d16,
            ),
            decoration: Sty().outlineBoxStyle,
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/copy.svg",
                ),
                Expanded(
                  child: Text(
                    v['coupon_code'],
                    style: Sty().largeText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Dim().d16,
        ),
        Html(
          data: list[index]['description'],
          shrinkWrap: true,
          style: {
            "body": Style(
              margin: Margins.all(0),
              // padding: EdgeInsets.zero,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
              color: Clr().grey,
              fontSize: FontSize(16.0),
            ),
          },
          // onLinkTap: (url, context, attrs, element) {
          //   STM().openWeb(url!);
          // },
        ),
      ],
    ),
  );
}
