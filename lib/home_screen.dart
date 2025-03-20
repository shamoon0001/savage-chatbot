import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.insert(0, {"sender": "You", "message": userMessage});
      _isLoading = true;
    });

    _controller.clear();
    FocusScope.of(context).unfocus();

    try {
      final response = await http.get(
        Uri.parse('http://192.168.27.238:8000/chatbot-response/?message=$userMessage'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _messages.insert(0, {
            "sender": "ShanaAi",
            "message": responseData['bot_response']
          });
        });
      } else {
        setState(() {
          _messages.insert(0, {
            "sender": "ShanaAi",
            "message": "Error: ${response.statusCode} - Unable to fetch response!"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.insert(0, {
          "sender": "ShanaAi",
          "message": "Oops! Something went wrong. Check your network."
        });
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _openHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        centerTitle: true,
        title: const Text(
          "ShanaAi",
        style: TextStyle(
          color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.blueAccent,size: 30,),
            onPressed: _openHistoryScreen, // Opens history screen
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]["sender"] == "You";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${_messages[index]["sender"]}: ${_messages[index]["message"]}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,fontFamily: 'sans-serif',),

                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Roast me...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: _sendMessage,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}