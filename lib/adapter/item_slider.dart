import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/manager/static_method.dart';

import '../values/dimens.dart';

Widget itemSlider(ctx, v) {
  return InkWell(
    onTap: () {
      // STM().redirect2page(ctx, NewsDetail(false, false, e['id'].toString()));
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(
        Dim().d8,
      ),
      child: STM().imageView({
        'url': v['image_path'],
        'height': Dim().d240,
        'fit': BoxFit.fitWidth,
        }
      ),
      // ),
    ),
  );
}
