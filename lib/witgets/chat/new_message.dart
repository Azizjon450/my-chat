import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewMessage extends StatefulWidget {
  NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  String? _message;
  User? user;
  late final userData;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      user = FirebaseAuth.instance.currentUser;
      userData =
          FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    });
    super.initState();
  }

  void _sendMessage() async {
    _formKey.currentState!.save();

    if (_message != null && _message!.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      final user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      FirebaseFirestore.instance.collection('chats').add({
        'text': _message,
        'timestamp': Timestamp.now(),
        'userId': user.uid,
        'userImage': userData.data()!['imageUrl'],
        'username': userData.data()!['username'],
      });

      _sendNotification(_message);
      _messageController.clear();
    }
  }

  void _sendNotification(message) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAXSd98H0:APA91bFh-LLQZHX2nVyFIzK8ZA1Wva_L_W35VqRKPNukhhVvvxhYCbOEWM2VSOlDMoTwmXzIa7iZRYUqMqLKLxB96joPtjrg4NhsArzdGWOZ7Spl57iaVH2jcyM989VMPpY3jfv94m7i',
    };
    final data = {
      'to': "/topics/flutterchat",
      'notification': {
        'title': 'New Notification',
        'body': message,
      }
    };

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      print(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                cursorColor: Colors.white,
                controller: _messageController,
                decoration: const InputDecoration(
                    labelText: 'Send message...', hoverColor: Colors.white30),
                onSaved: (value) {
                  _message = value;
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: IconButton(
                onPressed: _sendMessage,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
