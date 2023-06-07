import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
  NewMessage({super.key});

  final _formKey = GlobalKey<FormState>();
  String? _message;
  void _sendMessage() {
    _formKey.currentState!.save();

    if (_message != null && _message!.isNotEmpty) {

      // FirebaseFirestore.instance.collection('chats').add({
      //   'text': _message,
      //   'timestamp': Timestamp.now(),
      // });
      FirebaseFirestore.instance.collection('chats').add({'text': _message});
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
                decoration: const InputDecoration(labelText: 'Send message...'),
                onSaved: (value) {
                  _message = value;
                },
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
