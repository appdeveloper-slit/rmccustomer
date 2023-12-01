import 'package:flutter/material.dart';
import 'package:rmc_customer/booking_detail.dart';
import 'package:rmc_customer/values/colors.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemBooking(ctx, index, list) {
  var v = list[index];
  return InkWell(
    onTap: () {
      STM().redirect2page(ctx, BookingDetail(v));
    },
    child: Container(
      color: Clr().white,
      margin: EdgeInsets.all(
        Dim().d8,
      ),
      padding: EdgeInsets.all(
        Dim().d12,
      ),
      child: Row(
        children: [
          STM().imageView({
            'url': v['lab_image_path'],
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
                  '${v['lab_name']}',
                  style: Sty().smallText,
                ),
                SizedBox(
                  height: Dim().d2,
                ),
                Text(
                  '${v['test_count_text']}',
                  style: Sty().smallText,
                ),
                SizedBox(
                  height: Dim().d2,
                ),
                Text(
                  '${v['date']}',
                  style: Sty().smallText,
                ),
                SizedBox(
                  height: Dim().d2,
                ),
                Text(
                  '${v['status_text']}',
                  style: Sty().smallText.copyWith(
                        color: v['status'] == 1
                            ? Clr().green2
                            : v['status'] == 2
                                ? Clr().errorRed
                                : Clr().accentColor,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
