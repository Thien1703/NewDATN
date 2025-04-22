import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:health_care/common/app_colors.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;

  const VideoCallScreen({super.key, required this.channelName});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _agoraEngine;
  final List<int> _remoteUids = [];
  bool _isLocalUserMuted = false;
  bool _isLocalVideoDisabled = false;

  static const String appId = '4792f5bf117d4fd691389e63d525b6e0';
  static const String tokenServerUrl =
      'https://backend-healthcare-up0d.onrender.com/api/agora/token';
  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<String> _fetchToken(String channelName) async {
    final uri = Uri.parse('$tokenServerUrl?channelName=$channelName');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['token'];
    } else {
      throw Exception('Lỗi khi lấy token: ${response.body}');
    }
  }

  Future<void> _initializeAgora() async {
    _agoraEngine = createAgoraRtcEngine();

    await _agoraEngine.initialize(
      RtcEngineContext(appId: appId),
    );

    _agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('✅ Tham gia kênh thành công, UID: ${connection.localUid}');
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint('👤 Người dùng tham gia: $remoteUid');
          setState(() => _remoteUids.add(remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint('👋 Người dùng rời: $remoteUid');
          setState(() => _remoteUids.remove(remoteUid));
        },
        onError: (error, msg) {
          debugPrint('❌ Lỗi Agora: $error - $msg');
        },
      ),
    );

    await _agoraEngine.enableVideo();
    await _agoraEngine.startPreview();

    final token = await _fetchToken(widget.channelName); // 🔥 gọi token backend
    final int myUid = DateTime.now().millisecondsSinceEpoch.remainder(1000000);

    await _agoraEngine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: myUid,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              _isLocalUserMuted ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
            onPressed: _toggleMic,
          ),
          IconButton(
            icon: Icon(
              _isLocalVideoDisabled ? Icons.videocam_off : Icons.videocam,
              color: Colors.white,
            ),
            onPressed: _toggleCamera,
          ),
          IconButton(
            icon: const Icon(Icons.call_end),
            color: Colors.red,
            onPressed: _leaveChannel,
          ),
        ],
      ),
    );
  }

  void _toggleMic() {
    setState(() => _isLocalUserMuted = !_isLocalUserMuted);
    _agoraEngine.muteLocalAudioStream(_isLocalUserMuted);
  }

  void _toggleCamera() async {
    setState(() => _isLocalVideoDisabled = !_isLocalVideoDisabled);
    await _agoraEngine.muteLocalVideoStream(_isLocalVideoDisabled);

    if (_isLocalVideoDisabled) {
      await _agoraEngine.stopPreview(); // 🛑 Dừng xem trước camera
    } else {
      await _agoraEngine.startPreview(); // ✅ Bật lại camera khi mở
    }
  }

  Future<void> _leaveChannel() async {
    await _agoraEngine.leaveChannel();
    Navigator.of(context).pop();
  }

  Widget _renderLocalPreview() {
    if (_isLocalVideoDisabled) {
      return Container(
        color: Colors.black, // Màn hình đen
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.white, size: 40),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _agoraEngine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _renderRemoteViews() {
    if (_remoteUids.isEmpty) {
      return const Center(
        child: Text(
          'Đang chờ người tham gia...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (_remoteUids.length == 1) {
      return SizedBox.expand(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _agoraEngine,
            canvas: VideoCanvas(uid: _remoteUids[0]),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: _remoteUids.length,
      itemBuilder: (context, index) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _agoraEngine,
            canvas: VideoCanvas(uid: _remoteUids[index]),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Mã phòng khám: ${widget.channelName}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.deepBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _renderRemoteViews(),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    width: 120,
                    height: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _renderLocalPreview(),
                    ),
                  ),
                ],
              ),
            ),
            _buildControlPanel(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _agoraEngine.leaveChannel();
    _agoraEngine.release();
    super.dispose();
  }
}
