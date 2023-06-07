import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/witgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _getUserDetails(String userEmail, String username, String userpassword,
      bool isLogin) async {
    UserCredential userCredetial;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        userCredetial = await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userpassword,
        ); //sign in
      } else {
        userCredetial = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userpassword,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredetial.user!.uid)
            .set({'username': username, 'email': userEmail});
      }
    } on FirebaseException catch (e) {
      var message = 'Sorry, network error, please, try again!';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_getUserDetails, _isLoading),
    );
  }
}
