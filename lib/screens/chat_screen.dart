import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/witgets/chat/messages.dart';
import 'package:my_chat/witgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Chat'),
        actions: [
          DropdownButton(
              icon: const Icon(Icons.more_vert),
              items: const [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Exit'),
                    ],
                  ),
                ),
              ],
              onChanged: (selectedItem) {
                if (selectedItem == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
