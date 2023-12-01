import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home.dart';
import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemCity(ctx, index, list) {
  return InkWell(
    onTap: () {
      STM().redirect2page(ctx, Home());
    },
    child: Container(
      margin: EdgeInsets.all(
        Dim().d8,
      ),
      child: Column(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(
          //     Dim().d200,
          //   ),
          //   child: STM().imageView({
          //     'fit': BoxFit.cover,
          //     width: double.infinity,
          //     height: Dim().d100,
          //     // 'url': list[index]['image_path'],
          //     }
          //   ),
          // ),
          SvgPicture.asset(
            "${list[index]['svg']}",
            height: Dim().d100,
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Text(
            list[index]['name'],
            style: Sty().smallText,
          ),
        ],
      ),
    ),
  );
}
