import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmc_customer/cities.dart';
import 'package:rmc_customer/filter.dart';
import 'package:rmc_customer/home.dart';

import '../manager/static_method.dart';
import '../notification.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

PreferredSizeWidget toolbar1Layout() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    leading: Padding(
      padding: EdgeInsets.all(
        Dim().d20,
      ),
      child: SvgPicture.asset(
        'assets/back.svg',
        color: Clr().white,
      ),
    ),
  );
}

//AppBar
PreferredSizeWidget toolbar22Layout(title) {
  return AppBar(
    backgroundColor: Clr().primaryColor,
    elevation: 0,
    leading: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dim().d12,
        vertical: Dim().d20,
      ),
      child: SvgPicture.asset(
        'assets/back.svg',
        color: Clr().white,
      ),
    ),
    title: Text(
      title,
      style: Sty().mediumText.copyWith(
            color: Clr().white,
          ),
    ),
  );
}

PreferredSizeWidget homeToolbarLayout(ctx, scaffoldKey, b, sCityID, sCityName) {
  return AppBar(
    toolbarHeight: Dim().d60,
    backgroundColor: Clr().white,
    leading: InkWell(
      onTap: () {
        scaffoldKey.currentState!.openDrawer();
      },
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          Dim().d16,
        ),
        child: SvgPicture.asset(
          'assets/tb_menu.svg',
        ),
      ),
    ),
    centerTitle: true,
    title: STM().imageView({
      'url': 'assets/launcher.png',
      'height': Dim().d48,
    }),
    actions: [
      InkWell(
        onTap: () {
          STM().redirect2page(ctx, Cities(sCityID));
        },
        child: Row(
          children: [
            Text(
              sCityName ?? "",
              style: Sty().mediumText,
            ),
            SizedBox(
              width: Dim().d4,
            ),
            SvgPicture.asset(
              'assets/edit.svg',
              height: Dim().d24,
            ),
          ],
        ),
      ),
      SizedBox(
        width: Dim().d12,
      ),
      InkWell(
        onTap: () {
          STM().redirect2page(ctx, Notifications());
        },
        child: Row(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  'assets/tb_notification.svg',
                  height: Dim().d32,
                ),
                if (b)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        width: Dim().d12,
      ),
    ],
  );
}

PreferredSizeWidget titleToolbarLayout(ctx, title) {
  return AppBar(
    backgroundColor: Clr().white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().primaryColor,
    ),
    centerTitle: true,
    title: Text(
      title,
      style: Sty().largeText.copyWith(
            color: Clr().primaryColor,
          ),
    ),
    leading: InkWell(
      onTap: () {
        if (Navigator.of(ctx).canPop()) {
          Navigator.of(ctx).pop();
        } else {
          STM().replacePage(ctx, Home());
        }
      },
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          Dim().d16,
        ),
        child: SvgPicture.asset(
          'assets/back.svg',
          color: Clr().primaryColor,
        ),
      ),
    ),
  );
}

PreferredSizeWidget filterToolbarLayout(ctx, v) {
  return AppBar(
    backgroundColor: Clr().white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Clr().primaryColor,
    ),
    centerTitle: true,
    title: v.containsKey('name')
        ? Text(
            v['name'],
            style: Sty().extraLargeText.copyWith(
                  color: Clr().primaryColor,
                ),
          )
        : TextFormField(
            // controller: nameCtrl,
            cursorColor: Clr().primaryColor,
            style: Sty().mediumText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: Sty().textFieldWhiteStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                  hintText: "Search Doctor",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Clr().grey,
                  ),
                ),
          ),
    leading: InkWell(
      onTap: () {
        STM().back2Previous(ctx);
      },
      borderRadius: BorderRadius.circular(
        Dim().d100,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          Dim().d16,
        ),
        child: SvgPicture.asset(
          'assets/back.svg',
          color: Clr().primaryColor,
        ),
      ),
    ),
    actions: [
      InkWell(
        onTap: () {
          STM().redirect2page(ctx, Filter(v));
        },
        borderRadius: BorderRadius.circular(
          Dim().d100,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            Dim().d16,
          ),
          child: SvgPicture.asset(
            'assets/filter.svg',
            height: Dim().d32,
          ),
        ),
      ),
    ],
  );
}
