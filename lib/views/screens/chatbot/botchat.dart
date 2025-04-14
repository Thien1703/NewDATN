import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final String _apiKey =
      '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';
  final String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: _controller.text, isUser: true));
      _isLoading = true;
    });

    final userMessage = _controller.text;
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'user',
              'content': '$userMessage. Hãy trả lời bằng tiếng Việt'
            }
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add(ChatMessage(text: aiResponse, isUser: false));
        });
      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Icon(Icons.smart_toy, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Chat bot hỗ trợ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return _buildLoadingIndicator();
                }
                return _messages[index];
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          SpinKitThreeBounce(color: Colors.blue, size: 20.0),
          SizedBox(width: 10),
          Text('Đang xử lý...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
