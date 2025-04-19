import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    // [1] Khởi tạo Agora Engine
    _agoraEngine = createAgoraRtcEngine();
    await _agoraEngine.initialize(RtcEngineContext(
      appId: '16c955b4c69d4b34a86feae9173e74a6', // Thay bằng App ID của bạn
    ));

    // [2] Đăng ký event handlers
    _agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('Local user joined: ${connection.localUid}');
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() => _remoteUids.add(remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() => _remoteUids.remove(remoteUid));
        },
        onError: (error, msg) {
          debugPrint('Error: $error $msg');
        },
      ),
    );

    // [3] Bật video và cấu hình
    await _agoraEngine.enableVideo();
    await _agoraEngine.startPreview();

    // [4] Join channel
    await _agoraEngine.joinChannel(
      token: "", // Dùng token null cho test mode
      channelId: widget.channelName,
      uid: 0, // 0 = auto-generate uid
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  // [5] UI Controls
  Widget _buildControlPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(_isLocalUserMuted ? Icons.mic_off : Icons.mic),
          onPressed: _toggleMic,
        ),
        IconButton(
          icon:
              Icon(_isLocalVideoDisabled ? Icons.videocam_off : Icons.videocam),
          onPressed: _toggleCamera,
        ),
        IconButton(
          icon: const Icon(Icons.call_end),
          color: Colors.red,
          onPressed: _leaveChannel,
        ),
      ],
    );
  }

  void _toggleMic() {
    setState(() => _isLocalUserMuted = !_isLocalUserMuted);
    _agoraEngine.muteLocalAudioStream(_isLocalUserMuted);
  }

  void _toggleCamera() {
    setState(() => _isLocalVideoDisabled = !_isLocalVideoDisabled);
    _agoraEngine.muteLocalVideoStream(_isLocalVideoDisabled);
  }

  Future<void> _leaveChannel() async {
    await _agoraEngine.leaveChannel();
    Navigator.pop(context);
  }

  // [6] Render Video Views
  Widget _renderLocalPreview() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _agoraEngine,
        canvas: const VideoCanvas(uid: 0),
      ), // Đóng đúng VideoViewController
    );
  }

  Widget _renderRemoteViews() {
    if (_remoteUids.isEmpty) {
      return Center(child: Text('Đang chờ người bên kia...'));
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

    // Nếu nhiều người thì chia theo GridView
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: _remoteUids.length,
      itemBuilder: (context, index) => AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _agoraEngine,
          canvas: VideoCanvas(uid: _remoteUids[index]),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mã phòng khám: ${widget.channelName}',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: AppColors.deepBlue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _renderRemoteViews(),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    width: 120,
                    height: 150,
                    child: _renderLocalPreview(),
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
