import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = streamSnapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (ctx, i) => Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(docs[i]['text']),
          ),
        );
      },
    );
  }
}
