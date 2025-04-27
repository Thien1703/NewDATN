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
  final Set<int> _mutedVideoUids = {}; // ✅ lưu uid bị tắt cam

  bool _isLocalUserMuted = false;
  bool _isLocalVideoDisabled = false;
  bool _isLocalFullscreen = false;

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

    await _agoraEngine.initialize(RtcEngineContext(appId: appId));

    _agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          _showSnackBar('Tham gia kênh thành công');
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          _showSnackBar('Bác sĩ tham gia');
          setState(() => _remoteUids.add(remoteUid));
        },
        onUserOffline: (connection, remoteUid, reason) {
          _showSnackBar('Bác sĩ rời');
          setState(() {
            _remoteUids.remove(remoteUid);
            _mutedVideoUids.remove(remoteUid);
          });
        },
        onUserMuteVideo: (connection, remoteUid, muted) {
          setState(() {
            if (muted) {
              _mutedVideoUids.add(remoteUid);
              _showSnackBar('Bác sĩ đã tắt camera');
            } else {
              _mutedVideoUids.remove(remoteUid);
              _showSnackBar('Bác sĩ đã bật lại camera');
            }
          });
        },
        onError: (error, msg) {
          _showSnackBar('❌ Lỗi Agora: $msg');
        },
      ),
    );

    await _agoraEngine.enableVideo();
    await _agoraEngine.startPreview();

    final token = await _fetchToken(widget.channelName);

    await _agoraEngine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  void _toggleMic() {
    setState(() => _isLocalUserMuted = !_isLocalUserMuted);
    _agoraEngine.muteLocalAudioStream(_isLocalUserMuted);
    _showSnackBar(_isLocalUserMuted ? '🎙️ Mic đã tắt' : '🎙️ Mic đã bật');
  }

  void _toggleCamera() async {
    setState(() => _isLocalVideoDisabled = !_isLocalVideoDisabled);
    await _agoraEngine.muteLocalVideoStream(_isLocalVideoDisabled);
    _showSnackBar(
        _isLocalVideoDisabled ? '📷 Camera đã tắt' : '📷 Camera đã bật');

    if (_isLocalVideoDisabled) {
      await _agoraEngine.stopPreview();
    } else {
      await _agoraEngine.startPreview();
    }
  }

  Future<void> _leaveChannel() async {
    await _agoraEngine.leaveChannel();
    Navigator.of(context).pop();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (_isLocalVideoDisabled) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.white, size: 40),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _isLocalFullscreen = !_isLocalFullscreen);
      },
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ),
    );
  }

  Widget _buildRemoteUserView(int uid) {
    if (_mutedVideoUids.contains(uid)) {
      // Người này đã tắt camera
      return Container(
        color: Colors.black,
        child: Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              'Bác sĩ', // Chữ đại diện user (có thể lấy từ tên userInfo nếu có)
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _agoraEngine,
          canvas: VideoCanvas(
            uid: uid,
            renderMode: RenderModeType.renderModeFit, // ✅ nằm trong VideoCanvas
          ),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    }
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
        child: _buildRemoteUserView(_remoteUids[0]),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: _remoteUids.length,
      itemBuilder: (context, index) {
        return _buildRemoteUserView(_remoteUids[index]);
      },
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(_isLocalUserMuted ? Icons.mic_off : Icons.mic,
                color: Colors.white),
            onPressed: _toggleMic,
          ),
          IconButton(
            icon: Icon(
                _isLocalVideoDisabled ? Icons.videocam_off : Icons.videocam,
                color: Colors.white),
            onPressed: _toggleCamera,
          ),
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: _leaveChannel,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Mã phòng khám: ${widget.channelName}'),
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
                    width: _isLocalFullscreen
                        ? MediaQuery.of(context).size.width
                        : 120,
                    height: _isLocalFullscreen
                        ? MediaQuery.of(context).size.height
                        : 160,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(_isLocalFullscreen ? 0 : 12),
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
