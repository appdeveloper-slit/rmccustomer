import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Cities extends StatefulWidget {
  String sCityID;

  Cities(this.sCityID, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CitiesPage();
  }
}

class CitiesPage extends State<Cities> {
  late BuildContext ctx;

  bool isLoaded = false;
  List<dynamic> list = [];
  String? sLatitude, sLongitude;

  @override
  void initState() {
    super.initState();
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getData();
      }
    });
  }

  //Api method
  getData() async {
    //Output
    var result = await STM().get(ctx, Str().loading, "get_cities");
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      list = result['cities'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: titleToolbarLayout(ctx, 'Select Location'),
      body: Visibility(
        visible: isLoaded,
        child: bodyLayout(),
      ),
    );
  }

  Widget bodyLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await Geolocator.requestPermission();
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              setState(() {
                sLatitude = position.latitude.toString();
                sLongitude = position.longitude.toString();
                STM().displayToast("Current location captured.");
              });
            },
            child: Column(
              children: [
                SizedBox(
                  height: Dim().d12,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Dim().d32,
                    ),
                    SvgPicture.asset(
                      "assets/current_location.svg",
                      width: Dim().d24,
                      height: Dim().d24,
                    ),
                    SizedBox(
                      width: Dim().d16,
                    ),
                    Expanded(
                      child: Text(
                        sLatitude != null
                            ? 'Location : $sLatitude, $sLongitude'
                            : "Use my current location",
                        style: Sty().mediumText.copyWith(
                              color: Clr().green2,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                const Divider(),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: Dim().d160,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              var v = list[index];
              return InkWell(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  setState(() {
                    sp.setString("city_id", v['id'].toString());
                    sp.setString('city_name', v['name']);
                    if (sLatitude != null && sLongitude != null) {
                      sp.setString('latitude', sLatitude!);
                      sp.setString('longitude', sLongitude!);
                      STM().finishAffinity(ctx, Home());
                    } else {
                      STM().displayToast("Select current location");
                    }
                  });
                },
                child: Column(
                  children: [
                    CachedNetworkImage(
                      width: Dim().d120,
                      height: Dim().d120,
                      fit: BoxFit.contain,
                      imageUrl: v['image_path'] ??
                          'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                      alignment: Alignment.bottomCenter,
                      color: widget.sCityID == v['id'].toString()
                          ? Clr().primaryColor
                          : Clr().grey,
                      placeholder: (context, url) => STM().loadingPlaceHolder(),
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      v['name'],
                      style: Sty().mediumBoldText.copyWith(
                            color: widget.sCityID == v['id'].toString()
                                ? Clr().primaryColor
                                : Clr().grey,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
