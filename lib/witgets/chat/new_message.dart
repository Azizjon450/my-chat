import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        'username': userData.data()!['username'],
      });
      _messageController.clear();
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
