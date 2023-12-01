import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmc_customer/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_patient.dart';
import 'appointment.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class EmergencyCheckout extends StatefulWidget {
  Map<String, dynamic> data;
  List<dynamic> patientList;

  EmergencyCheckout(this.data, this.patientList, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EmergencyCheckoutPage();
  }
}

class EmergencyCheckoutPage extends State<EmergencyCheckout> {
  late BuildContext ctx;

  Map<String, dynamic> v = {};
  String? sID;

  static StreamController<dynamic> controller =
      StreamController<dynamic>.broadcast();
  List<dynamic> patientList = [];
  int selectedPatient = -1;
  bool isPatient = false;

  int selectedPreference = -1;
  bool isPreference = false;

  int selectedAmbulanceType = -1;
  bool isAmbulanceType = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController homeAddressCtrl = TextEditingController();
  TextEditingController contactNoCtrl = TextEditingController();

  @override
  void initState() {
    v = widget.data;
    patientList = widget.patientList;
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
    });
  }

  //Api method
  void addData() async {
    String sUrl = 'https://rmcservice.in/emergency_appointment?'
        'customer_id=$sID&'
        'patient_id=${patientList[selectedPatient - 1]['id']}&'
        'appointment_type_id=${v['apt_id']}&'
        'preference=${selectedPreference + 1}&'
        'ambulance_type=${selectedPreference > -1 ? selectedAmbulanceType + 1 : 0}&'
        'home_address=${homeAddressCtrl.text.trim()}&'
        'contact_no=${contactNoCtrl.text.trim()}&'
        'charge=${v['charge']}&'
        'gst=${v['gst_amt']}&'
        'total=${v['total']}';
    STM().redirect2page(ctx, WebViewPage(sUrl, Appointment()));
  }

  //Api method
  void addData2() async {
    //Input
    FormData body = FormData.fromMap({
      'customer_id': sID,
      'patient_id': patientList[selectedPatient - 1]['id'],
      'appointment_type_id': v['apt_id'],
      'preference': selectedPreference + 1,
      'ambulance_type': selectedPreference > -1 ? selectedAmbulanceType + 1 : 0,
      'home_address': homeAddressCtrl.text.trim(),
      'contact_no': contactNoCtrl.text.trim(),
      'charge': v['charge'],
      'gst': v['gst_amt'],
      'total': v['total'],
      'txn_id': 'ABCDEFG',
      'txn_date': DateTime.now(),
    });
    //Output
    var result = await STM()
        .post(ctx, Str().loading, "customer/add_emergency_appt", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      STM().successDialog(ctx, message, Appointment());
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, 'Checkout'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Container(
                    width: MediaQuery.of(ctx).size.width,
                    color: Clr().white,
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dim().d100,
                          ),
                          child: STM().imageView({
                            'url': v['doctor_image'],
                            'width': Dim().d80,
                            'height': Dim().d80,
                            'fit': BoxFit.cover,
                          }),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          '${v['doctor_name']}',
                          style: Sty().mediumText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Container(
                    color: Clr().white,
                    padding: EdgeInsets.all(
                      Dim().d16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Emergency Case',
                                style: Sty().smallText,
                              ),
                            ),
                            Text(
                              ':',
                              style: Sty().smallText,
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    v['apt_id'] == '3'
                                        ? "assets/home.svg"
                                        : "assets/online.svg",
                                  ),
                                  SizedBox(
                                    width: Dim().d4,
                                  ),
                                  Text(
                                    '${v['apt_name']}',
                                    style: Sty().smallText,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dim().d16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Clr().white,
                            border: isPatient
                                ? Border.all(
                                    color: Clr().errorRed,
                                  )
                                : Border.all(
                                    color: Clr().lightGrey,
                                  ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Dim().d4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Consultation For",
                                style: Sty().mediumText,
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(
                                  Dim().d8,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                ),
                                itemCount: patientList.length + 1,
                                itemBuilder: (context, index) {
                                  return itemPatient(
                                      context, index, patientList);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (isPatient)
                          Center(
                            child: Text(
                              "Please select patient",
                              style: Sty()
                                  .microText
                                  .copyWith(color: Clr().errorRed),
                            ),
                          ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        if (v['apt_id'] == '3') homeVisitLayout(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Summary",
                              style: Sty().largeText,
                            ),
                            if (selectedPreference == 1 &&
                                selectedAmbulanceType > -1)
                              SizedBox(
                                height: Dim().d16,
                              ),
                            if (selectedPreference == 1 &&
                                selectedAmbulanceType > -1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${selectedAmbulanceType == 1 ? 'Cardiac' : 'Basic'} Ambulance",
                                    style: Sty().smallText,
                                  ),
                                  Text(
                                    "₹${v[selectedAmbulanceType == 1 ? 'cardiac_charge' : 'basic_charge']}",
                                    style: Sty().smallText,
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  v['apt_id'] == '3'
                                      ? "Doctor Charge"
                                      : "Consultation Fee",
                                  style: Sty().smallText,
                                ),
                                Text(
                                  "₹${v['charge']}",
                                  style: Sty().smallText,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "GST",
                                  style: Sty().smallText,
                                ),
                                Text(
                                  "₹${v['gst_amt']}",
                                  style: Sty().smallText,
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Amount Payable",
                                  style: Sty()
                                      .mediumText
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "₹${v['total']}",
                                  style: Sty()
                                      .smallText
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Container(
            color: Clr().white,
            padding: EdgeInsets.symmetric(
              vertical: Dim().d8,
              horizontal: Dim().d20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\u20b9${v['total']}",
                  style: Sty().largeText,
                ),
                SizedBox(
                  width: Dim().d160,
                  child: ElevatedButton(
                    style: Sty().primaryButton,
                    onPressed: () {
                      setState(() {
                        isPatient = selectedPatient == -1 ? true : false;
                        isPreference = selectedPreference == -1 ? true : false;
                        isAmbulanceType =
                            selectedAmbulanceType == -1 ? true : false;
                      });
                      if (v['apt_id'] == '3') {
                        if (formKey.currentState!.validate() &&
                            selectedPatient > 0 &&
                            selectedPreference > -1) {
                          if (selectedPreference == 1) {
                            if (selectedAmbulanceType > -1) {
                              STM()
                                  .checkInternet(context, widget)
                                  .then((value) {
                                if (value) {
                                  addData();
                                }
                              });
                            }
                          } else {
                            STM().checkInternet(context, widget).then((value) {
                              if (value) {
                                addData();
                              }
                            });
                          }
                        }
                      } else {
                        if (selectedPatient > 0) {
                          STM().checkInternet(context, widget).then((value) {
                            if (value) {
                              addData();
                            }
                          });
                        }
                      }
                    },
                    child: Text(
                      'CONTINUE',
                      style: Sty().largeText.copyWith(
                            color: Clr().white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget itemPatient(ctx, index, list) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          STM().redirect2page(ctx, AddPatient("emergency"));
        } else {
          setState(() {
            selectedPatient = index;
            isPatient = false;
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

  Widget homeVisitLayout() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dim().d16,
          ),
          Text(
            'Enter Home Address :',
            style: Sty().mediumText.copyWith(
                  color: Clr().primaryColor,
                ),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          TextFormField(
            controller: homeAddressCtrl,
            cursorColor: Clr().primaryColor,
            style: Sty().mediumText,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            textInputAction: TextInputAction.next,
            decoration: Sty().textFieldWhiteStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                  hintText: "Enter Address",
                ),
            validator: (value) {
              if (value!.isEmpty) {
                return Str().invalidEmpty;
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Text(
            'Enter Contact Number :',
            style: Sty().mediumText.copyWith(
                  color: Clr().primaryColor,
                ),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          TextFormField(
            controller: contactNoCtrl,
            cursorColor: Clr().primaryColor,
            style: Sty().mediumText,
            maxLength: 10,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'\d')),
            ],
            textInputAction: TextInputAction.done,
            decoration: Sty().textFieldWhiteStyle.copyWith(
                  hintStyle: Sty().mediumText.copyWith(
                        color: Clr().lightGrey,
                      ),
                  hintText: "Enter Mobile Number",
                  counterText: "",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(
                      14,
                    ),
                    child: SvgPicture.asset(
                      'assets/call.svg',
                    ),
                  ),
                ),
            validator: (value) {
              if (value!.isEmpty || !RegExp(r'([5-9]\d{9})').hasMatch(value)) {
                return Str().invalidMobile;
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Container(
            decoration: BoxDecoration(
              color: Clr().white,
              border: isPreference
                  ? Border.all(
                      color: Clr().errorRed,
                    )
                  : null,
            ),
            padding: EdgeInsets.all(
              Dim().d4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose Your Preference",
                  style: Sty().largeText,
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPreference = 0;
                            isPreference = false;
                            v.update(
                                "total", (value) => v['charge'] + v['gst_amt']);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            Dim().d12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedPreference == 0
                                ? Clr().primaryColor
                                : Clr().white,
                            border: Border.all(
                              color: selectedPreference == 0
                                  ? Clr().primaryColor
                                  : Clr().lightGrey,
                            ),
                          ),
                          child: Text(
                            'Only\nDoctor',
                            style: Sty().mediumText.copyWith(
                                  color: selectedPreference == 0
                                      ? Clr().white
                                      : Clr().black,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dim().d16,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedAmbulanceType > -1) {
                              selectedAmbulanceType = -1;
                              isAmbulanceType = false;
                            }
                            selectedPreference = 1;
                            isPreference = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                            Dim().d12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedPreference == 1
                                ? Clr().primaryColor
                                : Clr().white,
                            border: Border.all(
                              color: selectedPreference == 1
                                  ? Clr().primaryColor
                                  : Clr().lightGrey,
                            ),
                          ),
                          child: Text(
                            'Doctor &\nAmbulance',
                            style: Sty().mediumText.copyWith(
                                  color: selectedPreference == 1
                                      ? Clr().white
                                      : Clr().black,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isPreference)
            Center(
              child: Text(
                "Please select preference",
                style: Sty().microText.copyWith(color: Clr().errorRed),
              ),
            ),
          SizedBox(
            height: Dim().d12,
          ),
          if (selectedPreference == 1)
            Container(
              decoration: BoxDecoration(
                color: Clr().white,
                border: isAmbulanceType
                    ? Border.all(
                        color: Clr().errorRed,
                      )
                    : null,
              ),
              padding: EdgeInsets.all(
                Dim().d4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Ambulance Type",
                    style: Sty().largeText,
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedAmbulanceType = 0;
                              isAmbulanceType = false;
                              update();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              Dim().d12,
                            ),
                            decoration: BoxDecoration(
                              color: selectedAmbulanceType == 0
                                  ? Clr().primaryColor
                                  : Clr().white,
                              border: Border.all(
                                color: selectedAmbulanceType == 0
                                    ? Clr().primaryColor
                                    : Clr().lightGrey,
                              ),
                            ),
                            child: Text(
                              'Basic Ambulance',
                              style: Sty().mediumText.copyWith(
                                    color: selectedAmbulanceType == 0
                                        ? Clr().white
                                        : Clr().black,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d16,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedAmbulanceType = 1;
                              isAmbulanceType = false;
                              update();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              Dim().d12,
                            ),
                            decoration: BoxDecoration(
                              color: selectedAmbulanceType == 1
                                  ? Clr().primaryColor
                                  : Clr().white,
                              border: Border.all(
                                color: selectedAmbulanceType == 1
                                    ? Clr().primaryColor
                                    : Clr().lightGrey,
                              ),
                            ),
                            child: Text(
                              'Cardiac Ambulance',
                              style: Sty().mediumText.copyWith(
                                    color: selectedAmbulanceType == 1
                                        ? Clr().white
                                        : Clr().black,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (selectedPreference == 1 && isAmbulanceType)
            Center(
              child: Text(
                "Please select ambulance type",
                style: Sty().microText.copyWith(color: Clr().errorRed),
              ),
            ),
          if (selectedPreference == 1)
            SizedBox(
              height: Dim().d12,
            ),
        ],
      ),
    );
  }

  void update() {
    setState(() {
      int charge = v['charge'];
      int gst = v['gst'];
      int ambulance =
          selectedAmbulanceType == 1 ? v['cardiac_charge'] : v['basic_charge'];
      int total = charge + ambulance;
      int gstAmt = (total / 100 * gst).round();
      v.update("gst_amt", (value) => gstAmt);
      v.update("total", (value) => total + gstAmt);
    });
  }
}
