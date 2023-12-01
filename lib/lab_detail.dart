import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_patient.dart';
import 'lab_summary.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class LabDetail extends StatefulWidget {
  Map<String, dynamic> data;
  List<dynamic> patientList;

  LabDetail(this.data, this.patientList, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LabDetailPage();
  }
}

class LabDetailPage extends State<LabDetail> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  Map<String, dynamic> v = {};

  static StreamController<dynamic> controller =
      StreamController<dynamic>.broadcast();
  List<dynamic> patientList = [];
  int selectedPatient = -1;
  bool flag = false;

  static StreamController<dynamic> updateStateController =
      StreamController<dynamic>.broadcast();
  bool isPatient = false, isTest = false;

  List<int> testList = [];

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
    updateStateController.stream.listen(
      (event) {
        setState(() {
          v = v;
          v['total'] = v['total'];
        });
      },
    );
    super.initState();
  }

  //Get detail
  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sID = sp.getString("user_id");
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: titleToolbarLayout(ctx, '${v['name']}'),
      body: bodyLayout(),
    );
  }

  //Body
  Widget bodyLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              Dim().d12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Container(
                    color: Clr().white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        STM().imageView({
                          'url': v['image_path'],
                          'width': double.infinity,
                          'height': Dim().d250,
                          'fit': BoxFit.cover,
                        }
                        ),
                        SizedBox(
                          width: Dim().d12,
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                            Dim().d8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '${v['name']}',
                                  style: Sty().mediumText,
                                ),
                              ),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Text(
                                "${v['available_days']}\n${v['available_time']}",
                                style: Sty().mediumText,
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dim().d8,
                          ),
                          child: Text(
                            "Address :",
                            style: Sty().largeText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dim().d8,
                          ),
                          child: Text(
                            '${v['address']}',
                            style: Sty().mediumText,
                          ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                Card(
                  elevation: 2,
                  child: Container(
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                ),
                if (isPatient)
                  Center(
                    child: Text(
                      "Please select patient",
                      style: Sty().microText.copyWith(color: Clr().errorRed),
                    ),
                  ),
                SizedBox(
                  height: Dim().d16,
                ),
                Card(
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Clr().white,
                      border: isTest
                          ? Border.all(
                              color: Clr().errorRed,
                            )
                          : Border.all(
                              color: Clr().lightGrey,
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            Dim().d12,
                            Dim().d12,
                            Dim().d12,
                            Dim().d4,
                          ),
                          child: Text(
                            "Select Test :",
                            style: Sty().mediumText,
                          ),
                        ),
                        const Divider(),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: v.containsKey('tests') ? v['tests'].length : v['services'].length,
                          itemBuilder: (context, index) {
                            return itemTest(ctx, index, v.containsKey('tests') ? v['tests'] : v['services']);
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (isTest)
                  Center(
                    child: Text(
                      "Please select test",
                      style: Sty().microText.copyWith(color: Clr().errorRed),
                    ),
                  ),
              ],
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
                        isTest = v['total'] == 0 ? true : false;
                      });
                      if (selectedPatient > 0 && v['total'] > 0) {
                        Map<String, dynamic> map = {
                          "patient_id": patientList[selectedPatient - 1]['id'],
                          "patient_name": patientList[selectedPatient - 1]
                              ['name'],
                          "gst": (v['total'] * 0.18).round(),
                          "discount": 0,
                          "grand_total": v['total'] + (v['total'] * 0.18).round(),
                        };
                        map.addEntries(v.entries);
                        STM().redirect2page(ctx, LabSummary(map, testList));
                      }
                    },
                    child: Text(
                      'Checkout',
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
          STM().redirect2page(ctx, AddPatient("lab"));
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

  Widget itemTest(ctx, index, list) {
    var v2 = list[index];
    // if (!flag) {
    //   Map<String, dynamic> map = {'value': false};
    //   v2.addEntries(map.entries);
    //   setState(() {
    //     flag = index == list.length - 1;
    //   });
    // }
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dim().d4,
      ),
      child: Row(
        children: [
          Checkbox(
            value: testList.contains(v2['id']),
            onChanged: (b) {
              setState(() {
                if (b!) {
                  isTest = false;
                  int total = v['total'];
                  int price = v2['price'];
                  int sum = total + price;
                  v.update('total', (value) => sum);
                  testList.add(v2['id']);
                } else {
                  int total = v['total'];
                  int price = v2['price'];
                  int sub = total - price;
                  v.update('total', (value) => sub);
                  testList.remove(v2['id']);
                }
                // v2.update('value', (value) => b);
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${v2['name']}',
                      style: Sty().mediumText,
                    ),
                    Text(
                      '\u20b9${v2['price']}',
                      style: Sty().mediumText,
                    ),
                  ],
                ),
                Text(
                  '${v2['description']}',
                  style: Sty().smallText,
                ),
              ],
            ),
          ),
          SizedBox(
            width: Dim().d16,
          ),
        ],
      ),
    );
  }
}
