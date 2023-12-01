import 'package:flutter/material.dart';
import 'package:rmc_customer/lab_detail.dart';
import 'package:rmc_customer/values/colors.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemLab(ctx, index, list, list2) {
  var v = list[index];
  return InkWell(
    onTap: () {
      Map<String, dynamic> map = {
        "total": 0,
      };
      map.addEntries(v.entries);
      STM().redirect2page(
        ctx,
        LabDetail(
          map,
          list2,
        ),
      );
    },
    child: Container(
      color: Clr().white,
      margin: EdgeInsets.all(
        Dim().d8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          STM().imageView({
            'url': v['image_path'],
            'width': double.infinity,
            'height': Dim().d150,
            'fit': BoxFit.cover,
          }),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dim().d8,
              ),
              child: Column(
                children: [
                  Text(
                    '${v['name']}',
                    style: Sty().mediumBoldText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Text(
                    'Starts at ₹${v['starts_at']}',
                    // " 200",
                    style: Sty().mediumText.copyWith(
                          color: Clr().green2,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
