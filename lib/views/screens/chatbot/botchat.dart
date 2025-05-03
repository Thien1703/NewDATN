import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care/common/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  // final String _apiKey =
  //     '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';
  // final String _apiUrl = 'https://openrouter.ai/api/v1/auth/keys';

  final List<String> _suggestedQuestions = [
    'Tôi nên ăn gì để tăng sức đề kháng?',
    'Làm sao để ngủ ngon hơn mỗi đêm?',
    'Các dấu hiệu ban đầu của tiểu đường là gì?',
    'Cách phòng tránh bệnh cảm cúm hiệu quả?',
    'Tôi có nên tập thể dục khi đang bị cảm không?',
    'Thực phẩm nào giúp giảm căng thẳng?',
    'Tôi nên khám sức khỏe tổng quát bao lâu một lần?',
    'Tôi cần làm gì khi bị cao huyết áp?',
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages(); // 👈 Tải lịch sử khi khởi động
  }

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
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization':
              'Bearer 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', // <- Thay bằng API Key từ OpenRouter
          'Content-Type': 'application/json',
          'HTTP-Referer':
              'https://example.com', // <- Bắt buộc, có thể ghi tạm domain
          'X-Title': 'HealthCareAI',
        },
        body: jsonEncode({
          "model": "mistralai/mistral-7b-instruct",
          "max_tokens": 300, // 👈 Tối đa 300 token (khoảng 200-250 từ)
          "messages": [
            {
              "role": "user",
              "content": "Trả lời câu hỏi sau bằng tiếng Việt: $userMessage"
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final aiResponse = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add(ChatMessage(text: aiResponse, isUser: false));
        });
        _saveMessages();
      } else {
        print('❌ Lỗi chi tiết: ${response.body}');
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

  void _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatData = _messages
        .map((e) => jsonEncode({
              'text': e.text,
              'isUser': e.isUser,
            }))
        .toList();
    await prefs.setStringList('chat_history', chatData);
  }

  void _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatData = prefs.getStringList('chat_history');

    if (chatData != null) {
      setState(() {
        _messages.clear();
        _messages.addAll(chatData.map((e) {
          final decoded = jsonDecode(e);
          return ChatMessage(text: decoded['text'], isUser: decoded['isUser']);
        }).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.deepBlue,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
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
          _buildSuggestedQuestions(),
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

  Widget _buildSuggestedQuestions() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _suggestedQuestions.map((question) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: ElevatedButton(
              onPressed: () {
                _controller.text = question;
                _sendMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                question,
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        }).toList(),
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
          utf8.decode(utf8.encode(text)),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
