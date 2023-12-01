import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/video_player.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemVideo(ctx, v) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: Dim().d8,
    ),
    padding: EdgeInsets.all(
      Dim().d12,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${v['caption']}',
          style: Sty().mediumText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: Dim().d8,
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(ctx, VideoPlayer(v));
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Dim().d8,
                ),
                child: STM().imageView({
                  'url': v['thumbnail'],
                  'width': double.infinity,
                  'height': Dim().d150,
                  'fit': BoxFit.cover,
                }),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: Dim().d52,
                top: Dim().d52,
                child: SvgPicture.asset(
                  "assets/play.svg",
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
