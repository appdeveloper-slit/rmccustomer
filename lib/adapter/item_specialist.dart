import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rmc_customer/values/colors.dart';

import '../dialog/dialog_confirmation.dart';
import '../manager/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget itemSpecialist(ctx, v) {
  return InkWell(
    onTap: () async {
      AwesomeDialog dialog = STM().modalDialog2(ctx,
          dialogConfirmation(ctx, v, false, b2: true), Clr().screenBackground);
      dialog.show();
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
                horizontal: Dim().d4,
              ),
              child: Column(
                children: [
                  Text(
                    '${v['name']}',
                    style: Sty().mediumBoldText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Starts at ${v['starts_at']}',
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
