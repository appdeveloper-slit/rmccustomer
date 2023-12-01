import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class ViewProfile extends StatefulWidget {
  final String sDoctorID;

  ViewProfile(this.sDoctorID, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ViewProfilePage();
  }
}

class ViewProfilePage extends State<ViewProfile> {
  late BuildContext ctx;
  bool isLoaded = false;
  String? sID;

  Map<String, dynamic> v = {};
  int position = 0;

  @override
  void initState() {
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getData();
      }
    });
    super.initState();
  }

  //Get Api
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'id': widget.sDoctorID,
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "doctor/view_profile", body);
    if (!mounted) return;
    var error = result['error'];
    var message = result['message'];
    if (!error) {
      setState(() {
        isLoaded = true;
        v = result;
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, 'Doctor Details'),
      body: Visibility(
        visible: isLoaded,
        child: v.isNotEmpty ? bodyLayout() : Container(),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: Dim().pp,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Dim().d200,
            ),
            child: STM().imageView({
              'url': "${v['profile_picture']}",
              'width': Dim().d150,
              'height': Dim().d150,
            }),
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Text(
            "${v['full_name']}",
            style: Sty().mediumBoldText,
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Text(
            "${v['speciality']}",
            // "Physician",
            style: Sty().smallText.copyWith(
                  color: Clr().grey,
                ),
          ),
          SizedBox(
            height: Dim().d4,
          ),
          Text(
            "${v['email']}",
            // "physician@gmail.com",
            style: Sty().smallText,
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Card(
            color: Clr().white,
            margin: EdgeInsets.all(
              Dim().d12,
            ),
            child: Padding(
              padding: EdgeInsets.all(
                Dim().d12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Patient\n',
                        style: Sty().mediumText.copyWith(
                              color: Clr().grey,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "${v['patient_count']}+",
                            // text: '120+',
                            style: Sty().mediumBoldText,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    height: 60,
                    width: 1.2,
                    color: Clr().black,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Experience\n',
                        style: Sty().mediumText.copyWith(
                              color: Clr().grey,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "${v['experience']}yrs+",
                            // text: '5yrs+',
                            style: Sty().mediumBoldText,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Dim().d12,
                    ),
                    height: 60,
                    width: 1.2,
                    color: Clr().black,
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Age\n',
                        style: Sty().mediumText.copyWith(
                              color: Clr().grey,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "${v['age']}",
                            // text: '24',
                            style: Sty().mediumBoldText,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dim().d16,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      position = 0;
                    });
                  },
                  child: Container(
                    decoration: position == 0
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Clr().accentColor,
                                width: 2,
                              ),
                            ),
                          )
                        : null,
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: Text(
                      "Doctor Details",
                      style: Sty().mediumText.copyWith(
                            color:
                                position == 0 ? Clr().accentColor : Clr().black,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      position = 1;
                    });
                  },
                  child: Container(
                    decoration: position == 1
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Clr().accentColor,
                                width: 2,
                              ),
                            ),
                          )
                        : null,
                    padding: EdgeInsets.all(
                      Dim().d12,
                    ),
                    child: Text(
                      "Clinic Details",
                      style: Sty().mediumText.copyWith(
                            color:
                                position == 1 ? Clr().accentColor : Clr().black,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          position == 0 ? doctorDetail() : clinicDetail(),
        ],
      ),
    );
  }

  Widget doctorDetail() {
    return Padding(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item('Gender', '${v['gender']}'),
          SizedBox(
            height: Dim().d12,
          ),
          item('Date Of Birth', '${v['dob']}'),
          SizedBox(
            height: Dim().d12,
          ),
          item('Degree', '${v['degree']}'),
          SizedBox(
            height: Dim().d12,
          ),
          item('Registration Number', '${v['reg_no']}'),
        ],
      ),
    );
  }

  Widget clinicDetail() {
    return Padding(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: v['hospital_address'].length,
            itemBuilder: (ctx, index) {
              return item(
                  index == 0
                      ? 'Hospital Address'
                      : 'Hospital Address ${index + 1}',
                  v['hospital_address'][index]['address']);
            },
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: Dim().d12,
              );
            },
          ),
          SizedBox(
            height: Dim().d12,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: v['opd_address'].length,
            itemBuilder: (ctx, index) {
              return item(
                  index == 0 ? 'OPD address' : 'OPD address ${index + 1}',
                  v['opd_address'][index]['address']);
            },
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: Dim().d12,
              );
            },
          ),
          SizedBox(
            height: Dim().d12,
          ),
          item('Official Contact No', '+91 ${v['official_contact_no']}'),
        ],
      ),
    );
  }

  Widget item(title, value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: Sty().mediumBoldText.copyWith(
                      color: Clr().darkBlue,
                    ),
              ),
              Text(
                '$value',
                style: Sty().mediumText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
