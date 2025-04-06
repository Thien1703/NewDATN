import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
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
      // appBar: AppBar(
      //   elevation: 1,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black87,
      //   title: Row(
      //     children: [
      //       const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
      //       const SizedBox(width: 8),
      //       Expanded(
      //         child: Text(
      //           widget.clinicName,
      //           style: const TextStyle(fontWeight: FontWeight.bold),
      //           overflow: TextOverflow.ellipsis,
      //         ),
      //       ),
      //       const SizedBox(width: 8),
      //       Icon(
      //         Icons.circle,
      //         size: 12,
      //         color: _isConnected ? Colors.green : Colors.red,
      //       ),
      //     ],
      //   ),
      // ),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(70), // Tăng chiều cao để có thêm khoảng trống
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20)), // Bo góc dưới
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, color: Colors.white, size: 28),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Phòng Khám ${widget.clinicName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isMe = msg['isMe'] == true;
                final time =
                    DateFormat.Hm().format(DateTime.parse(msg['time']));

                return Container(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blueAccent : Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['content'],
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize: 15,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 11,
                                color: isMe ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
