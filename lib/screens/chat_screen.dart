import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/5sBa51XgivUYJy7ZwJ57/messages')
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = streamSnapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (ctx, index) => Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(docs[index]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/5sBa51XgivUYJy7ZwJ57/messages')
              .add({'text': 'I\'m new message!'});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
