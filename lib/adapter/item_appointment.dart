import 'package:flutter/material.dart';
import 'package:rmc_customer/appointment_detail.dart';
import 'package:rmc_customer/values/colors.dart';

import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemAppointment(ctx, index, list) {
  var v = list[index];
  return InkWell(
    onTap: () {
      STM().redirect2page(ctx, AppointmentDetail(v));
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
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Dim().d100,
            ),
            child: STM().imageView({
              'url': v['doctor_profile_pic'],
              'fit': BoxFit.cover,
              'width': Dim().d80,
              'height': Dim().d80,
            }),
          ),
          SizedBox(
            width: Dim().d32,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${v['doctor_name']}',
                // "RMC Doctor",
                style: Sty().smallText,
              ),
              SizedBox(
                height: Dim().d2,
              ),
              Text(
                '${v['doctor_speciality']}',
                style: Sty().smallText,
              ),
              SizedBox(
                height: Dim().d2,
              ),
              Text(
                '${v['date']}  ${v['slot'] == null ? '' : v['slot']['slot'] != null ? v['slot']['slot'] : ''}',
                style: Sty().smallText,
              ),
              SizedBox(
                height: Dim().d2,
              ),
              Text(
                '${v['status_text']}',
                // list[index].toString(),
                // "Pending",
                style: Sty().smallText.copyWith(
                      color: v['status'] == 1
                          ? Clr().green2
                          : v['status'] == 2
                              ? Clr().errorRed
                              : Clr().accentColor,
                    ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
