import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rmc_customer/manager/static_method.dart';

class IncomingCall extends StatefulWidget {
  final Map<String, dynamic> data;

  const IncomingCall(this.data, {Key? key}) : super(key: key);

  @override
  IncomingCallState createState() => IncomingCallState();
}

class IncomingCallState extends State<IncomingCall> {
  Map<String, dynamic> v = {};

  // late RtcEngine rtcEngine;
  bool isMute = false;

  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    v = widget.data;
    initAgora();
    super.initState();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: 'e022219eb1d54317a609e0570d3680e5',
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
            STM().back2Previous(context);
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: v['token'],
      channelId: v['channel'],
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Future<void> initialize() async {
  //   rtcEngine = await RtcEngine.create('e022219eb1d54317a609e0570d3680e5');
  //   await rtcEngine.enableVideo();
  //   await rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
  //   await rtcEngine.setClientRole(ClientRole.Broadcaster);
  //   eventHandler();
  //   //For Video Quality
  //   VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
  //   configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
  //   await rtcEngine.setVideoEncoderConfiguration(configuration);
  //   await rtcEngine.joinChannel(v['token'], v['channel'], null, 0);
  // }
  //
  // void eventHandler() {
  //   rtcEngine.setEventHandler(
  //     RtcEngineEventHandler(
  //       userJoined: (uid, elapsed) {
  //         setState(() {
  //           remoteID = uid;
  //         });
  //       },
  //       userOffline: (uid, elapsed) {
  //         setState(() {
  //           remoteID = null;
  //         });
  //         STM().back2Previous(context);
  //       },
  //     ),
  //   );
  // }

  // @override
  // void dispose() {
  //   closeConnection();
  //   super.dispose();
  // }
  //
  // closeConnection() async {
  //   await rtcEngine.leaveChannel();
  //   await rtcEngine.destroy();
  // }
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            if(_remoteUid != null)
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            controllerView(),
          ],
        )
        // remoteID != null ? withRemoteUser() : withoutRemoteUser(),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: v['channel']),
        ),
      );
    } else {
      return _remoteUid == null ? Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: _localUserJoined
                ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
                : const CircularProgressIndicator(),
          ),
        ),
        // Column(mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       width: Dim().d100,
        //       height: Dim().d100,
        //       decoration: BoxDecoration(
        //         color: const Color(0x801F98B3),
        //         border: Border.all(
        //           color: const Color(0xFF1F98B3),
        //         ),
        //         borderRadius: BorderRadius.circular(
        //           Dim().d100,
        //         ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           STM().nameShort('${v['name']}'),
        //           style: Sty().largeText.copyWith(
        //             color: Clr().white,
        //           ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: Dim().d12,
        //     ),
        //     Text(
        //       '${v['name']}',
        //       style: Sty().largeText.copyWith(
        //         color: Clr().white,
        //       ),
        //     ),
        //     SizedBox(
        //       height: Dim().d12,
        //     ),
        //     Text(
        //       'Calling....',
        //       style: Sty().largeText.copyWith(
        //         color: Clr().white,
        //       ),
        //     ),
        //   ],
        // ),
      ) : Container();
    }
  }
  // Widget withoutRemoteUser() {
  //   return Stack(
  //     children: [
  //       const RtcLocalView.SurfaceView(),
  //       controllerView(),
  //     ],
  //   );
  // }
  //
  // Widget withRemoteUser() {
  //   return Stack(
  //     children: [
  //       Center(
  //         child: RtcRemoteView.SurfaceView(
  //           channelId: v['channel'],
  //           uid: remoteID ?? 0,
  //         ),
  //       ),
  //       const Align(
  //         alignment: Alignment.topLeft,
  //         child: SizedBox(
  //           width: 100,
  //           height: 150,
  //           child: Center(
  //             child: RtcLocalView.SurfaceView(),
  //           ),
  //         ),
  //       ),
  //       controllerView(),
  //     ],
  //   );
  // }

  // Widget controllerView() {
  //   return Container(
  //     alignment: Alignment.bottomCenter,
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         RawMaterialButton(
  //           onPressed: () {
  //             setState(() {
  //               isMute = !isMute;
  //             });
  //             rtcEngine.muteLocalAudioStream(isMute);
  //           },
  //           shape: const CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: isMute ? Colors.blueAccent : Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //           child: Icon(
  //             isMute ? Icons.mic_off : Icons.mic,
  //             color: isMute ? Colors.white : Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () => Navigator.pop(context),
  //           shape: const CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.redAccent,
  //           padding: const EdgeInsets.all(15.0),
  //           child: const Icon(
  //             Icons.call_end,
  //             color: Colors.white,
  //             size: 35.0,
  //           ),
  //         ),
  //         RawMaterialButton(
  //           onPressed: () {
  //             rtcEngine.switchCamera();
  //           },
  //           shape: const CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //           child: const Icon(
  //             Icons.switch_camera,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  Widget controllerView() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              setState(() {
                isMute = !isMute;
              });
              // rtcEngine.muteLocalAudioStream(isMute);
              _engine.muteLocalAudioStream(isMute);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: isMute ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              isMute ? Icons.mic_off : Icons.mic,
              color: isMute ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              // rtcEngine.switchCamera();
              _engine.switchCamera();
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }

}
