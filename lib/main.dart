import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_incoming_call/flutter_incoming_call.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rmc_customer/endcall.dart';
import 'package:rmc_customer/video_call/callenddialog.dart';
import 'package:rmc_customer/video_call/incoming_call.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'appointment_detail.dart';
import 'cities.dart';
import 'home.dart';
import 'login.dart';
import 'manager/static_method.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool("is_login") ?? false;
  String sCity = sp.getString("city_id") ?? "";
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("15aa1ea8-a71d-491e-a371-f2b900565d81");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  OneSignal.Notifications.addForegroundWillDisplayListener(
    (event1) {
      if (event1.notification.additionalData != null) {
        Map<String, dynamic> result = event1.notification.additionalData!;
        print('result:   $result  ');
        if (result['title'] == 'Incoming call') {
          incomingCall(result);
          FlutterIncomingCall.onEvent.listen((BaseCallEvent event) {
            if (event is CallEvent) {
              if (event.action == CallAction.accept) {
                navigatorKey.currentState!.push(
                  MaterialPageRoute(
                    builder: (context) => IncomingCall(result),
                  ),
                );
              } else if (event.action == CallAction.decline) {
                navigatorKey.currentState!.push(
                  MaterialPageRoute(
                    builder: (context) => endCall(detail: result),
                  ),
                );
              }
            }
          });
        } else {
          if(result['type'].toString().contains('1')){
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => cancelDialgo(),
              ),
            );
          }else{
            FlutterIncomingCall.endAllCalls();
          }
        }
      }
      // event1.complete(null);
    },
  );

  OneSignal.Notifications.addClickListener((value) {
    if (value.notification.additionalData != null) {
      Map<String, dynamic> result = value.notification.additionalData!;
      incomingCall(result);
      FlutterIncomingCall.onEvent.listen((BaseCallEvent event) {
        if (event is CallEvent) {
          if (event.action == CallAction.accept) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => IncomingCall(result),
              ),
            );
          }
        }
      });
    }
  });

  FlutterIncomingCall.configure(
    appName: 'RMC Customer',
    duration: 30000,
    android: ConfigAndroid(
      vibration: true,
      ringtonePath: 'default',
      channelId: 'calls',
      channelName: 'Calls channel name',
      channelDescription: 'Calls channel description',
    ),
    ios: ConfigIOS(
      iconName: 'AppIcon40x40',
      ringtonePath: null,
      includesCallsInRecents: false,
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
    ),
  );

  await Future.delayed(const Duration(seconds: 2));
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!);
      },
      home: isLogin
          ? sCity.isNotEmpty
              ? Home()
              : Cities("0")
          : Login(),
      // home: IndexPage(),
    ),
  );
}

incomingCall(result) {
  var uid = const Uuid().v4();
  var name = result['doctor_name'];
  var avatar = result['doctor_profile_pic'];
  var handle = 'Incoming Call';
  var type = HandleType.number;
  var isVideo = true;
  FlutterIncomingCall.displayIncomingCallAdvanced(
    uid,
    name,
    avatar: avatar,
    handle: handle,
    handleType: type,
    hasVideo: isVideo,
    supportsGrouping: true,
    supportsHolding: true,
  );
}

