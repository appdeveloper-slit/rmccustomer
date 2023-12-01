import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/about_us.dart';
import 'package:rmc_customer/appointment.dart';
import 'package:rmc_customer/booking.dart';
import 'package:rmc_customer/contact_us.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home.dart';
import '../login.dart';
import '../manager/app_url.dart';
import '../manager/static_method.dart';
import '../profile.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

Widget navDrawer(ctx, key, isLogin) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (key.currentState.isDrawerOpen) {
          key.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: Dim().d300,
        backgroundColor: Clr().background,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: Dim().d40,
            ),
            Image.asset(
              "assets/launcher.png",
              height: Dim().d150,
            ),
            SizedBox(
              height: Dim().d16,
            ),
            itemLayout(ctx, key, 'Home', Home(), 'nd_home.svg'),
            itemLayout(ctx, key, 'My Booking', Booking(), 'nd_booking.svg'),
            itemLayout(ctx, key, 'My Appointment', Appointment(),
                'nd_appointment.svg'),
            itemLayout(ctx, key, 'My Profile', Profile(), 'nd_profile.svg'),
            itemLayout2(ctx, key, 'Privacy Policy', 'nd_privacy.svg'),
            itemLayout2(ctx, key, 'Terms & Conditions', 'nd_terms.svg'),
            share(key),
            itemLayout(ctx, key, 'About Us', const AboutUs(), 'nd_about.svg'),
            itemLayout(ctx, key, 'Contact Us', ContactUs(), 'nd_contact.svg'),
            if (isLogin) logout(ctx, key),
          ],
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}

Widget itemLayout(ctx, key, title, widget, svg) {
  return ListTile(
    dense: true,
    leading: SvgPicture.asset(
      'assets/$svg',
      color: Clr().primaryColor,
      width: Dim().d28,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d20,
    ),
    title: Text(
      title,
      style: Sty().mediumText,
    ),
    onTap: () {
      close(key);
      if (title == 'Home') {
        STM().replacePage(ctx, widget);
      } else {
        STM().redirect2page(ctx, widget);
      }
    },
  );
}

Widget itemLayout2(ctx, key, title, svg) {
  return ListTile(
    dense: true,
    leading: SvgPicture.asset(
      'assets/$svg',
      color: Clr().primaryColor,
      width: Dim().d28,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d20,
    ),
    title: Text(
      title,
      style: Sty().mediumText,
    ),
    onTap: () {
      close(key);
      switch (title) {
        case 'Privacy Policy':
          STM().openWeb(AppUrl.policyUrl);
          break;
        case 'Refund Policy':
          STM().openWeb(AppUrl.refundPolicyUrl);
          break;
        case 'Terms & Conditions':
          STM().openWeb(AppUrl.termsUrl);
          break;
      }
    },
  );
}

Widget rateUs(key) {
  return ListTile(
    dense: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d20,
    ),
    title: Text(
      'Rate Us',
      style: Sty().mediumText,
    ),
    onTap: () {
      close(key);
      try {
        launchUrl(Uri.parse("market://details?id=com.app.sahaj_adhyayan"));
      } on PlatformException {
        launchUrl(Uri.parse(
            "https://play.google.com/store/apps/details?id=com.app.sahaj_adhyayan"));
      } finally {
        launchUrl(Uri.parse(
            "https://play.google.com/store/apps/details?id=com.app.sahaj_adhyayan"));
      }
    },
  );
}

Widget share(key) {
  return ListTile(
    dense: true,
    leading: SvgPicture.asset(
      'assets/nd_share.svg',
      color: Clr().primaryColor,
      width: Dim().d28,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d20,
    ),
    title: Text(
      'Share App',
      style: Sty().mediumText,
    ),
    onTap: () {
      close(key);
      var message =
          'Download Link: https://play.google.com/store/apps/details?id=com.csutomer.rmc';
      Share.share(message);
    },
  );
}

Widget logout(ctx, key) {
  return ListTile(
    dense: true,
    leading: SvgPicture.asset(
      'assets/nd_logout.svg',
      width: Dim().d28,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dim().d20,
    ),
    title: Text(
      'Logout',
      style: Sty().mediumText,
    ),
    onTap: () {
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Clr().screenBackground,
            contentPadding: EdgeInsets.all(
              Dim().pp,
            ),
            title: Text(
              "Confirmation",
              style: Sty().largeText.copyWith(
                    color: Clr().errorRed,
                  ),
            ),
            content: Text(
              "Are you sure you want to logout?",
              style: Sty().smallText,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  close(key);
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.clear();
                  STM().finishAffinity(ctx, Login());
                },
                child: Text(
                  "Yes",
                  style: Sty().smallText.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  STM().back2Previous(ctx);
                },
                child: Text(
                  "No",
                  style: Sty().smallText.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
