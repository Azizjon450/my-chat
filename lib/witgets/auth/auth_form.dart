import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_chat/witgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Function getUserDetails;
  final bool isLoading;
  const AuthForm(this.getUserDetails, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _userData = {'email': '', 'username': '', 'password': ''};
  File? _userImage;
  var _isLogin = true;

  void _getUserImage(File userImage) {
    _userImage = userImage;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.black54, //Theme.of(context).colorScheme.error,
          content: Text('Plase, upload image'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.getUserDetails(
        _userData['email']!.trim(),
        _userData['username']!.trim(),
        _userData['password']!.trim(),
        _userImage,
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_getUserImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please, enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userData['email'] = newValue!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length <= 4) {
                          return 'Username must be more than 4 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _userData['username'] = newValue!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length <= 7) {
                        return 'Password must be more than 7 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userData['password'] = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple)),
                      child: Text(
                        _isLogin ? 'Log In' : 'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin ? 'Sign Up' : 'Log In'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
