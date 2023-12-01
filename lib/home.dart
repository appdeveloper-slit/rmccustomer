import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import '../values/dimens.dart';
import 'adapter/item_slider.dart';
import 'adapter/item_type.dart';
import 'drawer/drawer.dart';
import 'lab_detail.dart';
import 'login.dart';
import 'manager/static_method.dart';
import 'select_lab.dart';
import 'service_doctor_list.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State<Home> {
  late BuildContext ctx;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoaded = false,
      isLogin = false,
      isActive = false,
      isMandatory = false,
      isNotification = false;
  String? sUUID, sID, sCityID, sCityName, sLatitude, sLongitude;

  CarouselController sliderCtrl = CarouselController();
  List<dynamic> sliderList = [];
  int selectedSlider = 0;

  List<dynamic> typeList = [];
  List<dynamic> nearbyDoctorList = [];
  List<dynamic> nearbyLabList = [];
  List<dynamic> nearbyHospitalList = [];

  List<dynamic> patientList = [];

  Map<String, dynamic> data = {};

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  //Get detail
  getSessionData() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    SharedPreferences sp = await SharedPreferences.getInstance();
    //final status = await OneSignal.shared.getDeviceState();
    setState(() {
      isLogin = sp.getBool('is_login') ?? false;
      if (isLogin) {
        sID = sp.getString("user_id");
        sCityID = sp.getString("city_id");
        sCityName = sp.getString("city_name");
        sLatitude = sp.getString("latitude");
        sLongitude = sp.getString("longitude");
      }
      sUUID = OneSignal.User.pushSubscription.id;
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          getData(sp.getString('date'));
        }
      });
    });
  }

  //Api Method
  getData(date) async {
    //Input
    FormData body = FormData.fromMap({
      'uuid': sUUID ?? "",
      'customer_id': sID ?? "",
      'date': date ?? DateTime.now(),
      'city_id': sCityID,
      'city_name': sCityName,
      'latitude': sLatitude,
      'longitude': sLongitude,
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/get_home", body);
    if (!mounted) return;
    setState(() {
      data = result;
      result['status'] ? null : STM().finishAffinity(ctx, Login());
      isLoaded = true;
      sliderList = result['sliders'];
      typeList = result['consult_types'];
      nearbyDoctorList = result['doctors'];
      nearbyLabList = result['labs'];
      nearbyHospitalList = result['hospitals'];
      patientList = result['patients'];
      // isNotification = result['is_notification'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Upgrader.clearSavedSettings();
    ctx = context;
    return DoubleBack(
      message: "Press back once again to exit!",
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Clr().screenBackground,
        appBar: homeToolbarLayout(
            ctx, scaffoldKey, isNotification, sCityID, sCityName),
        drawer: navDrawer(ctx, scaffoldKey, true),
        body: isLoaded
            ? UpgradeAlert(
                upgrader: Upgrader(
                  showLater: !isMandatory,
                  showIgnore: false,
                  showReleaseNotes: false,
                ),
                child: Visibility(
                  visible: isLoaded,
                  child: bodyLayout(),
                ),
              )
            : Visibility(
                visible: isLoaded,
                child: bodyLayout(),
              ),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        Dim().pp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dim().d8,
          ),
          TextFormField(
            // controller: nameCtrl,
            onTap: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              if (!mounted) return;
              sp.setString("gender", "");
              sp.setString("price", "");
              Map<String, dynamic> map = {'search': ''};
              STM().redirect2page(ctx, ServiceDoctorList(map));
            },
            readOnly: true,
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
          SizedBox(
            height: Dim().d12,
          ),
          if (sliderList.isNotEmpty)
            CarouselSlider(
              carouselController: sliderCtrl,
              options: CarouselOptions(
                  height: 180,
                  viewportFraction: 1,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selectedSlider = index;
                    });
                  }),
              items: sliderList.map((e) => itemSlider(ctx, e)).toList(),
            ),
          SizedBox(
            height: Dim().d12,
          ),
          // InkWell(
          //   onTap: () {
          //     final uid = Uuid().v4();
          //     final name = 'Daenerys Targaryen';
          //     final avatar =
          //         'https://scontent.fhel6-1.fna.fbcdn.net/v/t1.0-9/62009611_2487704877929752_6506356917743386624_n.jpg?_nc_cat=102&_nc_sid=09cbfe&_nc_ohc=cIgJjOYlVj0AX_J7pnl&_nc_ht=scontent.fhel6-1.fna&oh=ef2b213b74bd6999cd74e3d5de235cf4&oe=5F6E3331';
          //     final handle = 'Incoming Call';
          //     final type = HandleType.number;
          //     final isVideo = true;
          //     FlutterIncomingCall.displayIncomingCallAdvanced(uid, name,
          //         avatar: avatar,
          //         handle: handle,
          //         handleType: type,
          //         hasVideo: isVideo,
          //         supportsGrouping: true,
          //         supportsHolding: true);
          //     FlutterIncomingCall.onEvent.listen((event) {
          //       if (event == CallEvent) {
          //         STM().redirect2page(ctx, VideoCall({}));
          //       }
          //     });
          //   },
          //   child: Text(
          //     "Consult Type",
          //     style: Sty().largeText,
          //   ),
          // ),
          Text(
            "Consult Type",
            style: Sty().largeText,
          ),
          SizedBox(
            height: Dim().d4,
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 170,
            ),
            itemCount: typeList.length,
            itemBuilder: (context, index) {
              var v = typeList[index];
              v.addEntries(
                {
                  "doctor_image": data['doctor_image'],
                  "doctor_name": data['doctor_name'],
                  "consultation_fee": data['consultation_fee'],
                  "doctor_charge": data['doctor_charge'],
                  "basic_charge": data['basic_charge'],
                  "cardiac_charge": data['cardiac_charge'],
                  "gst": data['gst'],
                  "patients": patientList,
                }.entries,
              );
              return itemType(context, v);
            },
          ),
          SizedBox(
            height: Dim().d12,
          ),
          Text(
            "Book Lab Test",
            style: Sty().largeText,
          ),
          SizedBox(
            height: Dim().d4,
          ),
          InkWell(
            onTap: () {
              STM().redirect2page(ctx, SelectLab('lab'));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                Dim().d4,
              ),
              child: STM().imageView({
                'url': "assets/dummy_lab.png",
              }),
            ),
          ),
          // if (nearbyDoctorList.isNotEmpty)
          //   horizontalLayout(
          //       'Nearby Doctors', nearbyDoctorList, nearbyDoctorLayout),
          // if (nearbyLabList.isNotEmpty)
          //   horizontalLayout('Nearby Labs', nearbyLabList, nearbyLabLayout),
          // if (nearbyHospitalList.isNotEmpty)
          //   horizontalLayout(
          //       'Nearby Hospitals', nearbyHospitalList, nearbyHospitalLayout),
        ],
      ),
    );
  }

  //Common Layout
  Widget horizontalLayout(title, list, itemLayout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dim().d12,
        ),
        Text(
          title,
          style: Sty().largeText,
        ),
        SizedBox(
          height: Dim().d180,
          child: ListView.builder(
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return itemLayout(ctx, index, list);
            },
          ),
        ),
      ],
    );
  }

  //Nearby Doctors
  Widget nearbyDoctorLayout(ctx, index, list) {
    var v = list[index];
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(ctx).size.width / 2.8,
        margin: EdgeInsets.all(
          Dim().d8,
        ),
        padding: EdgeInsets.all(
          Dim().d8,
        ),
        decoration: BoxDecoration(
          color: Clr().white,
          border: Border.all(
            color: Clr().lightGrey,
          ),
        ),
        child: Column(
          children: [
            STM().imageView({
              'url': v['image_path'],
              'height': Dim().d80,
            }),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              v['name'],
              style: Sty().mediumText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              v['speciality'],
              style: Sty().mediumText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  //Nearby Labs
  Widget nearbyLabLayout(ctx, index, list) {
    var v = list[index];
    return InkWell(
      onTap: () {
        Map<String, dynamic> map = {
          "total": 0,
        };
        map.addEntries(v.entries);
        STM().redirect2page(
          ctx,
          LabDetail(
            map,
            patientList,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(ctx).size.width / 2.8,
        margin: EdgeInsets.all(
          Dim().d8,
        ),
        padding: EdgeInsets.all(
          Dim().d8,
        ),
        decoration: BoxDecoration(
          color: Clr().white,
          border: Border.all(
            color: Clr().lightGrey,
          ),
        ),
        child: Column(
          children: [
            STM().imageView({
              'url': v['image_path'],
              'height': Dim().d80,
            }),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              v['name'],
              style: Sty().mediumText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  //Nearby Doctor
  Widget nearbyHospitalLayout(ctx, index, list) {
    var v = list[index];
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(ctx).size.width / 2.8,
        margin: EdgeInsets.all(
          Dim().d8,
        ),
        padding: EdgeInsets.all(
          Dim().d8,
        ),
        decoration: BoxDecoration(
          color: Clr().white,
          border: Border.all(
            color: Clr().lightGrey,
          ),
        ),
        child: Column(
          children: [
            STM().imageView({
              'url': v['image_path'],
              'height': Dim().d80,
            }),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              v['name'],
              style: Sty().mediumText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
