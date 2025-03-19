import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePostPage extends StatefulWidget {
  final int userId;
  final String userName;

  CreatePostPage({required this.userId, required this.userName});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();

  Future<void> _submitPost() async {
    final String content = _postController.text;

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post content cannot be empty'),
      ));
      return;
    }

    final response = await http.post(
      //Uri.parse('http://192.168.0.105:5001/create_post'),
      Uri.parse('http://192.168.0.105:5001/create_post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': widget.userId,
        'user_name': widget.userName,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, content);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create post'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Color(0xFF2E481E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitPost,
              icon: Icon(Icons.send, color: Colors.white),
              label: Text('Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF264E36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}