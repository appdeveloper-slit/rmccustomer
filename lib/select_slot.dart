import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rmc_customer/add_patient.dart';
import 'package:rmc_customer/appointment_checkout.dart';
import 'package:rmc_customer/values/dimens.dart';
import 'package:rmc_customer/view_profile.dart';
import 'package:rmc_customer/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointment.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SelectSlot extends StatefulWidget {
  Map<String, dynamic> data;

  SelectSlot(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectSlotPage();
  }
}

class SelectSlotPage extends State<SelectSlot> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  Map<String, dynamic> v = {};
  List<dynamic> languageList = [
    'Hindi',
    'English',
  ];
  int selectedLanguage = 0;

  List<dynamic> patientList = [];
  int selectedPatient = -1;

  List<dynamic> slotList = [];
  int selectedSlot = -1;

  static StreamController<dynamic> controller =
      StreamController<dynamic>.broadcast();

  TextEditingController dobCtrl = TextEditingController(
    text: STM().dateFormat("dd/MM/yyyy", DateTime.now()),
  );
  DateTime? dateTime = DateTime.now();

  @override
  void initState() {
    v = widget.data;
    getSessionData();
    controller.stream.listen(
      (event) {
        setState(() {
          patientList.add(event);
        });
      },
    );
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id") ?? "";
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData(true);
        }
      });
    });
  }

  //Date picker
  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      //Disabled past date
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      //Disabled future date
      // firstDate: DateTime(1900),
      //lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateTime = picked;
        String s = STM().dateFormat('dd/MM/yyyy', dateTime);
        dobCtrl = TextEditingController(text: s);
        getData(false);
      });
    }
  }

  //Api Method
  getData(b) async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID ?? "",
      'doctor_id': v['id'],
      'appointment_type_id': v['apt_id'],
      'day_no': b ? DateTime.now().weekday : dateTime!.weekday,
      'date': dateTime.toString().split(" ").first,
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/get_patient_slot", body);
    if (!mounted) return;
    var error = result['error'];
    if (!error) {
      setState(() {
        isLoaded = true;
        patientList = result['patients'];
        slotList = result['slots'];
        selectedSlot = -1;
      });
    } else {
      setState(() {
        isLoaded = true;
        slotList = [];
      });
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Select Slot & Patient'),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: Dim().d16,
          ),
          Container(
            color: Clr().white,
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
                    'url': v['profile_picture'],
                    'width': Dim().d80,
                    'height': Dim().d80,
                    'fit': BoxFit.cover,
                  }),
                ),
                SizedBox(
                  width: Dim().d32,
                ),
                Column(
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
                      '${v['speciality']}',
                      style: Sty().smallText.copyWith(
                            color: Clr().lightGrey,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: Dim().d2,
                    ),
                    InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx, ViewProfile(v['id'].toString()));
                      },
                      child: Text(
                        'View Profile',
                        style: Sty().smallText.copyWith(
                              color: const Color(0xFF265ED7),
                            ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d2,
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/check.svg",
                        ),
                        SizedBox(
                          width: Dim().d8,
                        ),
                        Text(
                          v['apt_name'],
                          style: Sty().smallText.copyWith(
                                color: Clr().green2,
                              ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Container(
            color: Clr().white,
            margin: EdgeInsets.symmetric(
              horizontal: Dim().d32,
            ),
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Language",
                  style: Sty().largeText,
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(
                    Dim().d8,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: Dim().d40,
                  ),
                  itemCount: languageList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedLanguage = index;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: selectedLanguage == index
                            ? Clr().primaryColor
                            : Clr().white,
                        child: Text(
                          languageList[index],
                          style: Sty().mediumText.copyWith(
                                color: selectedLanguage == index
                                    ? Clr().white
                                    : Clr().black,
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Container(
            color: Clr().white,
            margin: EdgeInsets.symmetric(
              horizontal: Dim().d32,
            ),
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Patient",
                  style: Sty().largeText,
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(
                    Dim().d8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: patientList.length + 1,
                  itemBuilder: (context, index) {
                    return itemPatient(context, index, patientList);
                  },
                ),
              ],
            ),
          ),
          if (v['apt_id'].toString() == '1')
            Column(
              children: [
                SizedBox(
                  height: Dim().d16,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: Dim().d12,
                  ),
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      if (selectedPatient > 0) {
                        String sUrl = 'https://rmcservice.in/appointment?'
                            'customer_id=$sID&'
                            'doctor_id=${v['id']}&'
                            'patient_id=${patientList[selectedPatient - 1]['id']}&'
                            'appointment_type_id=${v['apt_id']}&'
                            'date=${dateTime.toString().split(" ").first}&'
                            'slot_id=&'
                            'home_address=&'
                            'contact_no=&'
                            'charge=${v['charge']}&'
                            'coupon_code=&'
                            'gst=${(v['charge'] * 0.18).round()}&'
                            'discount=0&'
                            'total=${v['charge'] + (v['charge'] * 0.18).round()}&'
                            'language=${languageList[selectedLanguage]}';
                        STM().redirect2page(ctx, WebViewPage(sUrl, Appointment()));
                      } else {
                        STM().displayToast("Select patient");
                      }
                    },
                    child: Text(
                      'Connect Now',
                      style: Sty().largeText.copyWith(
                            color: Clr().white,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                Text(
                  '---- OR ----',
                  style: Sty().mediumText,
                ),
              ],
            ),
          SizedBox(
            height: Dim().d16,
          ),
          Container(
            color: Clr().white,
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: Dim().d8,
                ),
                IntrinsicWidth(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      datePicker();
                    },
                    controller: dobCtrl,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: Sty().textFieldWhiteStyle.copyWith(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: Sty().mediumText.copyWith(
                                color: Clr().lightGrey,
                              ),
                          hintText: "Select Date",
                          isDense: true,
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dim().d12,
                            ),
                            child: SvgPicture.asset(
                              "assets/slot_calendar.svg",
                            ),
                          ),
                        ),
                  ),
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(
                    Dim().d8,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: Dim().d60,
                  ),
                  itemCount: slotList.length,
                  itemBuilder: (context, index) {
                    return itemSlot(context, index, slotList);
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      if (selectedPatient > 0) {
                        if (selectedSlot > -1) {
                          Map<String, dynamic> map = {
                            "patient_id": patientList[selectedPatient - 1]
                                ['id'],
                            "patient_name": patientList[selectedPatient - 1]
                                ['name'],
                            "slot_date_id": dateTime,
                            "slot_date": dobCtrl.text,
                            "slot_id": slotList[selectedSlot]['id'],
                            "slot_time": slotList[selectedSlot]['slot'],
                            "discount": 0,
                            "total": v['charge'] + (v['charge'] * 0.18).round(),
                            "language": languageList[selectedLanguage],
                          };
                          map.addEntries(v.entries);
                          STM().redirect2page(ctx, AppointmentCheckout(map));
                        } else {
                          STM().displayToast("Select slot");
                        }
                      } else {
                        STM().displayToast("Select patient");
                      }
                    },
                    child: Text(
                      'Proceed',
                      style: Sty().largeText.copyWith(
                            color: Clr().white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemPatient(ctx, index, list) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          STM().redirect2page(ctx, AddPatient("slot"));
        } else {
          setState(() {
            selectedPatient = index;
          });
        }
      },
      child: Container(
        margin: EdgeInsets.all(
          Dim().d4,
        ),
        decoration: BoxDecoration(
          color:
              index == selectedPatient ? const Color(0x801F98B3) : Clr().white,
          border: Border.all(
            color: const Color(0xFF1F98B3),
          ),
          borderRadius: BorderRadius.circular(
            Dim().d100,
          ),
        ),
        child: Center(
          child: Text(
            index == 0 ? "+" : STM().nameShort(list[index - 1]['name']),
            style: Sty().largeText.copyWith(
                  color: index == selectedPatient
                      ? Clr().white
                      : const Color(0xFF1F98B3),
                ),
          ),
        ),
      ),
    );
  }

  Widget itemSlot(ctx, index, list) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSlot = index;
        });
      },
      child: Container(
        margin: EdgeInsets.all(
          Dim().d4,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dim().d8,
        ),
        decoration: BoxDecoration(
          color: index == selectedSlot ? Clr().primaryColor : Clr().white,
          border: Border.all(
            width: 1.25,
            color: const Color(0x36868686),
          ),
        ),
        child: Center(
          child: Text(
            list[index]['slot'],
            style: Sty().mediumText.copyWith(
                  color: index == selectedSlot ? Clr().white : Clr().black,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
