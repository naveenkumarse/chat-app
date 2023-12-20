import 'dart:convert'; 
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 

class Chatpage extends StatefulWidget {
  @override
  State<Chatpage> createState() => _ChatpageState();
}
enum Role {
  user,
  assistant,
}   

class _ChatpageState extends State<Chatpage> {
  final ChatUser currentUser =
      ChatUser(id: '1', firstName: "MUKIL", lastName: 's');
  final ChatUser gptUser = ChatUser(
      id: '2', firstName: "vijay", lastName: 's'); // Change the user id

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 166, 126, 1),
        title: Text(
          'Custom Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: currentUser,
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(0, 166, 126, 1),
          textColor: Colors.white,
        ),
        onSend: getChatResponse,
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(gptUser);
    });

    
    final apiUrl = 'http://10.1.32.47:8040/generate_text';

    
    final messageMap = {
      'text': m.text,
    };

    
    final messageJson = jsonEncode(messageMap);

    
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: messageJson,
    );

    if (response.statusCode == 200) {
      
      final List<dynamic> responseData = jsonDecode(response.body);

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: gptUser,
            createdAt: DateTime.now(),
            text: responseData[0],
          ),
        );
      });
    }

    setState(() {
      _typingUsers.remove(gptUser);
    });
  }
}
