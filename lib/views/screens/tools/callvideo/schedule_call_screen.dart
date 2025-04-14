import 'package:flutter/material.dart';
import 'package:health_care/views/screens/tools/callvideo/video_call_screen.dart';

class ScheduleCallScreen extends StatelessWidget {
  final TextEditingController _channelController = TextEditingController();

  ScheduleCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Channel')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                  labelText: 'Channel Name', hintText: 'Enter channel name'),
            ),
            ElevatedButton(
              onPressed: () => _joinChannel(context),
              child: const Text('Join'),
            )
          ],
        ),
      ),
    );
  }

  void _joinChannel(BuildContext context) {
    if (_channelController.text.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          channelName: _channelController.text,
        ),
      ),
    );
  }
}
