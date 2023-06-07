import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/screens/auth_screen.dart';
import 'package:my_chat/screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialization,
        builder: (ctx, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Chat',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, AsyncSnapshot<User?> userSnapshot) {
                  if (userSnapshot.hasData) {
                    return const ChatScreen();
                  }
                  return const AuthScreen();
                }),
          );
        });
  }
}
