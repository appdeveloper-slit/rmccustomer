import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rmc_customer/home.dart';
import 'package:rmc_customer/manager/static_method.dart';
import 'package:rmc_customer/values/colors.dart';
import 'package:rmc_customer/values/dimens.dart';
import 'package:rmc_customer/values/styles.dart';

class endCall extends StatefulWidget {
  final detail;

  endCall({super.key, this.detail});

  @override
  State<endCall> createState() => _endCallState();
}

class _endCallState extends State<endCall> {
  late BuildContext ctx;
  late RtcEngine _engine;

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffb8b9ba),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dim().d12)),
                      border: Border.all(color: Clr().white)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Dim().d20,
                      ),
                      Text('Cut The Call',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white, fontSize: Dim().d32)),
                      SizedBox(
                        height: Dim().d20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            endCall(widget.detail);
                          },
                          child: Text(
                            'Press Ok',
                            style: Sty().smallText.copyWith(
                                color: Clr().white, fontSize: Dim().d20),
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  endCall(i) async {
    FormData body = FormData.fromMap({
      'doctor_id': i['doctor_id'],
      'type': 1,
    });
    var result = await STM().postWithoutDialogCtx('customer/reject_call', body);
    if(result['success']){
      STM().finishAffinity(ctx, Home());
    }
  }
}
