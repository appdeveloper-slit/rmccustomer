import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/values/colors.dart';
import '../manager/static_method.dart';
import '../select_slot.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import '../view_profile.dart';

Widget itemServiceDoctor(ctx, index, list, id, name) {
  var v = list[index];
  return Container(
    color: Clr().white,
    margin: EdgeInsets.all(
      Dim().d8,
    ),
    padding: EdgeInsets.all(
      Dim().d12,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    Dim().d100,
                  ),
                  child: STM().imageView({
                    'url': v['profile_picture'],
                    'width': Dim().d80,
                    'height': Dim().d80,
                    'fit': BoxFit.cover,
                  }),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                InkWell(
                  onTap: () {
                    debugPrint(v['id'].toString());
                    STM().redirect2page(ctx, ViewProfile(v['id'].toString()));
                  },
                  child: Text(
                    "View Profile",
                    style: Sty().smallText.copyWith(
                          color: Clr().accentColor,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: Dim().d32,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${v['name']}',
                    style: Sty().smallText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: Dim().d2,
                  ),
                  Text(
                    '${v['speciality']}  ${v['degree']}',
                    style: Sty().smallText,
                  ),
                  SizedBox(
                    height: Dim().d2,
                  ),
                  Text(
                    '${v['experience']}',
                    style: Sty().smallText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: Dim().d2,
                  ),
                  Text(
                    '${v['city']}',
                    style: Sty().microText.copyWith(
                          color: Clr().grey,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Text(
          "Next Available",
          style: Sty().smallText,
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Wrap(
          children: [
            SvgPicture.asset(
              "assets/video.svg",
              height: Dim().d20,
            ),
            SizedBox(
              width: Dim().d12,
            ),
            Text(
              '${v['next_available']}   \u20b9${v['charge']}',
              style: Sty().smallText,
            ),
          ],
        ),
        SizedBox(
          height: Dim().d16,
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: Dim().d250,
            child: ElevatedButton(
              style: Sty().primaryButton,
              onPressed: () {
                Map<String, dynamic> map = {
                  "apt_id": id ?? v['appt_id'],
                  "apt_name": name ?? v['appt_name'],
                };
                map.addEntries(v.entries);
                STM().redirect2page(ctx, SelectSlot(map));
              },
              child: Text(
                name ?? v['appt_name'],
                style: Sty().largeText.copyWith(
                      color: Clr().white,
                    ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
