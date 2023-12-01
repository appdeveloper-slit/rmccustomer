import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/values/colors.dart';
import 'package:rmc_customer/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../emergency_checkout.dart';
import '../manager/static_method.dart';
import '../service_doctor_list.dart';
import '../values/dimens.dart';

Widget dialogConfirmation(ctx, v, b, {b2 = false}) {
  return Container(
    padding: EdgeInsets.only(
      bottom: Dim().d16,
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString("gender", "");
                  sp.setString("price", "");
                  if (b2 ? true : b) {
                    Map<String, dynamic> map = {
                      "id": v['id'].toString(),
                      "name": v['name'],
                      "apt_id": "3",
                      "apt_name": "Home Visit",
                    };
                    STM().redirect2page(ctx, ServiceDoctorList(map));
                  } else {
                    Map<String, dynamic> map = {
                      "doctor_image": v['doctor_image'],
                      "doctor_name": v['doctor_name'],
                      "apt_id": "3",
                      "apt_name": "Home Visit",
                      "charge": v['doctor_charge'],
                      'basic_charge': v['basic_charge'],
                      'cardiac_charge': v['cardiac_charge'],
                      "gst": v['gst'],
                      "gst_amt": (v['doctor_charge'] / 100 * v['gst']).round(),
                      "total": (v['doctor_charge'] +
                              (v['doctor_charge'] / 100 * v['gst']))
                          .round(),
                    };
                    STM().redirect2page(
                        ctx, EmergencyCheckout(map, v['patients']));
                  }
                },
                child: Container(
                  height: Dim().d140,
                  margin: EdgeInsets.symmetric(
                    vertical: Dim().d2,
                    horizontal: Dim().d2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33ED5B6E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                            Dim().d8,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: SvgPicture.asset(
                                  "assets/home_visit.svg",
                                  height: Dim().d56,
                                ),
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Home\nVisit",
                                  style: Sty().microText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString("gender", "");
                          sp.setString("price", "");
                          if (b2 ? true : b) {
                            Map<String, dynamic> map = {
                              "id": v['id'].toString(),
                              "name": v['name'],
                              "apt_id": "3",
                              "apt_name": "Home Visit",
                            };
                            STM().redirect2page(ctx, ServiceDoctorList(map));
                          } else {
                            Map<String, dynamic> map = {
                              "doctor_image": v['doctor_image'],
                              "doctor_name": v['doctor_name'],
                              "apt_id": "3",
                              "apt_name": "Home Visit",
                              "charge": v['doctor_charge'],
                              'basic_charge': v['basic_charge'],
                              'cardiac_charge': v['cardiac_charge'],
                              "gst": v['gst'],
                              "gst_amt":
                                  (v['doctor_charge'] / 100 * v['gst']).round(),
                              "total": (v['doctor_charge'] +
                                      (v['doctor_charge'] / 100 * v['gst']))
                                  .round(),
                            };
                            STM().redirect2page(
                                ctx, EmergencyCheckout(map, v['patients']));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: Dim().d4,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFED5B6E),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                6,
                              ),
                            ),
                          ),
                          child: Text(
                            "Click Here",
                            style: Sty().microText.copyWith(
                                  color: Clr().white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString("gender", "");
                  sp.setString("price", "");
                  if (b2 ? true : b) {
                    Map<String, dynamic> map = {
                      "id": v['id'].toString(),
                      "name": v['name'],
                      "apt_id": "1",
                      "apt_name": "Online",
                    };
                    STM().redirect2page(ctx, ServiceDoctorList(map));
                  } else {
                    Map<String, dynamic> map = {
                      "doctor_image": v['doctor_image'],
                      "doctor_name": v['doctor_name'],
                      "apt_id": "1",
                      "apt_name": "Online",
                      "charge": v['doctor_charge'],
                      'basic_charge': v['basic_charge'],
                      'cardiac_charge': v['cardiac_charge'],
                      "gst": v['gst'],
                      "gst_amt": (v['doctor_charge'] / 100 * v['gst']).round(),
                      "total": (v['doctor_charge'] +
                              (v['doctor_charge'] / 100 * v['gst']))
                          .round(),
                    };
                    STM().redirect2page(
                        ctx, EmergencyCheckout(map, v['patients']));
                  }
                },
                child: Container(
                  height: Dim().d140,
                  margin: EdgeInsets.symmetric(
                    vertical: Dim().d2,
                    horizontal: Dim().d2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2EAF0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                            Dim().d8,
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: SvgPicture.asset(
                                  "assets/online_consultation.svg",
                                  height: Dim().d56,
                                ),
                              ),
                              SizedBox(
                                height: Dim().d4,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Online\nConsultation",
                                  style: Sty().microText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString("gender", "");
                          sp.setString("price", "");
                          if (b2 ? true : b) {
                            Map<String, dynamic> map = {
                              "id": v['id'].toString(),
                              "name": v['name'],
                              "apt_id": "1",
                              "apt_name": "Online",
                            };
                            STM().redirect2page(ctx, ServiceDoctorList(map));
                          } else {
                            Map<String, dynamic> map = {
                              "doctor_image": v['doctor_image'],
                              "doctor_name": v['doctor_name'],
                              "apt_id": "1",
                              "apt_name": "Online",
                              "charge": v['doctor_charge'],
                              'basic_charge': v['basic_charge'],
                              'cardiac_charge': v['cardiac_charge'],
                              "gst": v['gst'],
                              "gst_amt":
                                  (v['doctor_charge'] / 100 * v['gst']).round(),
                              "total": (v['doctor_charge'] +
                                      (v['doctor_charge'] / 100 * v['gst']))
                                  .round(),
                            };
                            STM().redirect2page(
                                ctx, EmergencyCheckout(map, v['patients']));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: Dim().d4,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1F98B3),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                6,
                              ),
                            ),
                          ),
                          child: Text(
                            "Click Here",
                            style: Sty().microText.copyWith(
                                  color: Clr().white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (b2 ? true : b)
              Expanded(
                child: InkWell(
                  onTap: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setString("gender", "");
                    sp.setString("price", "");
                    Map<String, dynamic> map = {
                      "id": v['id'].toString(),
                      "name": v['name'],
                      "apt_id": "2",
                      "apt_name": "Visit Clinic",
                    };
                    STM().redirect2page(ctx, ServiceDoctorList(map));
                  },
                  child: Container(
                    height: Dim().d140,
                    margin: EdgeInsets.symmetric(
                      vertical: Dim().d2,
                      horizontal: Dim().d2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x339481FC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                              Dim().d8,
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    "assets/clinic_appointment.svg",
                                    height: Dim().d56,
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d4,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Clinic\nAppointment",
                                    style: Sty().microText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            sp.setString("gender", "");
                            sp.setString("price", "");
                            Map<String, dynamic> map = {
                              "id": v['id'].toString(),
                              "name": v['name'],
                              "apt_id": "2",
                              "apt_name": "Visit Clinic",
                            };
                            STM().redirect2page(ctx, ServiceDoctorList(map));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: Dim().d4,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFF9481FC),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(
                                  6,
                                ),
                              ),
                            ),
                            child: Text(
                              "Click Here",
                              style: Sty().microText.copyWith(
                                    color: Clr().white,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (b)
          SizedBox(
            height: Dim().d8,
          ),
        if (b)
          InkWell(
            onTap: () {
              AwesomeDialog dialog = STM().modalDialog2(ctx,
                  dialogConfirmation(ctx, v, false), Clr().screenBackground);
              dialog.show();
            },
            child: STM().imageView({
              'url': "assets/dummy_button.png",
            }),
          ),
      ],
    ),
  );
}
