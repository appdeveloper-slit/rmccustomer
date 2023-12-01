import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'adapter/item_video.dart';
import 'manager/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/strings.dart';

class Video extends StatefulWidget {
  Map<String, dynamic> data;

  Video(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPage();
  }
}

class VideoPage extends State<Video> {
  late BuildContext ctx;
  bool isLoaded = true;
  List<dynamic> resultList = [];

  Map<String, dynamic> v = {};

  @override
  void initState() {
    v = widget.data;
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getData();
      }
    });
    super.initState();
  }

  //Api Method
  getData() async {
    //Input
    FormData body = FormData.fromMap({
      'type': v['id'],
    });
    //Output
    var result =
        await STM().post(ctx, Str().loading, "customer/get_ct_video", body);
    if (!mounted) return;
    setState(() {
      isLoaded = true;
      resultList = result['videos'];
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      appBar: titleToolbarLayout(ctx, v['name']),
      body: Visibility(
        visible: isLoaded,
        child: resultList.isNotEmpty
            ? bodyLayout()
            : STM().emptyData("No Video Found"),
      ),
    );
  }

  //Body
  Widget bodyLayout() {
    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (BuildContext context, int index) {
        var value = resultList[index];
        value.addEntries(v.entries);
        //@Change
        value.addEntries({"video_id": "u_0V6EiqNIQ"}.entries);
        return itemVideo(ctx, value);
      },
    );
  }
}
