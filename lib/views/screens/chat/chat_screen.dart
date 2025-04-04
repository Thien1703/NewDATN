import 'package:flutter/material.dart';
import 'package:health_care/services/local_storage_service.dart';
import 'package:health_care/services/websocket/websocket_service.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int clinicId;
  final String clinicName;

  const ChatScreen({
    super.key,
    required this.clinicId,
    required this.clinicName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> messages = [];

  late WebSocketService _webSocketService;
  String? userId;

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    final token = await LocalStorageService.getToken();
    final id = await LocalStorageService.getUserId();
    userId = id?.toString();

    if (token != null && userId != null) {
      _webSocketService = WebSocketService(
        jwtToken: token,
        userId: userId!,
        onMessageReceived: (message) {
          print("📥 Tin nhắn mới: $message");

          setState(() {
            messages.add({
              'content': message['content'],
              'isMe': false,
              'time': message['timestamp'],
            });
          });

          _scrollToBottom();
        },
        onConnectionChange: (connected) {
          setState(() {
            _isConnected = connected;
          });

          print(connected
              ? '🟢 WebSocket Connected'
              : '🔴 WebSocket Disconnected');
        },
      );

      _webSocketService.connect();
      _webSocketService.subscribeToClinicChat(widget.clinicId.toString());
      _webSocketService.subscribeToPrivateChat(userId!);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || userId == null || !_isConnected) {
      print("⚠️ Không thể gửi. WebSocket chưa kết nối.");
      return;
    }

    _webSocketService.sendChatMessage(
      senderId: userId!,
      clinicId: widget.clinicId.toString(),
      content: text,
    );

    setState(() {
      messages.add({
        'content': text,
        'isMe': true,
        'time': DateTime.now().toIso8601String(),
      });
    });

    _controller.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('💬 ${widget.clinicName}'),
            const SizedBox(width: 8),
            Icon(
              Icons.circle,
              size: 12,
              color: _isConnected ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isMe = msg['isMe'] == true;
                final time =
                    DateFormat.Hm().format(DateTime.parse(msg['time']));

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['content'],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
