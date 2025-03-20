import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<Map<String, String>> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.27.238:8000/chat-history/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> history = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _chatHistory = history.map((chat) => {
            "sender": chat['sender'].toString(),
            "message": chat['message'].toString(),
          }).toList();
        });
      }
    } catch (e) {
      // Handle errors
      print("Error fetching chat history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
            "Chat History",
                style: TextStyle(
            color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blueAccent, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: "Go Back",
          ),
       ),
    ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _chatHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _chatHistory[index]["sender"]!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _chatHistory[index]["message"]!,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
