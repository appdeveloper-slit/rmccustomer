import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemSummary(ctx, index, list) {
  return Container(
    padding: EdgeInsets.all(
      Dim().d8,
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            "Test 1",
            style: Sty().smallText,
          ),
        ),
        SizedBox(
          width: Dim().d16,
        ),
        Text(
          // list[index]['title'],
          '₹600',
          style: Sty().mediumText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          width: Dim().d16,
        ),
        InkWell(
          onTap: () {
            // STM().openWeb(list[index]['video_link']);
          },
          child: SvgPicture.asset(
            "assets/close.svg",
            height: Dim().d16,
          ),
        ),
      ],
    ),
  );
}
