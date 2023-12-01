import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../manager/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemNotification(ctx, index, list) {
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
        Text(
          list[index]['title'],
          style: Sty().largeText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: Dim().d8,
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
        SizedBox(
          height: Dim().d8,
        ),
        Text(
          list[index]['date'],
          style: Sty().mediumText.copyWith(
                color: Clr().grey,
              ),
        ),
      ],
    ),
  );
}
