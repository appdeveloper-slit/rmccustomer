import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/book_ambulance.dart';
import 'package:rmc_customer/hospital.dart';
import 'package:rmc_customer/manager/static_method.dart';
import 'package:rmc_customer/video.dart';

import '../dialog/dialog_confirmation.dart';
import '../medicine.dart';
import '../select_lab.dart';
import '../select_specialist.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemType(ctx, v) {
  return InkWell(
    onTap: () {
      switch (v['type']) {
        case 'specialist-doctor':
          STM().redirect2page(ctx, SelectSpecialist());
          break;
        case 'lab-test':
          STM().redirect2page(ctx, SelectLab('lab'));
          break;
        case 'diagnostic-centre':
          STM().redirect2page(ctx, SelectLab('dc'));
          break;
        case 'book-ambulance':
          STM().redirect2page(ctx, BookAmbulance());
          break;
        case 'admission':
          STM().redirect2page(ctx, Hospital());
          break;
        case 'medicine':
          STM().redirect2page(ctx, Medicine());
          break;
        case 'medical-equipment':
        case 'cosmetologist-trichologist':
        case 'therapist':
          AwesomeDialog dialog =
              STM().modalDialog(ctx, STM().comingSoon(ctx), Clr().white);
          dialog.show();
          break;
        case 'weight-loss-gain-fitness':
        case 'opd-treatment-videos':
        case 'ipd-diagnostic-treatment-videos':
        case 'ipd-diagnostic-treatment-videos':
        case 'wellness-videos':
          STM().redirect2page(ctx, Video(v));
          break;
        default:
          AwesomeDialog dialog = STM().modalDialog2(
              ctx, dialogConfirmation(ctx, v, true), Clr().screenBackground);
          dialog.show();
          break;
      }
    },
    child: Container(
      margin: EdgeInsets.all(
        Dim().d4,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Dim().d200,
            ),
            child: STM().imageView({
              'url': v['image_path'],
              'height': Dim().d100,
              'fit': BoxFit.cover,
            }),
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Text(
            v['name'].toString(),
            style: Sty().smallText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
