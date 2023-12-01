import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemMedical(ctx, v) {
  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    title: Text(
      '${v['name']}',
      style: Sty().mediumText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Wrap(
      children: [
        Text(
          '+91 ${v['mobile']}',
          style: Sty().mediumText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          width: Dim().d8,
        ),
        InkWell(
          onTap: () {
            STM().openDialer(v['mobile'].toString());
          },
          child: SvgPicture.asset(
            "assets/rectangle_call.svg",
            height: Dim().d28,
          ),
        ),
      ],
    ),
  );
}
